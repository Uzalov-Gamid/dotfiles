#!/bin/bash
# Measures every visible capsule on the bar and checks that the space
# between neighbours is the same everywhere (and not under the notch).
# Run after changing widgets:  ~/.config/sketchybar/helpers/scripts/check_gaps.sh
#
# The left group and the right group are checked separately: the space between
# them (the notch, or free space on a monitor without one) can be any size.
#
# A "capsule" is any visible item or bracket that draws a background,
# except items that sit inside a bracket (the bracket is the capsule) and
# items inside popups.

GAP=7         # settings.paddings.container_paddings
EDGE=9        # settings.paddings.edge_padding
# Notch of the main display, in points, read from macOS (-1 if there is none,
# e.g. on an external monitor), plus the screen width.
read -r NOTCH_L NOTCH_R SCREEN_W < <(swift -e '
import AppKit
let s = NSScreen.main!
let l = s.auxiliaryTopLeftArea?.width ?? 0, r = s.auxiliaryTopRightArea?.width ?? 0, w = s.frame.width
if l > 0 && r > 0 { print(Int(l), Int(w - r), Int(w)) } else { print(-1, -1, Int(w)) }
' 2>/dev/null || echo "-1 -1 1470")

items=$(sketchybar --query bar | jq -r '.items[]')

# members of brackets are drawn as part of the bracket
members=$(for i in $items; do
  sketchybar --query "$i" | jq -r 'select(.type == "bracket") | .bracket[]?'
done)

rects=$(for i in $items; do
  echo "$members" | grep -qx "$i" && continue
  sketchybar --query "$i" | jq -r --arg i "$i" '
    select(.geometry.drawing == "on")
    | select(.geometry.position | startswith("popup") | not)
    | select(.type == "bracket" or .geometry.background.drawing == "on")
    | .bounding_rects["display-1"] // empty
    | select(.origin[0] >= 0)  # hidden brackets are parked at -9999
    | "\(.origin[0]) \(.size[0]) \($i)"'
done | sort -n)

screen_w=$SCREEN_W

echo "$rects" | awk -v gap=$GAP -v edge=$EDGE -v nl=$NOTCH_L -v nr=$NOTCH_R -v w="$screen_w" '
  { x = $1; end = $1 + $2; name = $3 }
  NR == 1 { if (x != edge) { printf "✗ left edge %.0f (want %d)\n", x, edge; bad = 1 } }
  NR > 1 {
    g = x - prev_end
    # the gap between the left and the right group (notch or just free space) is not checked
    across_notch = (prev_end <= nl && x >= nr) || (prev_end <= w / 2 && x >= w / 2)
    if (!across_notch && g != gap) { printf "✗ %-28s → %-28s gap %.0f (want %d)\n", prev, name, g, gap; bad = 1 }
  }
  { if (x < nr && end > nl) { printf "✗ %s overlaps the notch (%.0f–%.0f)\n", name, x, end; bad = 1 }
    prev = name; prev_end = end }
  END {
    if (w - prev_end != edge) { printf "✗ right edge %.0f (want %d)\n", w - prev_end, edge; bad = 1 }
    if (!bad) printf "✓ all gaps %d pt, edges %d pt, nothing under the notch (%d capsules)\n", gap, edge, NR
    exit bad
  }'
