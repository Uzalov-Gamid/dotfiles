local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local aerospace_bin = settings.binaries.aerospace
local app_icon_size_large = "sketchybar-app-font:Regular:" .. settings.sizes.icon_large
local app_icon_size_medium = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium
local app_icon_size_small = "sketchybar-app-font:Regular:" .. settings.sizes.icon_small

local MAX_INACTIVE_SLOTS = 10

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or value
end

local function aerospace_exec(arguments, callback)
	sbar.exec(aerospace_bin .. " " .. arguments, callback)
end

local y_cfg = {
	bracket_padding = 1,
	after_space_gap = settings.paddings.paddings - 3,
	space = {
		padding_left = 6, -- gap after space name to edge of it's container
		padding_right = 6,
		gap = settings.paddings.group_padding - 3, -- gap between space's containers
	},
	apps = {
		gap = settings.paddings.paddings,
	},
}

sbar.add("event", "aerospace_refresh")
sbar.add("event", "aerospace_mode_change")

sbar.add("item", "another_edge_padding", {
	position = "left",
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = settings.paddings.edge_padding,
})

local aerospace_workspace = sbar.add("item", "aerospace.ws", {
	position = "left",
	icon = {
		font = settings.label_font,
		color = colors.white,
		align = "center",
		padding_left = y_cfg.space.padding_left,
		padding_right = y_cfg.space.padding_right,
	},
	background = {
		height = settings.ui.container.nesting_height,
		color = colors.container.nesting_bg,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
	label = { drawing = false },
	padding_left = y_cfg.space.gap,
	-- padding_right = settings.paddings.paddings - 3,
	padding_right = y_cfg.after_space_gap,
})

local aerospace_active = sbar.add("item", "aerospace.active", {
	position = "left",
	icon = {
		font = app_icon_size_medium,
		color = colors.blue,
		align = "center",
	},
	label = { drawing = false },
	padding_left = 1,
	padding_right = settings.paddings.paddings + 1,
})

local inactive_slots = {}

for i = 1, MAX_INACTIVE_SLOTS do
	local slot = sbar.add("item", "aerospace.inactive." .. i, {
		position = "left",
		icon = { drawing = false },
		label = {
			font = app_icon_size_small,
			color = colors.grey,
			align = "center",
		},
		drawing = false,
		padding_right = settings.paddings.paddings,
	})
	table.insert(inactive_slots, slot)
end

local aerospace_bracket_items = {
	"aerospace.ws",
	"aerospace.active",
}

for i = 1, MAX_INACTIVE_SLOTS do
	table.insert(aerospace_bracket_items, "aerospace.inactive." .. i)
end

sbar.add("bracket", aerospace_bracket_items, {
	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		-- corner_radius = 0,
		y_offset = settings.ui.container.y_offset,
	},
})

local function render_workspace(workspace_id)
	if not workspace_id or workspace_id == "" then
		return
	end

	aerospace_exec(
		string.format("list-windows --workspace %q --format '%%{app-name}'", workspace_id),
		function(workspace_apps_output)
			aerospace_exec("list-windows --focused --format '%{app-name}|%{workspace}'", function(focused_output)
				local focused_app, focused_workspace = string.match(focused_output, "^([^|]+)|([^|\r\n]+)")
				focused_app = trim(focused_app)
				focused_workspace = trim(focused_workspace)

				local active_icon = ""

				local inactive_glyphs = {}
				local seen_apps = {}

				for app_name in string.gmatch(workspace_apps_output, "[^\r\n]+") do
					local normalized_app_name = trim(app_name)
					if normalized_app_name ~= "" and not seen_apps[normalized_app_name] then
						seen_apps[normalized_app_name] = true
						local glyph = app_icons[normalized_app_name] or app_icons.Default or "—"

						if normalized_app_name == focused_app and focused_workspace == workspace_id then
							active_icon = glyph
						else
							table.insert(inactive_glyphs, glyph)
						end
					end
				end

				if active_icon == "" and #inactive_glyphs == 0 then
					active_icon = "—"
				end

				for i, slot in ipairs(inactive_slots) do
					local glyph = inactive_glyphs[i]
					if glyph then
						slot:set({
							label = { string = glyph },
							drawing = true,
						})
					else
						slot:set({ drawing = false })
					end
				end

				aerospace_exec("list-modes --current", function(mode_output)
					local current_mode = trim(mode_output)
					local workspace_label = workspace_id

					if current_mode == "service" then
						workspace_label = workspace_id .. "\n[S]"
					end

					aerospace_workspace:set({
						icon = { string = workspace_label },
					})

					aerospace_active:set({
						icon = {
							string = active_icon,
							drawing = (active_icon ~= ""),
						},
					})
				end)
			end)
		end
	)
end

local function refresh_workspace(env)
	local workspace_id = env.FOCUSED_WORKSPACE
	if workspace_id and workspace_id ~= "" then
		render_workspace(workspace_id)
		return
	end

	aerospace_exec("list-workspaces --focused", function(focused_workspace_output)
		render_workspace(trim(focused_workspace_output))
	end)
end

aerospace_workspace:subscribe({ "aerospace_refresh", "front_app_switched", "aerospace_mode_change" }, refresh_workspace)

aerospace_exec("list-workspaces --focused", function(focused_workspace_output)
	local workspace_id = trim(focused_workspace_output)
	if workspace_id and workspace_id ~= "" then
		sbar.trigger("aerospace_refresh", { FOCUSED_WORKSPACE = workspace_id })
	end
end)
