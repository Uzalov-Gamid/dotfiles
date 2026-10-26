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

-- ── Preview (like Obsidian's reading view) ───────────────────────────
-- <leader>p swaps the editor for the rendered note in the same window,
-- full width; <leader>p (or q) again brings the editor back where the
-- cursor was. Rendered by `glow` in the astronaut colours
-- (~/.config/glow/astronaut.json). Scroll with j/k, Ctrl-d/u, gg/G.
local src = vim.api.nvim_get_current_buf()
local style = vim.fn.expand("~/.config/glow/astronaut.json")

local function back_to_editor(preview)
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_buf_is_valid(src) then
    vim.api.nvim_win_set_buf(win, src)
  end
  if vim.api.nvim_buf_is_valid(preview) then
    vim.api.nvim_buf_delete(preview, { force = true }) -- also stops glow's job
  end
end

local function show_preview()
  if vim.bo[src].modified then
    vim.cmd.write()
  end
  local win = vim.api.nvim_get_current_win()
  local file = vim.api.nvim_buf_get_name(src)
  -- glow adds a 2-column margin on each side: keep lines inside the window
  local width = math.max(vim.api.nvim_win_get_width(win) - 6, 20)

  local preview = vim.api.nvim_create_buf(false, true)
  vim.b[preview].no_insert = true -- see TermOpen in init.lua
  vim.api.nvim_win_set_buf(win, preview)
  -- stdin from /dev/null: otherwise glow waits for Markdown on stdin.
  -- `tail -f /dev/null` keeps the job alive so no "[Process exited]" line.
  local cmd = string.format("glow -s %s -w %d %s < /dev/null; exec tail -f /dev/null",
    vim.fn.shellescape(style), width, vim.fn.shellescape(file))
  vim.fn.jobstart({ "sh", "-c", cmd }, { term = true, env = { COLORTERM = "truecolor" } })
  vim.bo[preview].bufhidden = "wipe"
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = false

  for _, key in ipairs({ "<leader>p", "q" }) do
    vim.keymap.set("n", key, function()
      back_to_editor(preview)
    end, { buffer = preview, desc = "Back to the editor" })
  end
  -- start reading from the top once glow has printed
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == preview then
      vim.api.nvim_win_set_cursor(win, { 1, 0 })
    end
  end, 300)
end

vim.keymap.set("n", "<leader>p", show_preview, { buffer = true, desc = "Reading view (glow)" })

-- <leader>r: open the file in the default Markdown app (Obsidian)
vim.keymap.set("n", "<leader>r", function()
  vim.cmd.write()
  vim.fn.jobstart({ "open", vim.fn.expand("%:p") })
end, { buffer = true, desc = "Open in Markdown app" })
