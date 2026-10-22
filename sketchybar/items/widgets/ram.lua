local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

local ram = capsule.item("widgets.ram", {
	icon = capsule.icon(icons.ram),
	label = capsule.label("??%"),
	update_freq = settings.widgets.ram.update_freq,
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
ram:subscribe({ "routine", "forced", "system_woke" }, function()
	sbar.exec("memory_pressure -Q | awk -F': ' '/free percentage/ {print $2}'", function(out)
		local free = tonumber((out or ""):match("(%d+)"))
		if not free then
			return
		end
		local used = 100 - free

		ram:set({
			icon = { color = get_ram_color(used) },
			label = { string = string.format("%d%%", used) },
		})
	end)
end)
