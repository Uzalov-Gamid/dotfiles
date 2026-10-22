-- Prints "state|title|artist|album" for Apple Music, or "off|||" when Music
-- is not running. Checks "is running" first so the widget never launches Music.
if application "Music" is running then
	tell application "Music"
		set playerState to player state as string
		if playerState is "stopped" then return "stopped|||"
		set trackName to ""
		set trackArtist to ""
		set trackAlbum to ""
		try
			set trackName to name of current track
		end try
		try
			set trackArtist to artist of current track
		end try
		try
			set trackAlbum to album of current track
		end try
		return playerState & "|" & trackName & "|" & trackArtist & "|" & trackAlbum
	end tell
else
	return "off|||"
end if
