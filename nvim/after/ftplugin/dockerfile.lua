-- Dockerfile: 4 spaces for continued RUN lines,
-- <leader>r builds the image from the folder the Dockerfile is in.
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true

vim.keymap.set("n", "<leader>r", function()
  local file = vim.fn.expand("%")
  run_in_terminal("docker build -f " .. vim.fn.shellescape(file) .. " " .. vim.fn.shellescape(vim.fn.fnamemodify(file, ":h")))
end, { buffer = true, desc = "docker build" })
