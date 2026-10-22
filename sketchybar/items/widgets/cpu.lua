local colors = require("colors")
local settings = require("settings")

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2

sbar.exec(
	string.format(
		"killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update %.1f",
		settings.widgets.cpu.poll_seconds
	)
)

local outer_right_padding = sbar.add("item", "widgets.cpu.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

local cpu_label = sbar.add("item", "widgets.cpu.label", {
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

local cpu_icon = sbar.add("item", "widgets.cpu.icon", {
	position = "right",
	label = { drawing = false },
	icon = {
		string = "CPU",
		color = colors.blue,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = settings.sizes.label_medium,
		},
		align = "center",
	},
	padding_left = settings.paddings.paddings - nesting_padding,
})

local outer_left_padding = sbar.add("item", "widgets.cpu.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

sbar.add("item", "widgets.cpu.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", "widgets.cpu.inner", {
	"widgets.cpu.icon",
	"widgets.cpu.label",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
})

sbar.add("bracket", "widgets.cpu.outer", {
	"widgets.cpu.outer.padding.left",
	"widgets.cpu.icon",
	"widgets.cpu.label",
	"widgets.cpu.outer.padding.right",
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

local function get_cpu_color(load)
	local thresholds = settings.widgets.cpu.thresholds
	if load > thresholds.critical then
		return colors.red
	end
	if load > thresholds.high then
		return colors.orange
	end
	if load > thresholds.medium then
		return colors.yellow
	end
	return colors.blue
end

cpu_icon:subscribe("cpu_update", function(env)
	local load = tonumber(env.total_load) or 0

	cpu_icon:set({
		icon = { color = get_cpu_color(load) },
	})

	cpu_label:set({
		label = { string = string.format("%.0f%%", load) },
	})
end)
