local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- Live download / upload speed of the main interface (en0): 􀄩 6K  􀄨 7K

local iface = settings.network.interface

local function speed_item(name, glyph, props)
	props.position = "right"
	-- smaller than the other widgets: two numbers have to fit in one capsule
	local icon = {
		font = {
			family = settings.icon_font.family,
			style = settings.icon_font.style,
			size = settings.sizes.label_small - 1,
		},
		padding_right = 2,
	}
	for k, v in pairs(props.icon or {}) do
		icon[k] = v
	end
	props.icon = capsule.icon(glyph, colors.blue, icon)
	props.label = capsule.label("0K", {
		font = {
			family = settings.label_font.family,
			style = settings.label_font.style,
			size = settings.sizes.label_small,
		},
		width = settings.widgets.network.label_width,
		align = "left",
		padding_right = props.label_padding_right or 0,
	})
	props.label_padding_right = nil
	return sbar.add("item", name, props)
end

-- right items are added right-to-left, so "up" first
local net_up = speed_item("widgets.network.up", icons.wifi.upload, {
	icon = { padding_left = 2 },
	label_padding_right = capsule.inner - 3,
	padding_left = 0,
	padding_right = 0,
})
-- no outer padding on the left: the bracket background would swallow it.
-- The gap to the wifi capsule comes from that widget's padding_right.
local net_down = speed_item("widgets.network.down", icons.wifi.download, {
	padding_left = 0,
	padding_right = 0,
	update_freq = settings.widgets.network.update_freq,
})

capsule.bracket("widgets.network.capsule", { "widgets.network.down", "widgets.network.up" })

-- bytes/s -> "0K", "840K", "1.4M", "12M"
local function format_speed(bytes_per_sec)
	local kb = bytes_per_sec / 1024
	if kb < 1000 then
		return string.format("%.0fK", kb)
	end
	local mb = kb / 1024
	if mb < 10 then
		return string.format("%.1fM", mb)
	end
	return string.format("%.0fM", mb)
end

-- netstat gives total bytes since boot; speed = delta / elapsed time.
local last = nil

net_down:subscribe({ "routine", "forced", "system_woke" }, function()
	local cmd = string.format("netstat -ibn -I %s | awk 'NR==2 {print $7, $10}'; date +%%s", iface)
	sbar.exec(cmd, function(out)
		local rx, tx, now = (out or ""):match("(%d+)%s+(%d+)%s+(%d+)")
		rx, tx, now = tonumber(rx), tonumber(tx), tonumber(now)
		if not rx then
			return
		end

		if last and now > last.time and rx >= last.rx and tx >= last.tx then
			local elapsed = now - last.time
			local down = (rx - last.rx) / elapsed
			local up = (tx - last.tx) / elapsed

			net_down:set({
				label = { string = format_speed(down) },
				icon = { color = down > 1024 * 1024 and colors.green or colors.blue },
			})
			net_up:set({
				label = { string = format_speed(up) },
				icon = { color = up > 1024 * 1024 and colors.green or colors.blue },
			})
		end

		last = { rx = rx, tx = tx, time = now }
	end)
end)
