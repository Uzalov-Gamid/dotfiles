local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- Battery glyph follows the charge level; green while charging,
-- red under 20%.

local battery = capsule.item("widgets.battery", {
	icon = capsule.icon(icons.battery._100),
	label = capsule.label("??%"),
	update_freq = settings.widgets.battery.update_freq,
})

local function battery_glyph(charge)
	if charge > 80 then
		return icons.battery._100
	elseif charge > 60 then
		return icons.battery._75
	elseif charge > 40 then
		return icons.battery._50
	elseif charge > 15 then
		return icons.battery._25
	end
	return icons.battery._0
end

battery:subscribe({ "routine", "forced", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(batt_info)
		local charge = tonumber(batt_info:match("(%d+)%%"))
		if not charge then
			return
		end

		local charging = batt_info:find("AC Power") ~= nil
		local color = colors.blue
		if charging then
			color = colors.green
		elseif charge < 20 then
			color = colors.red
		end

		battery:set({
			icon = {
				string = charging and icons.battery.charging or battery_glyph(charge),
				color = color,
			},
			label = { string = charge .. "%" },
		})
	end)
end)
