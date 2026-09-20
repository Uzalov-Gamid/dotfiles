return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local c = {
        bg = "#1c1c1c", base = "#161616", fg = "#d7d7d7", dim = "#666666",
        accent = "#d97757", red = "#b36a6a", green = "#7d9a72",
        yellow = "#b09a6a", blue = "#7289a8",
      }
      local theme = {
        normal = {
          a = { fg = c.base, bg = c.accent, gui = "bold" },
          b = { fg = c.fg, bg = c.bg },
          c = { fg = c.dim, bg = c.base },
        },
        insert = { a = { fg = c.base, bg = c.green, gui = "bold" } },
        visual = { a = { fg = c.base, bg = c.blue, gui = "bold" } },
        replace = { a = { fg = c.base, bg = c.red, gui = "bold" } },
        command = { a = { fg = c.base, bg = c.yellow, gui = "bold" } },
        inactive = {
          a = { fg = c.dim, bg = c.base },
          b = { fg = c.dim, bg = c.base },
          c = { fg = c.dim, bg = c.base },
        },
      }
      return {
        options = {
          theme = theme,
          component_separators = "",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = "rounded" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = { filetypes = { "help", "lazy", "mason", "NvimTree", "trouble" } },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    opts = {
      view = { width = 32 },
      renderer = {
        group_empty = true,
        icons = { show = { git = true, folder = true, file = true, folder_arrow = false } },
      },
      filters = { dotfiles = false },
      git = { enable = true },
    },
  },
}
