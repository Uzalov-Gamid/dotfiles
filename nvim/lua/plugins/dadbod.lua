return {
  {
    "tpope/vim-dadbod",
    ft = { "sql", "mysql", "plsql" },
    keys = {
      {
        "<leader>DE",
        "<cmd>%DB<cr>",
        mode = "n",
        desc = "Execute whole SQL file",
      },
      {
        "<leader>DE",
        ":'<,'>DB<cr>",
        mode = "x",
        desc = "Execute selected SQL",
      },
    },
    init = function()
      vim.g.db_ui_execute_on_save = false
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    -- The SQL extra adds this plugin and wires it into blink.cmp. Keep the
    -- plugin disabled while removing that wiring below so the rest of
    -- blink.cmp remains available for every filetype.
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local sources = opts.sources or {}
      local defaults = sources.default or {}
      local providers = sources.providers or {}

      sources.default = vim.tbl_filter(function(source)
        return source ~= "dadbod"
      end, defaults)
      providers.dadbod = nil
    end,
  },
}
