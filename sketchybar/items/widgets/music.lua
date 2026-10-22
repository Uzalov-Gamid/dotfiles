local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local capsule = require("helpers.capsule")

-- Apple Music "now playing". Music.app broadcasts com.apple.Music.playerInfo
-- on every play/pause/track change, so this updates instantly and costs
-- nothing while idle. Hidden when Music is closed or stopped.
--   left click  — play / pause
--   right click — next track
--
-- Sits on the left, right after the spaces/apps block. Long titles scroll
-- within max_chars, so it stays well clear of the notch.

local info_script = "osascript $CONFIG_DIR/helpers/scripts/music_info.applescript"

sbar.add("event", "music_change", "com.apple.Music.playerInfo")

local music = capsule.item("widgets.music", {
	position = "left",
	drawing = false,
	icon = capsule.icon(icons.music, colors.magenta),
	label = capsule.label("", {
		max_chars = settings.widgets.music.max_chars,
		scroll_duration = 150,
	}),
	scroll_texts = settings.scroll_texts,
	padding_left = capsule.gap,
	padding_right = 0,
	-- keep receiving music_change while hidden, so it can show itself again
	updates = true,
})

local function update()
	sbar.exec(info_script, function(out)
		local state, title, artist = (out or ""):match("^([^|]*)|([^|]*)|([^\r\n]*)")

		if state ~= "playing" and state ~= "paused" then
			music:set({ drawing = false })
			return
		end

		local text = title or ""
		if artist and artist ~= "" then
			text = artist .. " — " .. text
		end

		local playing = state == "playing"
		music:set({
			drawing = true,
			icon = { color = playing and colors.magenta or colors.grey },
			label = {
				string = text,
				color = playing and colors.white or colors.grey,
			},
		})
	end)
end

music:subscribe({ "music_change", "forced", "system_woke" }, update)

music:subscribe("mouse.clicked", function(env)
	local command = env.BUTTON == "right" and "next track" or "playpause"
	sbar.exec(string.format("osascript -e 'tell application \"Music\" to %s'", command))
end)

update()
