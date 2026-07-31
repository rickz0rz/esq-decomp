# Logo detector. The TV Guide logo box is a distinctive dark maroon (84,17,34)
# that appears nowhere else on screen -- the ER007 banner red is much brighter.
# Reports the MAX over frames of that colour's pixel fraction.
# Validated 2026-07-31: known-good 0.09+, builds with the logo missing ~0.000.
import sys, glob
from PIL import Image
def score(label):
    best = 0.0
    for f in sorted(glob.glob('/tmp/esqsoak/%s_*.png' % label)):
        im = Image.open(f).convert('RGB')
        px = list(im.get_flattened_data()) if hasattr(im, 'get_flattened_data') else list(im.getdata())
        hits = sum(1 for r, g, b in px
                   if abs(r-84) < 12 and abs(g-17) < 12 and abs(b-34) < 12)
        best = max(best, hits / float(len(px)))
    return best
for lab in sys.argv[1:]:
    print("%-12s %.4f  %s" % (lab, score(lab), 'LOGO' if score(lab) > 0.01 else 'NO LOGO'))
