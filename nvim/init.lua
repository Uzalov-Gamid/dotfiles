-- Minimal Neovim config: no plugins, no LSP, no autocompletion, no
-- error underlining, no auto-formatting — you write and check the code
-- yourself. Only things that make editing comfortable.
--
--   init.lua                 — everything that applies to all files
--   after/ftplugin/<ft>.lua  — per-language settings (indent width, how
--                              <leader>r runs the file, …)
--   lua/tree.lua             — the project tree (<leader>e)
--   colors/palette.lua       — the colour scheme

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

-- defaults; each language overrides them in after/ftplugin/, and a
-- project's .editorconfig (supported out of the box) overrides both
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
opt.confirm = true            -- ask to save instead of refusing to quit

-- tabs, trailing spaces and indent guides (the "│" every indent level)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- folds by indentation (YAML, Python…), all open by default.
-- za = toggle fold, zM = close all, zR = open all
opt.foldmethod = "indent"
opt.foldlevel = 99

-- ── Finding things (built in, no plugins) ───────────────────────────
opt.path:append("**")         -- :find searches the whole project
opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/.venv/*", "*/__pycache__/*", "*.o", "*.pyc" })
opt.wildmode = "longest:full,full"
opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git"
opt.grepformat = "%f:%l:%c:%m"

-- netrw (built-in browser, :Explore): no banner, tree view, no ./ and ../
-- The project tree on <leader>e is lua/tree.lua.
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = [[^\.\.\=/\=$]]
vim.g.netrw_hide = 1

-- ── File types ───────────────────────────────────────────────────────
-- fix what Neovim guesses wrong for this stack
vim.filetype.add({
  extension = {
    h = "c",                  -- C headers, not C++
    tf = "terraform",         -- not TinyFugue
    tfvars = "terraform",
    j2 = "jinja",             -- Ansible / Jinja templates
  },
})

-- ── Keymaps ──────────────────────────────────────────────────────────
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>e", function() require("tree").toggle() end, { desc = "Project tree" })

-- finding: file by name, text in the project, open buffers
map("n", "<leader>f", ":find ", { desc = "Find file (Tab completes)" })
map("n", "<leader>g", ":silent grep! ", { desc = "Search text in project" })
map("n", "<leader>b", ":ls<cr>:buffer ", { desc = "Switch buffer" })
-- grep results open in the quickfix list: ]q / [q jump between them
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "grep",
  command = "cwindow",
})

-- move between splits with Ctrl-h/j/k/l (same keys as tmux panes)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- resize the current split with Shift + arrows (Ctrl-w = makes them equal)
map("n", "<S-Left>", "<cmd>vertical resize -4<cr>", { desc = "Narrower" })
map("n", "<S-Right>", "<cmd>vertical resize +4<cr>", { desc = "Wider" })
map("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Taller" })
map("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Shorter" })

-- move selected lines up/down, keep the selection
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- keep the selection when indenting with < and >
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste over a selection without losing what you copied
map("x", "p", "P", { desc = "Paste, keep register" })

-- keep the cursor in the middle when jumping half pages / through search
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- ── Terminal & running code ──────────────────────────────────────────
-- <leader>t: a terminal at the bottom. Esc Esc leaves terminal mode.
map("n", "<leader>t", "<cmd>botright 12split | terminal<cr>", { desc = "Terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.list = false
    -- read-only outputs (Markdown preview) are not typed into
    if not vim.b[args.buf].no_insert then
      vim.cmd.startinsert()
    end
  end,
})

-- Save the file and run `cmd` in a terminal split at the bottom. Each
-- language sets what <leader>r runs in after/ftplugin/<ft>.lua.
function _G.run_in_terminal(cmd)
  vim.cmd.write()
  vim.cmd("botright 12split")
  vim.cmd.terminal(cmd)
end

-- ── Autocommands ─────────────────────────────────────────────────────
-- briefly highlight what you just yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- reopen a file where you left it
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- strip trailing spaces on save (not in Markdown: two spaces = line break)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.bo.filetype ~= "markdown" then
      local view = vim.fn.winsaveview()
      vim.cmd([[keeppatterns %s/\s\+$//e]])
      vim.fn.winrestview(view)
    end
  end,
})

-- indent guides: a "│" at every indent level, following the buffer's
-- shiftwidth (2 in YAML, 4 in Python…)
local function indent_guides()
  local sw = vim.fn.shiftwidth()
  vim.opt_local.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
    leadmultispace = "│" .. string.rep(" ", sw - 1),
  }
end
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  callback = function()
    vim.schedule(indent_guides) -- after after/ftplugin has set shiftwidth
  end,
})
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = { "shiftwidth", "tabstop" },
  callback = indent_guides,
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

-- Status line: [ MODE ] file [+]                 filetype  line:col  %
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
    "%y  %l:%c  %p%% ",
  })
end

opt.statusline = "%!v:lua.statusline()"
opt.laststatus = 3 -- one status line for all splits
