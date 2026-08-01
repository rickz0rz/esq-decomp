#!/usr/bin/env python3
"""Detect the ESC menu's grey background left behind after the menu closes.

    /tmp/.capvenv/bin/python tools/menuresidue.py <png> [<png> ...]

Exits nonzero if any frame holds the menu background. Use it as a gate, not
only as a report.

The red fraction does NOT work for this. ESQ cycles its own screens, so red
tracks the display cycle rather than the menu state. The same binary read
0.0299 / 0.0001 / 0.0230 at 12s / 20s / 40s on 2026-07-31, and a 9-round bisect
built on it returned a self-contradictory answer. The menu background is a
large light-grey block that a healthy grid never shows, so its pixel share
separates the two states cleanly.

Measured: healthy grid, known-good boot and menu-open all read 0.0000. The
broken close reads 0.3356. The threshold of 0.05 sits far from both.

The grey is palette entry 1, 12,12,12 -> 0xCCC -> (204,204,204). See the
AGENTS.md section "The ESC menu leaves the ad window grey".
"""
import sys
from PIL import Image

THRESHOLD = 0.05

hit = 0
for f in sys.argv[1:]:
    im = Image.open(f).convert('RGB')
    px = list(im.getdata())
    grey = sum(1 for r, g, b in px
               if 180 < r < 235 and abs(r-g) < 14 and abs(g-b) < 14 and abs(r-b) < 14)
    frac = grey / float(len(px))
    bad = frac >= THRESHOLD
    hit += bad
    print("%-44s grey=%.4f  %s" % (f.split('/')[-1], frac,
                                   'MENU BACKGROUND PRESENT' if bad else 'clean'))
if hit:
    print("\n%d frame(s) hold the ESC-menu background." % hit)
    print("Check fixEscMenuExitDisplayMode in src/Prevue.asm.")
sys.exit(1 if hit else 0)
