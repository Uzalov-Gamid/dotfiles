local colors = require("colors")
local settings = require("settings")

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2

local outer_right_padding = sbar.add("item", "widgets.ram.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

local ram_label = sbar.add("item", "widgets.ram.label", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??%",
		font = settings.label_font,
		color = colors.white,
		align = "center",
	},
	padding_left = settings.paddings.group_padding,
	padding_right = settings.paddings.paddings - nesting_padding,
})

local ram_icon = sbar.add("item", "widgets.ram.icon", {
	position = "right",
	label = { drawing = false },
	icon = {
		string = "RAM",
		color = colors.blue,
		font = settings.label_font,
		align = "center",
	},
	padding_left = settings.paddings.paddings - nesting_padding,
	update_freq = settings.widgets.ram.update_freq,
})

local outer_left_padding = sbar.add("item", "widgets.ram.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

sbar.add("item", "widgets.ram.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", "widgets.ram.inner", {
	"widgets.ram.icon",
	"widgets.ram.label",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
})

sbar.add("bracket", "widgets.ram.outer", {
	"widgets.ram.outer.padding.left",
	"widgets.ram.icon",
	"widgets.ram.label",
	"widgets.ram.outer.padding.right",
}, {
	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		y_offset = settings.ui.container.y_offset,
	},
})

local function get_ram_color(used)
	local thresholds = settings.widgets.ram.thresholds
	if used > thresholds.critical then
		return colors.red
	end
	if used > thresholds.high then
		return colors.orange
	end
	if used > thresholds.medium then
		return colors.yellow
	end
	return colors.blue
end

-- memory_pressure reports how much memory macOS considers free (it counts
-- reclaimable cache as free), so 100 - free is "memory actually in use".
ram_icon:subscribe({ "routine", "forced", "system_woke" }, function()
	sbar.exec("memory_pressure -Q | awk -F': ' '/free percentage/ {print $2}'", function(out)
		local free = tonumber((out or ""):match("(%d+)"))
		if not free then
			return
		end
		local used = 100 - free

		ram_icon:set({
			icon = { color = get_ram_color(used) },
		})

		ram_label:set({
			label = { string = string.format("%d%%", used) },
		})
	end)
end)
