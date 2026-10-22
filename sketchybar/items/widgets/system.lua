local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local keyboard_settings = {
	default_label = "??",
	event_name = "input_change",
	notification = "AppleSelectedInputSourcesChangedNotification",
	layout_aliases = {
		Russian = "RU",
		RussianWin = "RU",
		ABC = "EN",
		["U.S."] = "EN",
		US = "EN",
	},
}

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2

os.execute(
	string.format(
		"sketchybar --add event %s '%s' 2>/dev/null",
		keyboard_settings.event_name,
		keyboard_settings.notification
	)
)

local outer_right_padding = sbar.add("item", "widgets.system.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = 0,
	padding_right = 0,
})

local keyboard = sbar.add("item", "widgets.system.keyboard", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = keyboard_settings.default_label,
		font = settings.label_font,
		align = "center",
		color = colors.white,
	},
	padding_left = settings.paddings.paddings,
	padding_right = settings.paddings.paddings - 3,
})

local wifi = sbar.add("item", "widgets.system.wifi", {
	position = "right",
	icon = {
		font = {
			style = settings.font.style_map["Bold"],
			size = settings.sizes.icon_medium,
		},
		align = "center",
	},
	-- padding_left = settings.paddings.paddings - nesting_padding,
	padding_left = settings.paddings.paddings - 3,
	label = { drawing = false },
})

local outer_left_padding = sbar.add("item", "widgets.system.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = 0,
	padding_right = 0,
})

sbar.add("item", "widgets.system.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.paddings,
})

-- Keep the related system indicators together inside the outer container.
sbar.add("bracket", "widgets.system.inner", {
	"widgets.system.wifi",
	"widgets.system.keyboard",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
		-- padding_left = 0,
		-- padding_right = 0,
	},
})

sbar.add("bracket", "widgets.system.outer", {
	"widgets.system.outer.padding.left",
	"widgets.system.wifi",
	"widgets.system.keyboard",
	"widgets.system.outer.padding.right",
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

local layout_script = [[
defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null | grep -w "KeyboardLayout Name" | cut -d "=" -f 2 | tr -d '"; '
]]

local function normalize_layout(raw)
	if not raw or raw == "" then
		return keyboard_settings.default_label
	end
	raw = raw:gsub("^%s*(.-)%s*$", "%1")

	local mapped_layout = keyboard_settings.layout_aliases[raw]
	if mapped_layout then
		return mapped_layout
	end

	return string.sub(raw:upper(), 1, 2)
end

local function update_layout()
	sbar.exec(layout_script, function(result)
		local label = normalize_layout(result)
		keyboard:set({ label = label })
	end)
end

keyboard:subscribe({ keyboard_settings.event_name, "system_woke" }, update_layout)
update_layout()

local network_script = [[
VPN_STATUS="OFF"
if scutil --nwi | grep -m1 'VPN' >/dev/null; then
  VPN_STATUS="ON"
fi

IFACE="__NETWORK_INTERFACE__"
WIFI_POWER=$(networksetup -getairportpower "$IFACE" | awk '{print $4}')
if [ "$WIFI_POWER" = "Off" ]; then
  CONN="OFF"
else
  SUMMARY=$(ipconfig getsummary "$IFACE")
  SSID=$(printf "%s\n" "$SUMMARY" | awk -F ' SSID : ' '/ SSID : / {print $2}')
  if [ -n "$SSID" ]; then
    if printf "%s\n" "$SUMMARY" | grep -qE '^ *sname = [a-zA-Z0-9]'; then
      CONN="HOTSPOT"
    else
      CONN="WIFI"
    fi
  elif [ -n "$(ipconfig getifaddr "$IFACE")" ]; then
    CONN="ETHERNET"
  else
    CONN="NO_INTERNET"
  fi
fi
echo "${VPN_STATUS}|${CONN}"
]]
network_script = network_script:gsub("__NETWORK_INTERFACE__", settings.network.interface)

local function update_wifi()
	sbar.exec(network_script, function(result)
		result = result:gsub("^%s*(.-)%s*$", "%1")
		local vpn_status, connection_type = result:match("([^|]+)|([^|]+)")
		local icon
		local color

		if connection_type == "WIFI" then
			icon = (vpn_status == "ON") and icons.wifi.vpn or icons.wifi.connected
			color = (vpn_status == "ON") and colors.blue or colors.white
		elseif connection_type == "HOTSPOT" then
			icon = icons.wifi.hotspot
			color = (vpn_status == "ON") and colors.blue or colors.white
		elseif connection_type == "ETHERNET" then
			icon = icons.wifi.ethernet
			color = (vpn_status == "ON") and colors.blue or colors.white
		elseif connection_type == "NO_INTERNET" then
			icon = icons.wifi.disconnected
			color = colors.red
		else
			icon = icons.wifi.disconnected
			color = colors.red
		end

		wifi:set({
			icon = { string = icon, color = color },
		})
	end)
end

wifi:subscribe({ "wifi_change", "system_woke" }, update_wifi)
sbar.exec("sleep 0.1", update_wifi)
