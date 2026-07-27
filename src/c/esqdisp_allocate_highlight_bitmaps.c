/* RESTORES: ESQDISP_AllocateHighlightBitmaps
 * MODULE:   modules/groups/a/n/esqdisp.s
 * STATUS:   behavioural
 *
 * Initialises a three-plane 696-pixel-wide BitMap for the highlight overlay and
 * allocates and clears each plane. The clear size is height * 88 rather than
 * height * 87: 696 pixels is 87 bytes, rounded up to an even byte count, which is
 * what AllocRaster hands back.
 *
 * No plane allocation is checked, and BltClear is called on the result either
 * way. That is the original's behaviour.
 *
 * MEASUREMENT NOTE, read before judging the numbers: the original's epilogue is
 * under its own exported label, ESQDISP_AllocateHighlightBitmaps_Return, because
 * the loop test branches to it. refbytes.py extracts label-to-label, so the 142
 * reference bytes STOP BEFORE the MOVEM/UNLK/RTS. The real comparison is 150
 * against 158 (plus one alignment NOP), so the delta is +8 and casm.py's +18
 * counts an 8-byte epilogue against nothing. Any function with a `_Return` label
 * needs this adjustment.
 *
 * Itemised on that basis: -2 frame, -2 constant, +14 multiply, 0 net for the
 * library-base shuffling. Nothing unattributed.
 *
 * SASC-MISMATCH: multiply-not-narrowed
 *   ref:     c2fc0058                        MULU.W #88,D1
 *   got:     4841 4241 4841 2401 e582 9481
 *            e582 9481 e782                  clear the high word, then shift/add
 *   summary: height * 88, where height is an unsigned short and the result is a
 *            long. The original narrows this to a 16x16->32 MULU because both
 *            operands fit in 16 bits; 6.51 promotes to a 32-bit multiply and
 *            expands it inline. +14, the bulk of the delta.
 *   tried:   dropping the (long) cast, casting to unsigned long, and SHORTINT --
 *            all three emit the identical shift/add chain.
 *   scope:   REFINES the arithmetic table in docs/compiler-version.md, which
 *            records `x * 30` (16-bit) as a case where 6.51 AGREES and emits
 *            MULU. It agrees when the expression is already 16-bit throughout; it
 *            does not narrow a 16-bit operand feeding a 32-bit result. That is the
 *            distinction, and it is what this function tests.
 *
 * SASC-MISMATCH: constant-materialisation
 *   ref:     223c000002b8   MOVE.L #696,D1
 *   got:     7257 e789      MOVEQ #87,D1 / LSL.L #3,D1
 *   summary: 696 = 87<<3. The documented rule, and a fourth independent sighting
 *            after the three in docs/compiler-version.md. Note the OTHER 696 in
 *            this function, the PEA in the AllocRaster call, matches exactly --
 *            the rule is about materialising into a register, not about the
 *            constant appearing at all.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   summary: LINK.W A5,#-4 against SUBQ.W #4,A7, and A5/A6 in the save mask where
 *            the original has A3. -2.
 */
#include <graphics/gfx.h>
#include "esq-graphics.h"

extern char *ESQDISP_JMPTBL_GRAPHICS_AllocRaster(char *who, long line, long width,
                                                 long height);

extern unsigned short WDISP_HighlightRasterHeightPx;
extern char Global_STR_ESQDISP_C[];

void ESQDISP_AllocateHighlightBitmaps(struct BitMap *bm)
{
    long i;

    InitBitMap(bm, 3L, 696L, (long)WDISP_HighlightRasterHeightPx);

    for (i = 0; i < 3; i++) {
        bm->Planes[i] = (PLANEPTR)
            ESQDISP_JMPTBL_GRAPHICS_AllocRaster(Global_STR_ESQDISP_C, 79L, 696L,
                                                (long)WDISP_HighlightRasterHeightPx);
        BltClear(bm->Planes[i], (long)(WDISP_HighlightRasterHeightPx * 88), 0L);
    }
}
