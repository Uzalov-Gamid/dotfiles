return {
  {
    "nvim-telescope/telescope.nvim",

    opts = {
      defaults = {
        prompt_prefix = " s: ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = { "%.venv", "node_modules", "%.git/", "%.DS_Store" },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "insert",
          no_ignore = true,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "insert",
        },
      },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
