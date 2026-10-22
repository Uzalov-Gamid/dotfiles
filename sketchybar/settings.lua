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
	-- MacBook Air 15" notch is 179pt wide (measured via NSScreen safe areas).
	-- Items with position "q" sit flush left of it, "e" flush right, so
	-- nothing ends up hidden under the cut-out. A little extra = breathing room.
	notch_width = 190,
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
	ram = {
		update_freq = 10,
		-- % of memory in use (100 - "memory free" from memory_pressure)
		thresholds = {
			medium = 60,
			high = 75,
			critical = 90,
		},
	},
	network = {
		update_freq = 2,
		label_width = 26,
	},
	music = {
		-- longer "Artist — Title" strings scroll inside this many chars
		max_chars = 28,
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

	-- SF Symbols glyphs used as widget icons (see icons.lua)
	icon_font = {
		family = "SF Pro",
		style = font.style_map["Bold"],
		size = sizes.icon_small,
	},

	binaries = {
		aerospace = os.getenv("AEROSPACE_BIN") or "/opt/homebrew/bin/aerospace",
	},
	network = {
		interface = os.getenv("SKETCHYBAR_NET_IFACE") or "en0",
	},

	scroll_texts = true,
}
