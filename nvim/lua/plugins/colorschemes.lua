return {
  -- set default theme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-macchiato",
      colorscheme = "gruvbox",
      -- colorscheme = "tokyonight",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- priority = 1000, -- set priority only for theme used rn
    opts = {
      transparent_background = false,
    },
  },
  { "rebelot/kanagawa.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      -- transparent_mode = true,
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
    },
  },
}
