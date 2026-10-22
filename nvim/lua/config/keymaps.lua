-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("x", "P", "p")
map("x", "p", "P")

map("n", "a", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "a"
  end
end, { expr = true, desc = "Smart Append" })

vim.keymap.set("i", "<C-j>", function()
  if vim.lsp.inline_completion and vim.lsp.inline_completion.get() then
    local inline = vim.lsp.inline_completion
    if inline.accept then
      inline.accept()
    else
      vim.api.nvim_feedkeys(inline.trigger() or "", "n", true)
    end
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-j>", true, true, true), "n", true)
  end
end, { desc = "Copilot Native Accept" })

vim.api.nvim_create_user_command("Dash", function()
  Snacks.dashboard()
end, { desc = "Open Dashboard" })

vim.cmd("cnoreabbrev dash Dash")
