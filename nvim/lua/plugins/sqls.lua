return {
  "nanotee/sqls.nvim",
  ft = "sql",
  config = function()
    vim.lsp.enable("sqls", false)
  end,
}
