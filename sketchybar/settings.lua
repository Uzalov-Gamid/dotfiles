local font = {
	text = "SF Pro Rounded",
	numbers = "SF Pro Rounded",
	style_map = {
		["Regular"] = "Regular",
		["Semibold"] = "Semibold",
		["Bold"] = "Bold",
		["Heavy"] = "Heavy",
		["Black"] = "Black",
	},
}

local ui = {
	bar_height = 33,
	-- bar_height = 38,
	background = {
		border_width = 0,
		corner_radius = 0,
		margin = 0,
		y_offset = 0,

		image = {
			border_width = 1,
			corner_radius = 23,
		},
	},
	container = {
		height = 24,
		width = 38,
		corner_radius = 7,
		-- corner_radius = 15,
		border_width = 1,
		y_offset = -0,
		nesting_height = 20,
		-- nesting_corner_radius = 8,
		nesting_corner_radius = 5,
	},
	image = {
		corner_radius = 25,
		border_width = 1,
	},
	icon = {
		width = 20,
	},
	label = {
		width = 20,
	},
}

local paddings = {
	paddings = 10,
	group_padding = 5,
	edge_padding = 9,
	container_paddings = 7,
}

local sizes = {
	icon_small = 13.0,
	icon_medium = 14.0,
	icon_large = 16.0,

	label_small = 11.0,
	label_medium = 12.0,
	label_large = 13.0,
}

local widgets = {
	calendar = {
		update_freq = 15,
	},
	cpu = {
		poll_seconds = 5.0,
		label_width = 33,
		thresholds = {
			medium = 30,
			high = 60,
			critical = 80,
		},
	},
	volume = {},
	battery = {
		update_freq = 120,
	},
}

return {
	widgets = widgets,
	ui = ui,
	sizes = sizes,
	paddings = paddings,
	icons = "sf-symbols",
	font = font,

	label_font = {
		family = font.text,
		style = font.style_map["Bold"],
		size = sizes.label_medium,
	},

	binaries = {
		aerospace = os.getenv("AEROSPACE_BIN") or "/opt/homebrew/bin/aerospace",
	},
	network = {
		interface = os.getenv("SKETCHYBAR_NET_IFACE") or "en0",
	},

	scroll_texts = true,
}
