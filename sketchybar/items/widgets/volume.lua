local icons = require("icons")
local colors = require("colors")
local capsule = require("helpers.capsule")

-- Speaker glyph follows the volume level; grey when muted / at 0.

local volume = capsule.item("widgets.volume", {
	icon = capsule.icon(icons.volume._100, colors.blue),
	label = capsule.label("??%"),
})

local function volume_glyph(level)
	if level > 60 then
		return icons.volume._100
	elseif level > 30 then
		return icons.volume._66
	elseif level > 10 then
		return icons.volume._33
	elseif level > 0 then
		return icons.volume._10
	end
	return icons.volume._0
end

volume:subscribe("volume_change", function(env)
	local level = tonumber(env.INFO) or 0

	volume:set({
		icon = {
			string = volume_glyph(level),
			color = level > 0 and colors.blue or colors.grey,
		},
		label = { string = level .. "%" },
	})
end)
