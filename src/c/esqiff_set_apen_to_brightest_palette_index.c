/* RESTORES: _ESQIFF_SetApenToBrightestPaletteIndex
 * MODULE:   modules/groups/a/n/esqiffbb_p0_esqiff_setapentobrightestpaletteindex_esqiff_setapentobrightestpaletteindex.s
 * STATUS:   behavioural
 *
 * Scan the palette for the entry with the largest R+G+B sum and set the status
 * rastport's pen to its index. Entry 0 seeds the running best, so the loop starts
 * at 1. The palette is stored as interleaved triples, which is why each component
 * is indexed i*3 from its own base byte.
 *
 * NEEDS SHORTINT, and by a wide margin: 172 bytes against 174 with it, 192
 * without. The original compares the running best against each sum with CMP.W
 * while building both with ADD.L -- 16-bit ints with longword arithmetic, which
 * is what SHORTINT produces and nothing else does. The index multiply is MULS
 * (16x16), same story. This is the fourth file to need it; see AGENTS.md,
 * "SHORTINT is per-file and often load-bearing".
 *
 * CAVEAT ON THE BUILD: the option lives in the third column of
 * src/c/replacements.txt, and gen_all_manifest.py reads it from there -- so a
 * behavioural file cannot carry one, because replacements.txt is the byte-exact
 * manifest and this file is not byte-exact. The maximum-C build therefore
 * compiles this WITHOUT SHORTINT, at 192 bytes. That is functionally identical
 * (every type in the source is explicitly long or short, so int width changes
 * nothing observable here) and it links and runs; it is simply 20 bytes less
 * faithful. The 172 figure is reproducible with:
 *     tools/cmatch.sh src/c/esqiff_set_apen_to_brightest_palette_index.c \
 *         _ESQIFF_SetApenToBrightestPaletteIndex SHORTINT
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- the one SetAPen is
 * the only call. See esq-graphics-leaf.h; tools/a6_audit.py enforces it.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   ref:     4e55fffc LINK.W A5,#-16 ... 2b40fff2 MOVE.L D0,-14(A5)
 *                                        202dfff2 MOVE.L -14(A5),D0
 *   got:     514f     SUBQ.W #8,A7   ... 3a00     MOVE.W D0,D5 / 2005
 *   summary: -2 overall under SHORTINT. The original keeps the best-index in its
 *            frame slot; 6.51 adjusts A7 directly and uses D5, then spills D2 to
 *            48ef00040018 instead. Everything else -- the shift, all six byte
 *            zero-extends, the MULS index scaling, both compares and the final
 *            SetAPen -- is identical.
 *   tried:   with and without SHORTINT (192 / 172). Nothing reaches the frame.
 *   scope:   whole-program; 364 LINK.W A5 frames against 0 A5-in-MOVEM.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

#include "esq-graphics-leaf.h"

extern unsigned char WDISP_PaletteDepthLog2;
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char WDISP_PaletteTriplesGBase[];
extern unsigned char WDISP_PaletteTriplesBBase[];
extern unsigned char *WDISP_DisplayContextBase;

#define Offset_RastPort2_FromDisplayContextBase 8

void ESQIFF_SetApenToBrightestPaletteIndex(void)
{
    long count = 1L << WDISP_PaletteDepthLog2;
    long best  = (long)WDISP_PaletteTriplesRBase[0]
               + (long)WDISP_PaletteTriplesGBase[0]
               + (long)WDISP_PaletteTriplesBBase[0];
    long bestIndex = 0;
    short i;
    long sum;

    for (i = 1; i < count; i++) {
        sum = (long)WDISP_PaletteTriplesRBase[i * 3]
            + (long)WDISP_PaletteTriplesGBase[i * 3]
            + (long)WDISP_PaletteTriplesBBase[i * 3];
        if (best < sum) {
            best = sum;
            bestIndex = i;
        }
    }

    SetAPen((struct RastPort *)(WDISP_DisplayContextBase
                + Offset_RastPort2_FromDisplayContextBase + 2), bestIndex);
}
