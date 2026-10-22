return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = { width = 30 },
    filesystem = {
      -- filtered_items = {
      --   hide_dotfiles = false,
      --   hide_gitignored = false,
      --   hide_by_name = {
      --     ".git",
      --   },
      -- },
      filtered_items = {
        -- visible = true,
        hide_gitignored = false,
        hide_dotfiles = false,
        hide_by_name = {
          ".git",
          ".venv",
        },
      },
      components = {
        name = function(config, node, state)
          if node.type == "root" or node:get_depth() == 1 then
            local name = vim.fn.fnamemodify(node.path, ":t")
            return {
              text = name ~= "" and name or node.path,
              highlight = config.highlight or "NeoTreeRootName",
            }
          end
          return require("neo-tree.sources.filesystem.components").name(config, node, state)
        end,
      },
    },
  },
}
