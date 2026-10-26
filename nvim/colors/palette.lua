-- "palette": a tiny colour scheme in the "astronaut" colours — picked from
-- the desktop wallpaper (orange background, cream fur, dark visor, steel
-- helmet) plus the aqua-blue window glow. Same palette as the Ghostty
-- theme (ghostty/themes/astronaut). No plugin — just highlight groups.
-- The background is left to the terminal, so Neovim blends in with it.
--
-- To change a colour: edit `c` below, then `:colorscheme palette`.

vim.cmd("highlight clear")
vim.g.colors_name = "palette"
vim.o.background = "dark"

local c = {
  fg = "#e3dccb",      -- cream fur: main text
  grey = "#8f857a",    -- warm steel: comments
  dim = "#6b5a50",     -- line numbers, borders
  bg1 = "#2a1f1b",     -- current line, status line, popups
  bg2 = "#3b2c26",     -- selection
  orange = "#ef8f4c",  -- wallpaper background: spot accent
  red = "#e0603a",     -- arrow on the helmet
  yellow = "#e5c15a",  -- "YORK" sticker
  green = "#b5b07a",   -- olive jacket
  blue = "#7daea3",    -- window glow / bar accent: the main colour
  steel = "#8aa1b8",   -- steel blue of the helmet
  tan = "#d0a07e",     -- leather / warm tan
}

local hl = function(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

-- ── Editor UI ────────────────────────────────────────────────────────
hl("Normal", { fg = c.fg })                -- no bg: use the terminal's
hl("NormalFloat", { fg = c.fg, bg = c.bg1 })
hl("FloatBorder", { fg = c.dim, bg = c.bg1 })
hl("CursorLine", { bg = c.bg1 })
hl("CursorLineNr", { fg = c.orange, bold = true })
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
hl("Whitespace", { fg = "#463731" }) -- indent guides & trailing spaces: barely visible
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
hl("StatusModeInsert", { fg = c.bg1, bg = c.orange, bold = true })
hl("StatusModeVisual", { fg = c.bg1, bg = c.yellow, bold = true })
hl("StatusModeCommand", { fg = c.bg1, bg = c.green, bold = true })

-- ── Syntax ───────────────────────────────────────────────────────────
hl("Comment", { fg = c.grey, italic = true })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.orange })
hl("Boolean", { fg = c.orange, bold = true })
hl("Float", { fg = c.orange })
hl("Constant", { fg = c.orange })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.yellow })
hl("Statement", { fg = c.blue })
hl("Keyword", { fg = c.blue })
hl("Conditional", { fg = c.blue })
hl("Repeat", { fg = c.blue })
hl("Exception", { fg = c.red })
hl("Operator", { fg = c.steel })
hl("PreProc", { fg = c.steel })
hl("Include", { fg = c.blue })
hl("Type", { fg = c.steel })
hl("Special", { fg = c.red })
hl("Delimiter", { fg = c.grey })
hl("Todo", { fg = c.bg1, bg = c.yellow, bold = true })
hl("Error", { fg = c.red })
hl("Underlined", { underline = true })

-- tree-sitter captures (finer-grained than the classic groups above)
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.tan, italic = true })
hl("@variable.parameter", { fg = c.fg, italic = true })
hl("@variable.member", { fg = c.fg })
hl("@property", { fg = c.fg })
hl("@constant", { fg = c.orange })
hl("@constant.builtin", { fg = c.orange, bold = true })
hl("@module", { fg = c.steel })
hl("@function.builtin", { fg = c.yellow, italic = true })
hl("@function.method", { fg = c.yellow })
hl("@constructor", { fg = c.steel })
hl("@keyword.function", { fg = c.blue, italic = true })
hl("@keyword.return", { fg = c.blue, bold = true })
hl("@type.builtin", { fg = c.steel, italic = true })
hl("@tag", { fg = c.blue })
hl("@tag.attribute", { fg = c.yellow })
hl("@tag.delimiter", { fg = c.grey })
hl("@punctuation", { fg = c.grey })
hl("@string.escape", { fg = c.red })
hl("@string.special", { fg = c.steel })
hl("@markup.heading", { fg = c.orange, bold = true })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.link", { fg = c.blue, underline = true })
hl("@markup.raw", { fg = c.green })
hl("@markup.list", { fg = c.blue })

-- ── Diagnostics & diffs (for later, when you add LSP) ────────────────
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.steel })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hl("DiffAdd", { fg = c.green })
hl("DiffChange", { fg = c.yellow })
hl("DiffDelete", { fg = c.red })
hl("Added", { fg = c.green })
hl("Changed", { fg = c.yellow })
hl("Removed", { fg = c.red })
