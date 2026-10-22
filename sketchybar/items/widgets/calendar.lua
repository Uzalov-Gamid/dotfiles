local settings = require("settings")
local colors = require("colors")

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2

local cal_font = {
	family = settings.font.text,
	style = settings.font.style_map["Bold"],
	size = settings.sizes.label_medium,
}

sbar.add("item", "edge_padding", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	padding_right = settings.paddings.edge_padding,
})

local outer_right_padding = sbar.add("item", "widgets.calendar.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

local cal_time = sbar.add("item", "widgets.calendar.time", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??:??",
		color = colors.white,
		font = cal_font,
		align = "center",
	},
	padding_right = settings.paddings.paddings - nesting_padding,
	padding_left = settings.paddings.group_padding,
})

local cal_date = sbar.add("item", "widgets.calendar.date", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??/??,",
		color = colors.white,
		font = cal_font,
		align = "center",
	},
	padding_left = settings.paddings.paddings - nesting_padding,
	update_freq = settings.widgets.calendar.update_freq,
})

local outer_left_padding = sbar.add("item", "widgets.calendar.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

sbar.add("item", "widgets.calendar.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", "widgets.calendar.inner", {
	"widgets.calendar.time",
	"widgets.calendar.date",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
})

sbar.add("bracket", "widgets.calendar.outer", {
	"widgets.calendar.outer.padding.left",
	"widgets.calendar.time",
	"widgets.calendar.date",
	"widgets.calendar.outer.padding.right",
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

cal_date:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_date:set({
		label = { string = os.date("%d/%m,") },
	})
	cal_time:set({
		label = { string = os.date("%H:%M") },
	})
end)
