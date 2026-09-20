-- "claude": a quiet dark theme built from the same palette as
-- Ghostty, tmux and Starship in this setup — mostly monochrome text
-- with a single warm accent for what matters.
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "claude"

local c = {
  bg = "#161616",
  bg_alt = "#1c1c1c",
  bg_float = "#1f1f1f",
  bg_visual = "#3a2c26",
  fg = "#d7d7d7",
  fg_dim = "#8a8a8a",
  dim = "#666666",
  border = "#333333",
  accent = "#d97757",
  accent_dim = "#a85d42",
  red = "#b36a6a",
  green = "#7d9a72",
  yellow = "#b09a6a",
  blue = "#7289a8",
  purple = "#927b9d",
  cyan = "#6f9994",
  white = "#eeeeee",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor chrome
hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.bg_float })
hl("FloatBorder", { fg = c.border, bg = c.bg_float })
hl("Cursor", { fg = c.bg, bg = c.accent })
hl("CursorLine", { bg = c.bg_alt })
hl("CursorLineNr", { fg = c.accent, bold = true })
hl("LineNr", { fg = c.dim })
hl("SignColumn", { bg = c.bg })
hl("ColorColumn", { bg = c.bg_alt })
hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border })
hl("Visual", { bg = c.bg_visual })
hl("Search", { bg = c.accent_dim, fg = c.white })
hl("IncSearch", { bg = c.accent, fg = c.bg })
hl("MatchParen", { fg = c.accent, bold = true })
hl("Pmenu", { fg = c.fg, bg = c.bg_float })
hl("PmenuSel", { fg = c.bg, bg = c.accent })
hl("PmenuSbar", { bg = c.bg_alt })
hl("PmenuThumb", { bg = c.dim })
hl("StatusLine", { fg = c.fg, bg = c.bg_alt })
hl("StatusLineNC", { fg = c.dim, bg = c.bg_alt })
hl("TabLine", { fg = c.dim, bg = c.bg_alt })
hl("TabLineSel", { fg = c.accent, bg = c.bg })
hl("Directory", { fg = c.blue })
hl("Title", { fg = c.accent, bold = true })
hl("NonText", { fg = c.border })
hl("Whitespace", { fg = c.border })
hl("EndOfBuffer", { fg = c.bg })
hl("Folded", { fg = c.dim, bg = c.bg_alt })

-- Diagnostics
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.cyan })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.cyan })

-- Syntax
hl("Comment", { fg = c.dim, italic = true })
hl("Constant", { fg = c.yellow })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.purple })
hl("Boolean", { fg = c.purple })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.blue, bold = true })
hl("Statement", { fg = c.accent })
hl("Conditional", { fg = c.accent })
hl("Repeat", { fg = c.accent })
hl("Keyword", { fg = c.accent })
hl("Operator", { fg = c.fg_dim })
hl("PreProc", { fg = c.cyan })
hl("Type", { fg = c.cyan })
hl("Structure", { fg = c.cyan })
hl("Special", { fg = c.accent })
hl("Delimiter", { fg = c.fg_dim })
hl("Underlined", { underline = true, fg = c.blue })
hl("Error", { fg = c.red, bold = true })
hl("Todo", { fg = c.bg, bg = c.accent, bold = true })

-- Diff
hl("DiffAdd", { fg = c.green, bg = "#1c2a1c" })
hl("DiffChange", { fg = c.yellow, bg = "#2a2a1c" })
hl("DiffDelete", { fg = c.red, bg = "#2a1c1c" })
hl("DiffText", { fg = c.white, bg = "#3a3320" })

-- gitsigns
hl("GitSignsAdd", { fg = c.green })
hl("GitSignsChange", { fg = c.yellow })
hl("GitSignsDelete", { fg = c.red })

-- Treesitter captures
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.accent, italic = true })
hl("@parameter", { fg = c.fg_dim })
hl("@field", { fg = c.blue })
hl("@property", { fg = c.blue })
hl("@constructor", { fg = c.cyan })
hl("@tag", { fg = c.accent })
hl("@tag.attribute", { fg = c.yellow })
hl("@punctuation.bracket", { fg = c.fg_dim })
hl("@punctuation.delimiter", { fg = c.fg_dim })
hl("@keyword.function", { fg = c.accent })
hl("@keyword.return", { fg = c.accent })
hl("@function.builtin", { fg = c.blue })
hl("@string.escape", { fg = c.accent })
hl("@markup.heading", { fg = c.accent, bold = true })
hl("@markup.link", { fg = c.blue, underline = true })

-- LSP
hl("LspReferenceText", { bg = c.bg_alt })
hl("LspReferenceRead", { bg = c.bg_alt })
hl("LspReferenceWrite", { bg = c.bg_alt })
hl("LspInlayHint", { fg = c.dim, bg = c.bg_alt })

-- Telescope
hl("TelescopeBorder", { fg = c.border })
hl("TelescopePromptBorder", { fg = c.border })
hl("TelescopeSelection", { bg = c.bg_alt })
hl("TelescopeMatching", { fg = c.accent, bold = true })
hl("TelescopePromptPrefix", { fg = c.accent })

-- which-key
hl("WhichKey", { fg = c.accent })
hl("WhichKeyGroup", { fg = c.blue })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.dim })

-- nvim-tree
hl("NvimTreeNormal", { fg = c.fg, bg = c.bg })
hl("NvimTreeFolderIcon", { fg = c.blue })
hl("NvimTreeFolderName", { fg = c.fg })
hl("NvimTreeOpenedFolderName", { fg = c.accent })
hl("NvimTreeIndentMarker", { fg = c.border })
hl("NvimTreeGitDirty", { fg = c.yellow })
hl("NvimTreeGitNew", { fg = c.green })
hl("NvimTreeGitDeleted", { fg = c.red })
