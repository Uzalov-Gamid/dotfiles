return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript",
        "tsx", "json", "yaml", "markdown", "markdown_inline", "go", "html", "css",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ❯ ",
        selection_caret = " ❯ ",
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false,
    },
    keys = {
      { "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Prev hunk" },
    },
  },
  { "numToStr/Comment.nvim", event = { "BufReadPost", "BufNewFile" }, opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "kylechui/nvim-surround", event = { "BufReadPost", "BufNewFile" }, opts = {} },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    },
    opts = {},
  },
}
