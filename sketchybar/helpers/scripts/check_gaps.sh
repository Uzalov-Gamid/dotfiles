#!/bin/bash
# Measures every visible capsule on the bar and checks that the space
# between neighbours is the same everywhere (and not under the notch).
# Run after changing widgets:  ~/.config/sketchybar/helpers/scripts/check_gaps.sh
#
# A "capsule" is any visible item or bracket that draws a background,
# except items that sit inside a bracket (the bracket is the capsule) and
# items inside popups.

GAP=7         # settings.paddings.container_paddings
EDGE=9        # settings.paddings.edge_padding
NOTCH_L=646   # MacBook Air 15" notch, in points
NOTCH_R=825

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

screen_w=$(swift -e 'import AppKit; print(Int(NSScreen.main!.frame.width))' 2>/dev/null || echo 1470)

echo "$rects" | awk -v gap=$GAP -v edge=$EDGE -v nl=$NOTCH_L -v nr=$NOTCH_R -v w="$screen_w" '
  { x = $1; end = $1 + $2; name = $3 }
  NR == 1 { if (x != edge) { printf "✗ left edge %.0f (want %d)\n", x, edge; bad = 1 } }
  NR > 1 {
    g = x - prev_end
    across_notch = (prev_end <= nl && x >= nr)
    if (!across_notch && g != gap) { printf "✗ %-28s → %-28s gap %.0f (want %d)\n", prev, name, g, gap; bad = 1 }
  }
  { if (x < nr && end > nl) { printf "✗ %s overlaps the notch (%.0f–%.0f)\n", name, x, end; bad = 1 }
    prev = name; prev_end = end }
  END {
    if (w - prev_end != edge) { printf "✗ right edge %.0f (want %d)\n", w - prev_end, edge; bad = 1 }
    if (!bad) printf "✓ all gaps %d pt, edges %d pt, nothing under the notch (%d capsules)\n", gap, edge, NR
    exit bad
  }'
