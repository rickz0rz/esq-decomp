#!/usr/bin/env python3
"""Decide whether any captured ESQ screen is showing a Guru alert.

    /tmp/.capvenv/bin/python tools/guru_detect.py <shot-dir> <label-prefix>

Exits 1 and names the offending shot if one is an alert, 0 if all are healthy.
Needs pillow: /tmp/.capvenv/bin/pip install pillow

TWO features, because either alone gives wrong answers on this program:

  RED alone is not enough. ESQ's TV logo is dark red and takes a perfectly
  healthy guide screen to red=0.0036, which is over any threshold low enough to
  catch the fainter alerts. That false positive was reported as "a clean build
  gurus" before it was caught by looking at the picture.

  BLACK alone is not enough either: the screen is legitimately near-black at
  several points during startup and between transitions.

A Guru is red text on an otherwise black screen, and the pair separates with two
orders of magnitude to spare -- measured over 30-odd captures:

    guru     red 0.0094-0.031   black 0.956-0.979
    healthy  red <=0.0036       black 0.44-0.64
"""
import glob
import os
import sys

from PIL import Image

RED_MIN = 0.005
BLACK_MIN = 0.90


def score(path):
    im = Image.open(path).convert('RGB')
    im.thumbnail((400, 400))                 # sampling; the bands are large
    raw = im.tobytes()                       # getdata() is deprecated in pillow 14
    px = [(raw[i], raw[i + 1], raw[i + 2]) for i in range(0, len(raw), 3)]
    n = len(px)
    red = sum(1 for r, g, b in px if r > 110 and g < 70 and b < 70) / n
    black = sum(1 for r, g, b in px if r < 40 and g < 40 and b < 40) / n
    return red, black


def main():
    d, lab = sys.argv[1], sys.argv[2]
    worst, where = 0.0, None
    for p in sorted(glob.glob(os.path.join(d, lab + '_[0-9]*.png'))):
        red, black = score(p)
        if red > RED_MIN and black > BLACK_MIN and red > worst:
            worst, where = red, os.path.basename(p)
    if worst:
        print(f'    GURU at {where} (red={worst:.4f})')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
