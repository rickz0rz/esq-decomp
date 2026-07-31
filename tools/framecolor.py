#!/usr/bin/env python
"""Compare two sets of soak frames by COLOUR, not by eye.

    /tmp/.capvenv/bin/python tools/framecolor.py <label-a> <label-b>

Frames from two runs are never at the same point in ESQ's display cycle, so a
side-by-side look tells you almost nothing: the two builds show different
screens. Judging them by eye produced three wrong calls in one session,
including a "clipped logo" defect that was only the capture crop.

What DOES carry across the cycle is the colour a build puts on the screen. A
wrong constant draws a wrong picture while the display keeps animating, so the
soak still passes. The register-argument class was found exactly this way: the
green panel it painted over the grid read 0.0 in every reference frame and
0.328 in every candidate frame.

So this reports, per label, the share of pixels that fall in each of a few
coarse colour bins, min/median/max over all frames of that label. Read the
RANGES. A bin whose candidate range does not overlap the reference range is a
real difference in what the program drew. A bin that overlaps is the display
cycle and means nothing.

Exits 1 if any bin's ranges are disjoint, so it can be wired into a check.

Frames come from $SHOTS (default /tmp/esqsoak), written by tools/soak_esq.sh.
"""
import os
import sys
import glob

from PIL import Image

SHOTS = os.environ.get('SHOTS', '/tmp/esqsoak')

# Coarse bins. Each is a predicate on (r, g, b) in 0..255.
BINS = [
    ('black',   lambda r, g, b: r < 40 and g < 40 and b < 40),
    ('white',   lambda r, g, b: r > 200 and g > 200 and b > 200),
    ('red',     lambda r, g, b: r > 90 and r > g + 40 and r > b + 40),
    ('green',   lambda r, g, b: g > 90 and g > r + 40 and g > b + 40),
    ('blue',    lambda r, g, b: b > 90 and b > r + 40 and b > g + 40),
    ('yellow',  lambda r, g, b: r > 90 and g > 90 and r > b + 40 and g > b + 40),
]


def frame_shares(path):
    """Share of pixels in each bin, for one frame."""
    im = Image.open(path).convert('RGB')
    # A full window grab is a few hundred thousand pixels. Downsample first:
    # the bins are coarse and a 1/4 scale changes no share by more than noise.
    im = im.resize((im.width // 4 or 1, im.height // 4 or 1))
    raw = im.tobytes()
    n = len(raw) // 3
    counts = [0] * len(BINS)
    for j in range(0, len(raw), 3):
        r, g, b = raw[j], raw[j + 1], raw[j + 2]
        for i, (_, pred) in enumerate(BINS):
            if pred(r, g, b):
                counts[i] += 1
    return [c / n for c in counts]


def label_stats(label):
    files = sorted(glob.glob(os.path.join(SHOTS, label + '_*.png')))
    if not files:
        sys.exit('no frames for label %r under %s' % (label, SHOTS))
    rows = [frame_shares(f) for f in files]
    out = []
    for i in range(len(BINS)):
        col = sorted(r[i] for r in rows)
        out.append((col[0], col[len(col) // 2], col[-1]))
    return len(files), out


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    a, b = sys.argv[1], sys.argv[2]
    na, sa = label_stats(a)
    nb, sb = label_stats(b)
    print('%s: %d frames    %s: %d frames' % (a, na, b, nb))
    print()
    print('%-8s %-24s %-24s %s' % ('bin', a + ' (min/med/max)',
                                   b + ' (min/med/max)', ''))
    bad = 0
    for i, (name, _) in enumerate(BINS):
        lo_a, md_a, hi_a = sa[i]
        lo_b, md_b, hi_b = sb[i]
        disjoint = hi_a < lo_b or hi_b < lo_a
        if disjoint:
            bad += 1
        print('%-8s %6.3f %6.3f %6.3f      %6.3f %6.3f %6.3f      %s' % (
            name, lo_a, md_a, hi_a, lo_b, md_b, hi_b,
            'DISJOINT' if disjoint else 'overlaps'))
    print()
    if bad:
        print('%d bin(s) DISJOINT -- the two builds draw different colours' % bad)
        return 1
    print('every bin overlaps -- no colour difference between the two builds')
    return 0


if __name__ == '__main__':
    sys.exit(main())
