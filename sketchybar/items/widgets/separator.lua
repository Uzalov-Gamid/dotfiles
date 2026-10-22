local colors = require("colors")
local settings = require("settings")

return function(name)
	sbar.add("item", name, {
		position = "right",
		icon = {
			string = "──",
			color = colors.grey,
			font = settings.label_font,
			align = "center",
		},
		-- padding_right = 100,
		padding_left = settings.paddings.paddings + 3,
		label = { drawing = false },
	})
end
