-- C: 4 spaces, a guide at column 80. A project's .editorconfig wins.
-- <leader>r: `make` if there is a Makefile, otherwise compile this file
-- with the School 21 flags and run it.
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.cindent = true
vim.opt_local.colorcolumn = "80"
vim.opt_local.commentstring = "// %s"

vim.keymap.set("n", "<leader>r", function()
  if vim.fn.filereadable("Makefile") == 1 then
    run_in_terminal("make")
  else
    local src = vim.fn.shellescape(vim.fn.expand("%"))
    local bin = vim.fn.shellescape(vim.fn.tempname())
    run_in_terminal("cc -Wall -Wextra -Werror -std=c11 " .. src .. " -o " .. bin .. " && " .. bin)
  end
end, { buffer = true, desc = "Build & run (make or cc)" })
