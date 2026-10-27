-- Copy to local_profile.lua (not tracked by git) and fill in your own data;
-- the start screen (dashboard.lua) uses it instead of the defaults.
--   cp ~/.config/nvim/lua/local_profile.example.lua ~/.config/nvim/lua/local_profile.lua
return {
  profile = {
    name = "Your Name",
    handle = "@your-github-login",
    bio = "what you do",
  },
  -- for the sunrise / sunset line: name, latitude, longitude, UTC offset (hours)
  city = { name = "city", lat = 51.4779, lon = -0.0015, utc = 0 },
}
