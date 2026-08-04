/* RESTORES: _TLIBA3_DrawHorizontalScaleTicks
 * MODULE:   modules/groups/b/a/tliba3_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffa448e70710266d00082e2d000c2a077019da80224b220770002c79000028584eaeff10206b000470003010e7805380224b22074eaeff0a7c00206b000470003010e7805380bc806c0000f4200672194eba345a4a81660000ae4a86670000a8224b200622072c79000028584eaeff1020077214d0812f400010224b2006222f00104eaeff0a2f0648790000780e486dffac4eba2bd04fef000c41edffac22484a1966fc538993c82f490010224b202f00102c79000028584eaeffca4a806a025280e2802206928020062f41001072024eba33da700a4eba33b42205d280224b202f00104eaeff1041edffac22484a1966fc538993c82f490010224b202f00104eaeffc46032200672054eba33a04a816626224b200622072c79000028584eaeff102007720ad0812f400010224b2006222f00104eaeff0a52866000fefe4cdf08e04e5d4e75
 *   got:     9efc005848e70f062e2f00782a6f00742c077019dc80224d22072c790000000070004eaeff10206d000430104840424048402200e78153812001224d22072c79000000004eaeff0a7a00206d000430104840424048402200e7815381ba816c0000fa20057219610000004a81660000b44a85670000ae224d200522072c79000000004eaeff1020077214d0812200224d20052c79000000004eaeff0a2f05487900000000486f0024610000004fef000c41ef001c22484a1966fc538993c82009224d2c79000000004eaeffca48c04a806a025280e2802800200590842f40001820057202610000002001e580d081d0802206d280224d202f00182c79000000004eaeff1041ef001c22484a1966fc538993c82009224d2c79000000004eaeffc4603220057205610000004a816626224d200522072c79000000004eaeff102007720ad0812200224d20052c79000000004eaeff0a52856000fef24cdf60f0defc00584e75
 *   summary: 356 got vs 328 ref. The original loads the graphics base four times and reuses A6 for the calls that follow each load; esq-graphics.h reloads before all nine library calls, which accounts for the excess. esq-graphics-leaf.h is not usable: WDISP_SPrintf and the divide helpers sit between the Move/Draw pairs and the TextLength. The major-tick modulo by 25, the minor-tick modulo by 5, the label centring, the alternating label row from x modulo 2 and the width re-read on every iteration match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include <string.h>
#include "esq-graphics.h"

extern char TLIBA1_FMT_PCT_03LD_HorizontalScaleTick[];
extern void WDISP_SPrintf(char *buf, char *fmt, long value);

void TLIBA3_DrawHorizontalScaleTicks(struct RastPort *rp, long y)
{
    char buf[84];
    long labelY;
    long x;
    long half;

    labelY = y + 25;
    Move(rp, 0, y);
    Draw(rp, rp->BitMap->BytesPerRow * 8 - 1, y);

    for (x = 0; x < rp->BitMap->BytesPerRow * 8 - 1; x++) {
        if ((x - (x / 25) * 25) == 0 && x != 0) {
            Move(rp, x, y);
            Draw(rp, x, y + 20);
            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_HorizontalScaleTick, x);
            half = TextLength(rp, buf, strlen(buf)) / 2;
            Move(rp, x - half, labelY + 10 * ((x - (x / 2) * 2)));
            Text(rp, buf, strlen(buf));
        } else if ((x - (x / 5) * 5) == 0) {
            Move(rp, x, y);
            Draw(rp, x, y + 10);
        }
    }
}
