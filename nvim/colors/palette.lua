-- "palette": a tiny Gruvbox colour scheme in the same colours as the
-- SketchyBar theme (sketchybar/colors.lua). No plugin — just highlight
-- groups. The background is left to the terminal (Ghostty), so Neovim
-- blends in with it.
--
-- To change a colour: edit `c` below, then `:colorscheme palette`.

vim.cmd("highlight clear")
vim.g.colors_name = "palette"
vim.o.background = "dark"

local c = {
  fg = "#d4be98",      -- main text (cream)
  grey = "#928374",    -- comments, inactive things
  dim = "#665c54",     -- line numbers, borders
  bg1 = "#32302f",     -- current line, status line, popups
  bg2 = "#45403d",     -- selection
  red = "#ea6962",
  orange = "#e78a4e",
  yellow = "#d8a657",
  green = "#a9b665",
  aqua = "#89b482",
  blue = "#7daea3",    -- accent: same blue as the bar and window glow
  purple = "#d3869b",
}

local hl = function(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

-- ── Editor UI ────────────────────────────────────────────────────────
hl("Normal", { fg = c.fg })                -- no bg: use the terminal's
hl("NormalFloat", { fg = c.fg, bg = c.bg1 })
hl("FloatBorder", { fg = c.dim, bg = c.bg1 })
hl("CursorLine", { bg = c.bg1 })
hl("CursorLineNr", { fg = c.blue, bold = true })
hl("LineNr", { fg = c.dim })
hl("SignColumn", {})
hl("ColorColumn", { bg = c.bg1 })
hl("WinSeparator", { fg = c.dim })
hl("Visual", { bg = c.bg2 })
hl("Search", { fg = c.bg1, bg = c.yellow })
hl("IncSearch", { fg = c.bg1, bg = c.orange })
hl("CurSearch", { link = "IncSearch" })
hl("MatchParen", { fg = c.orange, bold = true, underline = true })
hl("NonText", { fg = c.dim })
hl("Whitespace", { fg = c.dim })
hl("EndOfBuffer", { fg = c.bg1 })
hl("Pmenu", { fg = c.fg, bg = c.bg1 })
hl("PmenuSel", { fg = c.bg1, bg = c.blue, bold = true })
hl("PmenuThumb", { bg = c.dim })
hl("StatusLine", { fg = c.fg, bg = c.bg1 })
hl("StatusLineNC", { fg = c.grey, bg = c.bg1 })
hl("TabLine", { fg = c.grey, bg = c.bg1 })
hl("TabLineSel", { fg = c.fg, bold = true })
hl("TabLineFill", { bg = c.bg1 })
hl("Title", { fg = c.orange, bold = true })
hl("Directory", { fg = c.blue })
hl("Folded", { fg = c.grey, bg = c.bg1 })
hl("ErrorMsg", { fg = c.red, bold = true })
hl("WarningMsg", { fg = c.yellow })
hl("MoreMsg", { fg = c.green })
hl("Question", { fg = c.blue })

-- status line mode pill (used by the statusline in init.lua)
hl("StatusMode", { fg = c.bg1, bg = c.blue, bold = true })
hl("StatusModeInsert", { fg = c.bg1, bg = c.green, bold = true })
hl("StatusModeVisual", { fg = c.bg1, bg = c.orange, bold = true })
hl("StatusModeCommand", { fg = c.bg1, bg = c.yellow, bold = true })

-- ── Syntax ───────────────────────────────────────────────────────────
hl("Comment", { fg = c.grey, italic = true })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.purple })
hl("Boolean", { fg = c.purple })
hl("Float", { fg = c.purple })
hl("Constant", { fg = c.purple })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.blue })
hl("Statement", { fg = c.red })
hl("Keyword", { fg = c.red })
hl("Conditional", { fg = c.red })
hl("Repeat", { fg = c.red })
hl("Operator", { fg = c.orange })
hl("PreProc", { fg = c.aqua })
hl("Type", { fg = c.yellow })
hl("Special", { fg = c.orange })
hl("Delimiter", { fg = c.grey })
hl("Todo", { fg = c.bg1, bg = c.yellow, bold = true })
hl("Error", { fg = c.red })
hl("Underlined", { underline = true })

-- tree-sitter (built into Neovim for Lua, Vimscript, Markdown, C…)
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.purple })
hl("@property", { fg = c.fg })
hl("@field", { fg = c.fg })
hl("@function.builtin", { fg = c.aqua })
hl("@constructor", { fg = c.yellow })
hl("@punctuation", { fg = c.grey })
hl("@markup.heading", { fg = c.orange, bold = true })
hl("@markup.link", { fg = c.blue, underline = true })
hl("@markup.raw", { fg = c.green })

-- ── Diagnostics & diffs (for later, when you add LSP) ────────────────
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.aqua })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hl("DiffAdd", { fg = c.green })
hl("DiffChange", { fg = c.yellow })
hl("DiffDelete", { fg = c.red })
hl("Added", { fg = c.green })
hl("Changed", { fg = c.yellow })
hl("Removed", { fg = c.red })
