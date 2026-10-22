#!/usr/bin/env python3
"""Make a resized copy of a MaCursor theme.

    python3 ~/.config/cursor/resize.py BibataModernIceSmall.cursor 0.9

Every cursor's size (and its click point) is multiplied by the factor; the
pictures themselves are untouched — macOS just draws them in a smaller or
bigger box. The copy gets its own name/id, so MaCursor shows it next to the
original: open it (double-click) and press Apply.

Original Bibata is 32pt; BibataModernIceSmall is 0.7 of that (22.4pt).
"""
import plistlib
import sys
import uuid
from pathlib import Path

src = Path(sys.argv[1])
factor = float(sys.argv[2])

theme = plistlib.loads(src.read_bytes())
for cursor in theme["Cursors"].values():
    for key in ("PointsWide", "PointsHigh", "HotSpotX", "HotSpotY"):
        cursor[key] = round(cursor[key] * factor, 2)

size = round(next(iter(theme["Cursors"].values()))["PointsWide"])
theme["ThemeName"] = f"{theme['ThemeName']} {size}pt"
theme["Identifier"] = f"{theme['Identifier']}{size}"
theme["UUID"] = str(uuid.uuid4()).upper()

out = src.with_name(f"{src.stem}-{size}pt.cursor")
out.write_bytes(plistlib.dumps(theme, fmt=plistlib.FMT_XML))
print(f"{out}  ({size}pt) — open it in MaCursor and press Apply")
