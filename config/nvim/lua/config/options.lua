local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 6
opt.sidescrolloff = 8

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("Ic")

opt.path:append("**")
opt.wildmode = { "longest:full", "full" }
opt.wildignore:append({ ".git", "node_modules", ".DS_Store" })

opt.laststatus = 3
opt.pumblend = 10

opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

vim.cmd.colorscheme("claude")
