-- Prints "state|title|artist" for Apple Music, or "off" when Music is not
-- running. Checks "is running" first so the widget never launches Music.
if application "Music" is running then
	tell application "Music"
		set playerState to player state as string
		if playerState is "stopped" then return "stopped||"
		try
			set trackName to name of current track
		on error
			set trackName to ""
		end try
		try
			set trackArtist to artist of current track
		on error
			set trackArtist to ""
		end try
		return playerState & "|" & trackName & "|" & trackArtist
	end tell
else
	return "off||"
end if
