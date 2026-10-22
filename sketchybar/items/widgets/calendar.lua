local icons = require("icons")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- Rightmost widget: 􀉉 22/10  17:28

local cal = capsule.item("widgets.calendar", {
	icon = capsule.icon(icons.calendar),
	label = capsule.label("??/??  ??:??"),
	padding_right = settings.paddings.edge_padding,
	update_freq = settings.widgets.calendar.update_freq,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function()
	cal:set({
		label = { string = os.date("%d/%m  %H:%M") },
	})
end)
