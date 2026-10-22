local colors = require("colors")
local settings = require("settings")

-- Apple Music "now playing". Music.app broadcasts com.apple.Music.playerInfo
-- on every play/pause/track change, so this updates instantly and costs
-- nothing while idle. Hidden when Music is closed or stopped.
--   left click  — play / pause
--   right click — next track

local nesting_padding = (settings.ui.container.height - settings.ui.container.nesting_height) / 2

local info_script = "osascript $CONFIG_DIR/helpers/scripts/music_info.applescript"

sbar.add("event", "music_change", "com.apple.Music.playerInfo")

local outer_right_padding = sbar.add("item", "widgets.music.outer.padding.right", {
	position = "right",
	width = nesting_padding,
	drawing = false,
	icon = { drawing = false },
	label = { drawing = false },
})

local music_label = sbar.add("item", "widgets.music.label", {
	position = "right",
	drawing = false,
	icon = { drawing = false },
	label = {
		string = "",
		font = settings.label_font,
		color = colors.white,
		max_chars = settings.widgets.music.max_chars,
		scroll_duration = 150,
	},
	scroll_texts = settings.scroll_texts,
	padding_left = settings.paddings.group_padding,
	padding_right = settings.paddings.paddings - nesting_padding,
})

local music_icon = sbar.add("item", "widgets.music.icon", {
	position = "right",
	drawing = false,
	label = { drawing = false },
	icon = {
		string = ":music:",
		color = colors.magenta,
		font = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium,
		align = "center",
	},
	padding_left = settings.paddings.paddings - nesting_padding,
	-- keep receiving music_change while hidden, so it can show itself again
	updates = true,
})

local outer_left_padding = sbar.add("item", "widgets.music.outer.padding.left", {
	position = "right",
	width = nesting_padding,
	drawing = false,
	icon = { drawing = false },
	label = { drawing = false },
})

local spacer = sbar.add("item", "widgets.music.spacer", {
	position = "right",
	drawing = false,
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", "widgets.music.inner", {
	"widgets.music.icon",
	"widgets.music.label",
}, {
	background = {
		color = colors.container.nesting_bg,
		height = settings.ui.container.nesting_height,
		corner_radius = settings.ui.container.nesting_corner_radius,
		border_color = colors.container.nesting_border_color,
		border_width = settings.ui.background.border_width + 1,
	},
})

sbar.add("bracket", "widgets.music.outer", {
	"widgets.music.outer.padding.left",
	"widgets.music.icon",
	"widgets.music.label",
	"widgets.music.outer.padding.right",
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

local all_items = { outer_right_padding, music_label, music_icon, outer_left_padding, spacer }

local function set_visible(visible)
	for _, item in ipairs(all_items) do
		item:set({ drawing = visible })
	end
end

local function update()
	sbar.exec(info_script, function(out)
		local state, title, artist = (out or ""):match("^([^|]*)|([^|]*)|([^\r\n]*)")

		if state ~= "playing" and state ~= "paused" then
			set_visible(false)
			return
		end

		local text = title or ""
		if artist and artist ~= "" then
			text = artist .. " — " .. text
		end

		local playing = state == "playing"
		music_label:set({
			label = {
				string = text,
				color = playing and colors.white or colors.grey,
			},
		})
		music_icon:set({
			icon = { color = playing and colors.magenta or colors.grey },
		})
		set_visible(true)
	end)
end

music_icon:subscribe({ "music_change", "forced", "system_woke" }, update)

local function on_click(env)
	local command = env.BUTTON == "right" and "next track" or "playpause"
	sbar.exec(string.format("osascript -e 'tell application \"Music\" to %s'", command))
end

music_icon:subscribe("mouse.clicked", on_click)
music_label:subscribe("mouse.clicked", on_click)

update()
