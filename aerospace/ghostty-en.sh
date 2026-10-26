#!/bin/bash
# Run by AeroSpace on every focus change (on-focus-changed in aerospace.toml):
# when the focused window is Ghostty, switch the keyboard to English (ABC).
# Switching back to Russian inside Ghostty works as usual until the next focus change.
[ "$(/opt/homebrew/bin/aerospace list-windows --focused --format '%{app-bundle-id}')" = "com.mitchellh.ghostty" ] || exit 0
exec "$HOME/.local/bin/input-source" com.apple.keylayout.ABC
