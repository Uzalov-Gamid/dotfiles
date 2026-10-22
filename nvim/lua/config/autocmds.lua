-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/ghostty/config.ghostty",
  callback = function()
    vim.bo.filetype = "conf"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*yabairc",
  callback = function()
    vim.bo.filetype = "conf"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*skhdrc",
  callback = function()
    vim.bo.filetype = "conf"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    vim.cmd("vertical resize 26")
    vim.wo.winfixwidth = true
  end,
})
vim.g.db_ui_disable_mappings = 0
vim.g.db_ui_disable_mappings_sql = 1
