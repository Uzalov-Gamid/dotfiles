local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- Network: in the bar just an icon whose colour shows activity
--   grey  — idle (< 10 KB/s)
--   blue  — traffic
--   green — heavy traffic (> 1 MB/s in either direction)
-- Click it for a popup with speeds, Wi-Fi name, local/public IP and VPN.

local iface = settings.network.interface

local net = capsule.item("widgets.network", {
	-- the arrows glyph is 17pt wide. icon.width is the whole slot (paddings
	-- included), so a centred 33pt slot = 8pt on both sides of the glyph.
	icon = capsule.icon(icons.network, colors.grey, {
		width = 17 + 2 * 8,
		align = "center",
		padding_left = 0,
		padding_right = 0,
	}),
	label = { drawing = false },
	update_freq = settings.widgets.network.update_freq,
	popup = (function()
		local popup = {}
		for k, v in pairs(capsule.popup_style) do
			popup[k] = v
		end
		popup.height = 26 -- row height
		return popup
	end)(),
})

local parent = "widgets.network"
local rows = {
	down = capsule.popup_row("widgets.network.popup.down", parent, "Загрузка"),
	up = capsule.popup_row("widgets.network.popup.up", parent, "Отдача"),
	ssid = capsule.popup_row("widgets.network.popup.ssid", parent, "Сеть"),
	lip = capsule.popup_row("widgets.network.popup.lip", parent, "Локальный IP"),
	pip = capsule.popup_row("widgets.network.popup.pip", parent, "Внешний IP"),
	vpn = capsule.popup_row("widgets.network.popup.vpn", parent, "VPN"),
}

-- bytes/s -> "0 КБ/с", "840 КБ/с", "1.4 МБ/с", "12 МБ/с"
local function format_speed(bytes_per_sec)
	local kb = bytes_per_sec / 1024
	if kb < 1000 then
		return string.format("%.0f КБ/с", kb)
	end
	local mb = kb / 1024
	if mb < 10 then
		return string.format("%.1f МБ/с", mb)
	end
	return string.format("%.0f МБ/с", mb)
end

local details_script = string.format(
	[[
IFACE=%s
SSID=$(ipconfig getsummary "$IFACE" | awk -F ' SSID : ' '/ SSID : / {print $2}')
# macOS hides the network name from apps without Location access
[ "$SSID" = "<redacted>" ] && SSID="Wi-Fi"
if [ -z "$SSID" ]; then
  if [ -n "$(ipconfig getifaddr "$IFACE")" ]; then SSID="Ethernet"; else SSID="нет сети"; fi
fi
LIP=$(ipconfig getifaddr "$IFACE"); [ -z "$LIP" ] && LIP="—"
if scutil --nwi | grep -m1 'VPN' >/dev/null; then VPN="включён"; else VPN="выключен"; fi
echo "$SSID|$LIP|$VPN"
]],
	iface
)

-- Wi-Fi name, IPs and VPN only matter while you look at them, so they are
-- fetched when the popup opens, not every 2 seconds.
local function refresh_details()
	sbar.exec(details_script, function(out)
		local ssid, lip, vpn = (out or ""):match("^([^|]*)|([^|]*)|([^\r\n]*)")
		rows.ssid:set({ label = { string = ssid or "—" } })
		rows.lip:set({ label = { string = lip or "—" } })
		rows.vpn:set({
			label = {
				string = vpn or "—",
				color = vpn == "включён" and colors.green or colors.white,
			},
		})
	end)
	rows.pip:set({ label = { string = "…" } })
	sbar.exec("curl -s --max-time 3 https://ipinfo.io/ip", function(out)
		local ip = (out or ""):match("^%s*([%d%.:a-fA-F]+)%s*$")
		rows.pip:set({ label = { string = ip or "нет ответа" } })
	end)
end

capsule.attach_popup(net, refresh_details)

-- netstat gives total bytes since boot; speed = delta / elapsed time.
local last = nil

net:subscribe({ "routine", "forced", "system_woke" }, function()
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
			local peak = math.max(down, up)

			local color = colors.grey
			if peak > 1024 * 1024 then
				color = colors.green
			elseif peak > 10 * 1024 then
				color = colors.blue
			end
			net:set({ icon = { color = color } })

			rows.down:set({ label = { string = format_speed(down) } })
			rows.up:set({ label = { string = format_speed(up) } })
		end

		last = { rx = rx, tx = tx, time = now }
	end)
end)
