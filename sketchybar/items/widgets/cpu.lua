local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- CPU load from the cpu_load event provider (helpers/event_providers),
-- which fires cpu_update every poll_seconds.

sbar.exec(
	string.format(
		"killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update %.1f",
		settings.widgets.cpu.poll_seconds
	)
)

local cpu = capsule.item("widgets.cpu", {
	icon = capsule.icon(icons.cpu),
	label = capsule.label("??%"),
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

cpu:subscribe("cpu_update", function(env)
	local load = tonumber(env.total_load) or 0

	cpu:set({
		icon = { color = get_cpu_color(load) },
		label = { string = string.format("%.0f%%", load) },
	})
end)
