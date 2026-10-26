-- Markdown: soft-wrap long lines at word boundaries, keep the indent of
-- wrapped list items, 2-space lists.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true

-- with wrap on, j/k move by screen line, not by paragraph
vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

-- <leader>r: open the file in the default Markdown app (preview)
vim.keymap.set("n", "<leader>r", function()
  vim.cmd.write()
  vim.fn.jobstart({ "open", vim.fn.expand("%:p") })
end, { buffer = true, desc = "Open in Markdown app" })
