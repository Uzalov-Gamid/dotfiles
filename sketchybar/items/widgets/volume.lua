local colors = require("colors")
local settings = require("settings")

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2

local outer_right_padding = sbar.add("item", "widgets.volume.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

local volume_percent = sbar.add("item", "widgets.volume.percent", {
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

local volume_icon = sbar.add("item", "widgets.volume.icon", {
	position = "right",
	label = { drawing = false },
	icon = {
		string = "VOL",
		color = colors.blue,
		font = settings.label_font,
		align = "center",
	},
	padding_left = settings.paddings.paddings - nesting_padding,
})

local outer_left_padding = sbar.add("item", "widgets.volume.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

sbar.add("item", "widgets.volume.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", "widgets.volume.inner", {
	"widgets.volume.icon",
	"widgets.volume.percent",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
})

sbar.add("bracket", "widgets.volume.outer", {
	"widgets.volume.outer.padding.left",
	"widgets.volume.icon",
	"widgets.volume.percent",
	"widgets.volume.outer.padding.right",
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

volume_percent:subscribe("volume_change", function(env)
	local volume = tonumber(env.INFO) or 0

	local lead = ""
	if volume < 10 then
		lead = "0"
	end

	volume_percent:set({
		label = { string = lead .. volume .. "%" },
	})
end)
