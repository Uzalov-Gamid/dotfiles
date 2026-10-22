return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>D", group = "DB Manager", icon = "󰆼" },
      },
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle" },
    ft = { "sql", "mysql" },
    keys = {
      { "<leader>D", false },
      {
        "<leader>Du",
        function()
          _G.toggle_dbui()
        end,
        desc = "Toggle DBUI",
      },
      {
        "<leader>Ds",
        function()
          _G.switch_database()
        end,
        desc = "Switch Active Database",
      },
      {
        "<leader>Dr",
        function()
          _G.reload_db_schema()
        end,
        desc = "Reload DB Schema (LSP)",
      },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_disable_completion = 1
      vim.g.db = ""
    end,
    config = function()
      local state_file = vim.fn.stdpath("state") .. "/db_manager_last.json"
      local sqls_cfg_file = vim.fn.stdpath("state") .. "/sqls-db-manager.yml"
      local active_url = nil
      local restart_token = 0

      -- Copy this file to db_private.lua and fill in your database credentials.
      --
      -- return {
      --   ["first-db"] = {
      --     driver = "postgres",
      --     user = "your_user",
      --     password = "your_password",
      --     host = "localhost",
      --     port = 5432,
      --     database = "your_database",
      --   },
      --
      --   ["second-db"] = {
      --     driver = "postgres",
      --     user = "your_user",
      --     password = "your_password",
      --     host = "localhost",
      --     port = 5432,
      --     database = "your_database",
      --   },
      -- }
      local databases = require("config.db_private")

      local function save_state(key)
        local f = io.open(state_file, "w")
        if f then
          f:write(vim.fn.json_encode({ last_key = key }))
          f:close()
        end
      end

      local function load_state()
        local f = io.open(state_file, "r")
        if not f then
          return next(databases)
        end
        local ok, data = pcall(vim.fn.json_decode, f:read("*a"))
        f:close()
        return (ok and data and databases[data.last_key]) and data.last_key or next(databases)
      end

      local function sqls_settings(url)
        return { sqls = { connections = { { driver = "postgresql", dataSourceName = url } } } }
      end

      local function database_url(cfg)
        return string.format(
          "%s://%s:%s@%s:%d/%s",
          cfg.driver,
          cfg.user,
          cfg.password,
          cfg.host,
          cfg.port,
          cfg.database
        )
      end

      local function all_database_urls()
        local urls = {}
        for name, cfg in pairs(databases) do
          urls[name] = database_url(cfg)
        end
        return urls
      end

      local function dbui_is_open()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "dbui" then
            return true
          end
        end
        return false
      end

      local dbui_win = nil

      local function find_dbui_win()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "dbui" then
            return win
          end
        end
        return nil
      end

      local function ensure_dbui_left()
        local win = find_dbui_win()
        if not win then
          return
        end
        if vim.api.nvim_win_get_config(win).relative then
          return
        end
        local pos = vim.api.nvim_win_get_position(win)
        if pos[2] > 0 then
          vim.cmd(win .. "wincmd H")
        end
        vim.wo[win].winfixwidth = true
        vim.cmd(win .. "wincmd |")
        vim.cmd("vertical resize 26")
      end

      local function open_dbui_sidebar()
        vim.g.dbs = all_database_urls()
        local current_db = vim.g.db
        vim.g.db = ""
        vim.cmd("DBUI")
        vim.g.db = current_db
        vim.defer_fn(ensure_dbui_left, 50)
      end

      local function refresh_dbui()
        if vim.fn.exists(":DBUI") == 0 then
          return
        end
        local was_open = dbui_is_open()
        local current_db = vim.g.db
        if was_open then
          vim.cmd("silent! DBUIClose")
        end
        vim.g.dbs = all_database_urls()
        vim.g.db = ""
        vim.fn["db_ui#reset_state"]()
        if was_open then
          open_dbui_sidebar()
        end
        vim.g.db = current_db
      end

      _G.toggle_dbui = function()
        local was_open = dbui_is_open()
        if was_open then
          vim.cmd("silent! DBUIClose")
          return
        end
        open_dbui_sidebar()
      end

      local function escape_yaml_string(s)
        return (s:gsub("\\", "\\\\"):gsub('"', '\\"'))
      end

      local function write_sqls_runtime_config(url)
        local f = io.open(sqls_cfg_file, "w")
        if not f then
          error("Cannot write sqls config")
        end
        local dsn = escape_yaml_string(url)
        f:write('connections:\n  - driver: postgresql\n    dataSourceName: "' .. dsn .. '"\n')
        f:close()
      end

      local function stop_all_sqls_clients()
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.name == "sqls" or vim.startswith(client.name, "db-manager-") then
            for buf, _ in pairs(client.attached_buffers) do
              vim.lsp.buf_detach_client(buf, client.id)
            end
            client:stop(true)
          end
        end
        os.execute("pkill -f 'sqls' >/dev/null 2>&1")
      end

      local function wait_for_sqls_stop(callback, attempts)
        attempts = attempts or 20

        if attempts <= 0 then
          callback()
          return
        end

        local clients = vim.tbl_filter(function(client)
          return client.name == "sqls" or vim.startswith(client.name, "db-manager-")
        end, vim.lsp.get_clients())

        if #clients == 0 then
          callback()
          return
        end

        vim.defer_fn(function()
          wait_for_sqls_stop(callback, attempts - 1)
        end, 100)
      end

      local function attach_sqls_to_buffer(buf, url)
        if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].filetype ~= "sql" then
          return
        end

        local current_name = "db-manager-sqls-" .. restart_token

        vim.lsp.start({
          name = current_name,
          cmd = { "sqls", "-config", sqls_cfg_file },
          root_dir = vim.fn.getcwd(),
          settings = sqls_settings(url),
        }, {
          bufnr = buf,
          reuse_client = function(client)
            return client.name == current_name
          end,
        })
      end

      local function prepare_dbui_buffer(buf)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.b[buf].dbui_db_key_name then
          return false
        end
        local url = vim.b[buf].db
        if type(url) ~= "string" or url == "" then
          return true
        end

        local client_name = "db-manager-dbui-sqls-" .. buf .. "-" .. restart_token
        local config_file = vim.fn.stdpath("state") .. "/sqls-dbui-" .. buf .. ".yml"

        local f = io.open(config_file, "w")
        if f then
          local dsn = escape_yaml_string(url)
          f:write('connections:\n  - driver: postgresql\n    dataSourceName: "' .. dsn .. '"\n')
          f:close()
        end

        for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
          if client.name == "sqls" or vim.startswith(client.name, "db-manager-") then
            vim.lsp.buf_detach_client(buf, client.id)
            client:stop(true)
          end
        end

        vim.defer_fn(function()
          if not vim.api.nvim_buf_is_valid(buf) then
            return
          end
          vim.lsp.start({
            name = client_name,
            cmd = { "sqls", "-config", config_file },
            root_dir = vim.fn.getcwd(),
            settings = sqls_settings(url),
          }, {
            bufnr = buf,
            reuse_client = function(client)
              return client.name == client_name
            end,
          })
        end, 250)
        return true
      end

      local function restart_sqls(url)
        restart_token = restart_token + 1
        local token = restart_token

        stop_all_sqls_clients()

        vim.defer_fn(function()
          wait_for_sqls_stop(function()
            if token ~= restart_token then
              return
            end

            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "sql" then
                if vim.b[buf].dbui_db_key_name then
                  prepare_dbui_buffer(buf)
                else
                  attach_sqls_to_buffer(buf, url)
                end
              end
            end
          end)
        end, 200)
      end

      local function apply_db(key)
        local cfg = databases[key]
        if not cfg then
          return
        end

        local ok, err = pcall(function()
          local pwd = cfg.password
          if not pwd or pwd == "" then
            pwd = vim.fn.inputsecret("Password: ")
          end
          local dbname = cfg.database
          if not dbname or dbname == "" then
            dbname = vim.fn.input("DB name: ")
          end
          if not dbname or dbname == "" then
            dbname = "postgres"
          end

          local url = database_url(vim.tbl_extend("force", cfg, { password = pwd, database = dbname }))
          active_url = url

          vim.g.dbs = all_database_urls()
          vim.g.db = url
          refresh_dbui()
          vim.g.db = url

          write_sqls_runtime_config(url)
          restart_sqls(url)
          save_state(key)

          vim.notify(
            string.format("Connected to [%s] -> %s", key, dbname),
            vim.log.levels.INFO,
            { title = "DB Manager" }
          )
        end)
        if not ok then
          vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
        end
      end

      _G.switch_database = function()
        local keys = vim.tbl_keys(databases)
        table.sort(keys)
        vim.ui.select(keys, { prompt = "Select Active Database:" }, function(choice)
          if choice then
            vim.schedule(function()
              apply_db(choice)
            end)
          end
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("DbManagerSqlsAttach", { clear = true }),
        pattern = "sql",
        callback = function(args)
          vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then
              return
            end
            if prepare_dbui_buffer(args.buf) then
              return
            end
            if active_url then
              attach_sqls_to_buffer(args.buf, active_url)
            end
          end, 50)
        end,
      })

      _G.reload_db_schema = function()
        if not active_url then
          vim.notify("No active database connection", vim.log.levels.WARN, { title = "DB Manager" })
          return
        end
        restart_sqls(active_url)
        vim.notify("DB Schema & SQLS reloaded!", vim.log.levels.INFO, { title = "DB Manager" })
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group = vim.api.nvim_create_augroup("DbManagerDbuiCompletion", { clear = true }),
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "sql" and vim.b[buf].dbui_db_key_name then
              prepare_dbui_buffer(buf)
            end
          end, 0)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("DbManagerDisableDefaultSqls", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "sqls" then
            client:stop(true)
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("DbManagerDbuiQuery", { clear = true }),
        pattern = "DBUIOpened",
        callback = function()
          vim.defer_fn(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "sql" then
                prepare_dbui_buffer(buf)
              end
            end
          end, 100)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("DbManagerSqlMappings", { clear = true }),
        pattern = "sql",
        callback = function(args)
          vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then
              return
            end
            if not vim.b[args.buf].dbui_db_key_name then
              return
            end
            local opts = { buffer = args.buf, silent = true }
            vim.keymap.set("n", "<leader>E", "<Plug>(DBUI_EditBindParameters)", opts)
            vim.keymap.set("n", "<leader>W", "<Plug>(DBUI_SaveQuery)", opts)
            vim.keymap.set({ "n", "v" }, "<leader>S", "<Plug>(DBUI_ExecuteQuery)", opts)
          end, 50)
        end,
      })

      vim.schedule(function()
        apply_db(load_state())
      end)
    end,
  },
}
