local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local aerospace_bin = "/opt/homebrew/bin/aerospace"

local app_icon_size_medium = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium
local app_icon_size_small = "sketchybar-app-font:Regular:" .. settings.sizes.icon_small

local WORKSPACES = {
	"main",
	"sec",
	"brwse",
	"note",
	"ai",
	"chat",
	"vpn",
}

local MAX_APPS = 7

local y_cfg = {
	bracket_padding = 1,
	space = {
		padding_left = 6,
		padding_right = 6,
		gap = settings.paddings.group_padding - 4,
	},
	apps = {
		gap = settings.paddings.paddings,
	},
}

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or ""
end

sbar.add("event", "aerospace_refresh")

sbar.add("item", "another_edge_padding", {
	position = "left",
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = settings.paddings.edge_padding,
})

--------------------------------------------------
-- WORKSPACES
--------------------------------------------------

local space_items = {}
local bracket_items = {}

sbar.add("item", "aerospace.bracket.padding.left", {
	position = "left",
	width = y_cfg.bracket_padding,
	icon = { drawing = false },
	label = { drawing = false },
})

table.insert(bracket_items, "aerospace.bracket.padding.left")

for i, ws in ipairs(WORKSPACES) do
	local name = "aerospace.space." .. ws

	space_items[ws] = sbar.add("item", name, {
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

		label = {
			drawing = false,
		},

		drawing = true,

		padding_left = y_cfg.space.gap,
	})

	table.insert(bracket_items, name)
end

sbar.add("item", "aerospace.bracket.padding.right", {
	position = "left",
	width = y_cfg.bracket_padding,
	icon = { drawing = false },
	label = { drawing = false },
})

table.insert(bracket_items, "aerospace.bracket.padding.right")

sbar.add("bracket", "aerospace.bracket", bracket_items, {

	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		y_offset = settings.ui.container.y_offset,
	},
})

--------------------------------------------------
-- APPS
--------------------------------------------------

sbar.add("item", "aerospace.spacer", {
	position = "left",
	width = settings.paddings.paddings + 4,
	icon = { drawing = false },
	label = { drawing = false },
})

local app_slots = {}

for i = 1, MAX_APPS do
	app_slots[i] = sbar.add("item", "aerospace.app." .. i, {
		position = "left",

		icon = {
			align = "center",
		},

		label = {
			drawing = false,
		},

		drawing = false,

		padding_left = i == 1 and 0 or y_cfg.apps.gap,
	})
end

local ignored_apps = {
	[""] = true,
	["Control Center"] = true,
	["Window Server"] = true,
	["WindowManager"] = true,
	["Spotlight"] = true,
	["SystemUIServer"] = true,
}

--------------------------------------------------
-- REFRESH
--------------------------------------------------

local function refresh_apps(focused)
	if not focused or focused == "" then
		return
	end

	sbar.exec(
		string.format("%s list-windows --workspace '%s' --format '%%{app-name}'", aerospace_bin, focused),
		function(out)
			local apps = {}

			for line in string.gmatch(out, "[^\r\n]+") do
				local app = trim(line)

				if app ~= "" and not ignored_apps[app] then
					local exists = false

					for _, v in ipairs(apps) do
						if v.name == app then
							exists = true
							break
						end
					end

					if not exists then
						table.insert(apps, {
							name = app,
							focus = false,
						})
					end
				end
			end

			sbar.exec(aerospace_bin .. " list-windows --focused --format '%{app-name}'", function(active)
				active = trim(active)

				for _, app in ipairs(apps) do
					if app.name == active then
						app.focus = true
					end
				end

				for i = 1, MAX_APPS do
					local app = apps[i]

					if app then
						local glyph = app_icons[app.name] or app_icons.Default or "—"

						app_slots[i]:set({
							drawing = true,
							icon = {
								string = glyph,
								font = app.focus and app_icon_size_medium or app_icon_size_small,
								color = app.focus and colors.blue or colors.grey,
							},
						})
					else
						app_slots[i]:set({
							drawing = false,
						})
					end
				end
			end)
		end
	)
end

local function refresh_workspace()
	sbar.delay(0.05, function()
		local focused = trim(os.getenv("FOCUSED_WORKSPACE"))

		if focused == "" then
			sbar.exec(aerospace_bin .. " list-workspaces --focused", function(out)
				refresh_workspace()
			end)
			return
		end

		-- всегда показываем все persistent workspaces

		for _, ws in ipairs(WORKSPACES) do
			space_items[ws]:set({
				drawing = true,
				icon = {
					string = ws,
					color = ws == focused and colors.blue or colors.white,
				},
			})
		end

		refresh_apps(focused)
	end)
end

--------------------------------------------------
-- EVENTS
--------------------------------------------------

sbar.add("item", "aerospace.event_listener", {
	drawing = false,
}):subscribe("aerospace_refresh", refresh_workspace)

refresh_workspace()
