local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- Apple Music "now playing": album cover + track title in the bar.
--   left click  — card with a big cover, title, artist · album and
--                 ⏮ ⏯ ⏭ buttons
--   right click — play / pause
-- Music.app broadcasts com.apple.Music.playerInfo on every play/pause/track
-- change, so this updates instantly and costs nothing while idle. Hidden
-- when Music is closed or stopped.
--
-- Covers are cut from the track's artwork once per album into
-- ~/.cache/sketchybar (a 36px one for the bar, a 128px one for the card).

local scripts = "$CONFIG_DIR/helpers/scripts/"
local cache = os.getenv("HOME") .. "/.cache/sketchybar"
os.execute("mkdir -p '" .. cache .. "'")

local cover_bar_pt = 18
local cover_card_pt = 56

sbar.add("event", "music_change", "com.apple.Music.playerInfo")

local music = capsule.item("widgets.music", {
	position = "left",
	drawing = false,
	icon = capsule.icon(icons.music, colors.magenta, {
		width = cover_bar_pt,
		background = {
			drawing = false,
			image = { corner_radius = 4 },
		},
	}),
	label = capsule.label("", {
		max_chars = settings.widgets.music.max_chars,
		scroll_duration = 150,
	}),
	scroll_texts = settings.scroll_texts,
	padding_left = capsule.gap,
	padding_right = 0,
	popup = (function()
		local popup = {}
		for k, v in pairs(capsule.popup_style) do
			popup[k] = v
		end
		popup.horizontal = true
		popup.height = cover_card_pt + 20
		popup.align = "left"
		return popup
	end)(),
	-- keep receiving music_change while hidden, so it can show itself again
	updates = true,
})

--------------------------------------------------
-- CARD (popup)
--------------------------------------------------

local parent = "popup.widgets.music"

local card_cover = sbar.add("item", "widgets.music.card.cover", {
	position = parent,
	width = cover_card_pt,
	icon = { drawing = false },
	label = { drawing = false },
	background = {
		drawing = false,
		image = { corner_radius = 8 },
	},
	padding_left = 10,
	padding_right = 4,
})

-- title above subtitle: the title has width 0, so the subtitle is drawn at
-- the same x, and the y_offsets move them apart.
local card_title = sbar.add("item", "widgets.music.card.title", {
	position = parent,
	width = 0,
	y_offset = 9,
	icon = { drawing = false },
	label = {
		font = { family = settings.font.text, style = settings.font.style_map["Bold"], size = settings.sizes.label_large },
		color = colors.white,
		max_chars = 26,
		padding_left = 10,
	},
})

local card_subtitle = sbar.add("item", "widgets.music.card.subtitle", {
	position = parent,
	y_offset = -9,
	icon = { drawing = false },
	label = {
		font = { family = settings.font.text, style = settings.font.style_map["Semibold"], size = settings.sizes.label_small },
		color = colors.grey,
		width = 230,
		max_chars = 38,
		padding_left = 10,
	},
})

local function control(name, glyph, command, last)
	local item = sbar.add("item", "widgets.music.card." .. name, {
		position = parent,
		icon = {
			string = glyph,
			font = { family = "SF Pro", style = "Bold", size = settings.sizes.icon_large },
			color = colors.white,
			padding_left = 8,
			padding_right = last and 14 or 8,
		},
		label = { drawing = false },
	})
	item:subscribe("mouse.clicked", function()
		sbar.exec(string.format("osascript -e 'tell application \"Music\" to %s'", command))
	end)
	return item
end

control("prev", icons.media.back, "previous track")
local play_button = control("playpause", icons.media.play_pause, "playpause")
control("next", icons.media.forward, "next track", true)

--------------------------------------------------
-- UPDATES
--------------------------------------------------

local current_album = nil

local function file_key(text)
	return (text:gsub("[^%w]", "_")):sub(1, 60)
end

-- Cut the artwork into two thumbnails, once per album.
local function update_cover(artist, album)
	local key = file_key(artist .. "_" .. album)
	if key == current_album then
		return
	end
	current_album = key

	local base = cache .. "/music_" .. key
	local cmd = string.format(
		[[
RAW='%s_raw'; S='%s_bar.png'; L='%s_card.png'
if [ ! -f "$S" ]; then
  [ "$(osascript %smusic_artwork.applescript "$RAW")" = ok ] || { echo none; exit; }
  sips -s format png -Z %d "$RAW" --out "$S" >/dev/null && sips -s format png -Z %d "$RAW" --out "$L" >/dev/null
  /bin/rm -f "$RAW"
fi
find '%s' -name 'music_*' ! -name 'music_%s_*' -delete
echo ok
]],
		base,
		base,
		base,
		scripts,
		cover_bar_pt * 2,
		cover_card_pt * 2,
		cache,
		key
	)

	sbar.exec(cmd, function(out)
		local has_cover = (out or ""):match("ok") ~= nil
		music:set({
			icon = {
				string = has_cover and "" or icons.music,
				background = {
					drawing = has_cover,
					image = { string = has_cover and (base .. "_bar.png") or "", scale = 0.5 },
				},
			},
		})
		card_cover:set({
			background = {
				drawing = has_cover,
				image = { string = has_cover and (base .. "_card.png") or "", scale = 0.5 },
			},
		})
	end)
end

local function update()
	sbar.exec("osascript " .. scripts .. "music_info.applescript", function(out)
		local state, title, artist, album = (out or ""):match("^([^|]*)|([^|]*)|([^|]*)|([^\r\n]*)")

		if state ~= "playing" and state ~= "paused" then
			music:set({ drawing = false, popup = { drawing = false } })
			return
		end

		local playing = state == "playing"
		music:set({
			drawing = true,
			label = {
				string = title,
				color = playing and colors.white or colors.grey,
			},
		})

		local subtitle = artist
		if album ~= "" then
			subtitle = (artist ~= "" and (artist .. " · ") or "") .. album
		end
		card_title:set({ label = { string = title } })
		card_subtitle:set({ label = { string = subtitle } })
		play_button:set({ icon = { color = playing and colors.white or colors.magenta } })

		update_cover(artist, album)
	end)
end

music:subscribe({ "music_change", "forced", "system_woke" }, update)

capsule.attach_popup(music, nil, function()
	sbar.exec("osascript -e 'tell application \"Music\" to playpause'")
end)

update()
