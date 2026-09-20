vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-tree owns file browsing; netrw would only get in the way.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
