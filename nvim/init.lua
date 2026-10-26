-- Minimal Neovim config: no plugins, no LSP. Everything is in this file
-- (+ the colour scheme in colors/palette.lua), so it is easy to read and
-- to grow into your own setup later.

-- ── Leader ───────────────────────────────────────────────────────────
-- Must be set before any mapping that uses <leader>.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Options ──────────────────────────────────────────────────────────
local opt = vim.opt

opt.number = true             -- line numbers
opt.relativenumber = true     -- relative numbers: easy `5j`, `12k`
opt.cursorline = true         -- highlight the current line
opt.signcolumn = "yes"        -- keep a fixed column on the left
opt.scrolloff = 6             -- keep lines visible above/below the cursor
opt.sidescrolloff = 8
opt.wrap = false

opt.expandtab = true          -- spaces instead of tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

opt.ignorecase = true         -- search ignores case...
opt.smartcase = true          -- ...unless you type a capital letter

opt.splitright = true         -- :vsplit opens on the right
opt.splitbelow = true         -- :split opens below
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- y / p use the macOS clipboard
opt.undofile = true           -- undo history survives closing the file
opt.updatetime = 250
opt.termguicolors = true      -- 24-bit colours (Ghostty supports them)
opt.showmode = false          -- the mode is shown in the status line
opt.list = true               -- show tabs and trailing spaces
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ── Keymaps ──────────────────────────────────────────────────────────
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File browser (netrw)" })

-- move between splits with Ctrl-h/j/k/l (same keys as tmux panes)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- move selected lines up/down, keep the selection
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- paste over a selection without losing what you copied
map("x", "p", "P", { desc = "Paste, keep register" })

-- keep the cursor in the middle when jumping half pages / through search
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- ── Autocommands ─────────────────────────────────────────────────────
-- briefly highlight what you just yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- ── Syntax highlighting ──────────────────────────────────────────────
-- Neovim ships tree-sitter parsers for Lua, C, Vimscript, Markdown and
-- help files: those get precise highlighting. Every other language uses
-- Neovim's built-in regex syntax, coloured by the same theme.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- ── Look ─────────────────────────────────────────────────────────────
vim.cmd.colorscheme("palette")

-- Status line: [ MODE ] file [+]                        line:col  %
local modes = {
  n = { "NORMAL", "StatusMode" },
  i = { "INSERT", "StatusModeInsert" },
  v = { "VISUAL", "StatusModeVisual" },
  V = { "V-LINE", "StatusModeVisual" },
  ["\22"] = { "V-BLOCK", "StatusModeVisual" },
  c = { "COMMAND", "StatusModeCommand" },
  R = { "REPLACE", "StatusModeInsert" },
  t = { "TERMINAL", "StatusModeInsert" },
}

function _G.statusline()
  local m = modes[vim.fn.mode():sub(1, 1)] or modes.n
  return table.concat({
    "%#" .. m[2] .. "# " .. m[1] .. " %*",
    " %f %m",
    "%=",
    "%l:%c  %p%% ",
  })
end

opt.statusline = "%!v:lua.statusline()"
opt.laststatus = 3 -- one status line for all splits
