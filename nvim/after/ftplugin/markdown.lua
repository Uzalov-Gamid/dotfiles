-- Markdown: soft-wrap long lines at word boundaries, keep the indent of
-- wrapped list items, 2-space lists.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true

-- with wrap on, j/k move by screen line, not by paragraph
vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

-- ── Preview ──────────────────────────────────────────────────────────
-- <leader>p: rendered Markdown on the right, drawn by `glow` in the
-- astronaut colours (~/.config/glow/astronaut.json). Re-renders on every
-- save; <leader>p again closes it. Ctrl-l to go there and scroll.
local src = vim.api.nvim_get_current_buf()
local style = vim.fn.expand("~/.config/glow/astronaut.json")

local function preview_win()
  local win = vim.b[src].preview_win
  return win and vim.api.nvim_win_is_valid(win) and win or nil
end

local function render(win)
  local file = vim.api.nvim_buf_get_name(src)
  -- glow adds a 2-column margin on each side: keep lines inside the window
  local width = math.max(vim.api.nvim_win_get_width(win) - 6, 20)
  local old = vim.api.nvim_win_get_buf(win)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.b[buf].no_insert = true
  vim.api.nvim_win_set_buf(win, buf)
  if old ~= buf and vim.api.nvim_buf_is_valid(old) and vim.b[old].no_insert then
    vim.api.nvim_buf_delete(old, { force = true })
  end
  vim.api.nvim_win_call(win, function()
    -- stdin from /dev/null: otherwise glow waits for Markdown on stdin
    local cmd = string.format("glow -s %s -w %d %s < /dev/null",
      vim.fn.shellescape(style), width, vim.fn.shellescape(file))
    vim.fn.jobstart({ "sh", "-c", cmd }, { term = true, env = { COLORTERM = "truecolor" } })
  end)
  vim.bo[buf].bufhidden = "wipe"
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = false
end

vim.keymap.set("n", "<leader>p", function()
  local win = preview_win()
  if win then
    vim.api.nvim_win_close(win, true)
    vim.b[src].preview_win = nil
    return
  end
  if vim.bo[src].modified then
    vim.cmd.write()
  end
  local here = vim.api.nvim_get_current_win()
  vim.cmd("rightbelow vsplit")
  win = vim.api.nvim_get_current_win()
  vim.b[src].preview_win = win
  render(win)
  vim.api.nvim_set_current_win(here)
end, { buffer = true, desc = "Markdown preview (glow)" })

vim.api.nvim_create_autocmd("BufWritePost", {
  buffer = src,
  callback = function()
    local win = preview_win()
    if win then
      render(win)
    end
  end,
})

-- <leader>r: open the file in the default Markdown app (Obsidian)
vim.keymap.set("n", "<leader>r", function()
  vim.cmd.write()
  vim.fn.jobstart({ "open", vim.fn.expand("%:p") })
end, { buffer = true, desc = "Open in Markdown app" })
