-- activity.lua — counts how long you actively edit, per day and filetype,
-- for the start screen (lua/dashboard.lua).
--
-- The time between two actions (cursor move, typing, switching buffers)
-- counts for the file type you were in — but only if the gap is shorter
-- than IDLE seconds, so walking away does not count. Totals are saved to
-- stdpath("data")/activity.json every 5 minutes and on exit; several
-- Neovim instances add their time instead of overwriting each other.

local M = {}

local IDLE = 120
local FILE = vim.fn.stdpath("data") .. "/activity.json"
-- not "editing a language": UI buffers and windows
local SKIP = {
  [""] = true, tree = true, dashboard = true, help = true, netrw = true, qf = true,
  cmd = true, msg = true, pager = true, dialog = true,
}

local pending = {} -- [date][filetype] = seconds not saved yet
local last_time, last_ft

local function read()
  local f = io.open(FILE, "r")
  if not f then
    return {}
  end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  return ok and type(data) == "table" and data or {}
end

local function add(into, from)
  for day, fts in pairs(from) do
    into[day] = into[day] or {}
    for ft, sec in pairs(fts) do
      into[day][ft] = (into[day][ft] or 0) + sec
    end
  end
  return into
end

-- all saved data + what this instance has not saved yet
function M.load()
  return add(read(), pending)
end

function M.save()
  if next(pending) == nil then
    return
  end
  local data = add(read(), pending)
  pending = {}
  vim.fn.mkdir(vim.fn.fnamemodify(FILE, ":h"), "p")
  local f = io.open(FILE, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

local function touch()
  local now = os.time()
  local ft = vim.bo.buftype == "" and vim.bo.filetype or ""
  if last_time and not SKIP[last_ft] and now - last_time <= IDLE then
    local day = os.date("%Y-%m-%d", last_time)
    pending[day] = pending[day] or {}
    pending[day][last_ft] = (pending[day][last_ft] or 0) + (now - last_time)
  end
  last_time, last_ft = now, ft
end

function M.setup()
  local group = vim.api.nvim_create_augroup("activity", { clear = true })
  vim.api.nvim_create_autocmd(
    { "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "BufEnter", "FocusGained", "InsertEnter" },
    { group = group, callback = touch }
  )
  -- switching to another app stops the clock
  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
      touch()
      last_time = nil
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      touch()
      M.save()
    end,
  })
  local timer = vim.uv.new_timer()
  timer:start(300000, 300000, vim.schedule_wrap(M.save))
end

return M
