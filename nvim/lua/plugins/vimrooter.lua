return {
  {
    "airblade/vim-rooter",
    init = function()
      -- vim.g.rooter_patterns = { ".git" }

      vim.g.rooter_patterns = { ".git", "Makefile", "package.json", "go.mod" }

      vim.g.rooter_change_directory_for_non_project_files = "current"

      -- отключить лишние сообщения в консоли при смене директории
      vim.g.rooter_silent_chdir = 1
    end,
  },
}
