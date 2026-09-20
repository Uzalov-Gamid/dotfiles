local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>t", "<cmd>belowright split | terminal<cr>", { desc = "Terminal" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })
map("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("t", "<esc><esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
