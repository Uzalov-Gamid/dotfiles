local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2
local iface = settings.network.interface

local outer_right_padding = sbar.add("item", "widgets.network.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

local function speed_item(name, icon, padding_left, padding_right)
	return sbar.add("item", name, {
		position = "right",
		icon = {
			string = icon,
			color = colors.blue,
			font = {
				style = settings.font.style_map["Bold"],
				size = settings.sizes.icon_small,
			},
			padding_right = 3,
		},
		label = {
			string = "0K",
			font = settings.label_font,
			color = colors.white,
			width = settings.widgets.network.label_width,
			align = "left",
		},
		padding_left = padding_left,
		padding_right = padding_right,
	})
end

local net_up = speed_item(
	"widgets.network.up",
	icons.wifi.upload,
	settings.paddings.group_padding,
	settings.paddings.paddings - nesting_padding
)
local net_down = speed_item(
	"widgets.network.down",
	icons.wifi.download,
	settings.paddings.paddings - nesting_padding,
	0
)
net_down:set({ update_freq = settings.widgets.network.update_freq })

local outer_left_padding = sbar.add("item", "widgets.network.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

sbar.add("item", "widgets.network.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", "widgets.network.inner", {
	"widgets.network.down",
	"widgets.network.up",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
})

sbar.add("bracket", "widgets.network.outer", {
	"widgets.network.outer.padding.left",
	"widgets.network.down",
	"widgets.network.up",
	"widgets.network.outer.padding.right",
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
