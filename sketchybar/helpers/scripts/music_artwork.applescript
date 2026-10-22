-- Writes the current Apple Music track's artwork to the file given as the
-- first argument. Prints "ok", or "none" if the track has no artwork.
on run argv
	set outPath to item 1 of argv
	if application "Music" is not running then return "none"
	tell application "Music"
		try
			set artData to raw data of artwork 1 of current track
		on error
			return "none"
		end try
	end tell
	set f to open for access (POSIX file outPath) with write permission
	set eof f to 0
	write artData to f
	close access f
	return "ok"
end run
