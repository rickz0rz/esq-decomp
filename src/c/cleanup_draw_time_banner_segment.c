/* RESTORES: CLEANUP_DrawTimeBannerSegment
 * MODULE:   modules/groups/a/c/cleanup2_p1_p0_p0.s
 * STATUS:   behavioural
 *
 * The third of the three banner segment drawers, and the one whose fill and
 * frame differ MOST: the fill runs from x=448 to 663, the bevel frame from 448
 * to 695. The date sibling shares its right edge and the spacer sibling shares
 * all four corners, so each of the three has its own pairing and none can be
 * assumed from the others.
 *
 * Both 448 and 663 are six-byte MOVE.L constants in the original -- neither is
 * 2n nor ~n for a MOVEQ-range n -- while the bevel's copies are PEA .W. That is
 * the documented constant rule showing both of its sides in one function.
 *
 * The bitmap save/restore and the ANDI.W #$fff7 flag clear are identical to the
 * two siblings.
 *
 * 150 ref vs 140 got. The RectFill y coordinates, the MOVE.L #663 right edge
 * (243c00000297, identical in both), all four bevel PEA arguments and the flag
 * clear match exactly.
 *
 * SASC-MISMATCH: constant-materialisation
 *   ref:     203c000001c0     MOVE.L #448,D0              (6 bytes)
 *   got:     7070 e588        MOVEQ #112,D0 / ASL.L #2,D0 (4 bytes)
 *   summary: another clean sighting of the constant rule -- 448 = 112 << 2, and
 *            the original will not shift by more than one, so it spends six
 *            bytes on MOVE.L. Note 663 in the SAME function is MOVE.L in both,
 *            because it is not a shifted MOVEQ. One function showing both sides
 *            of the rule at once.
 *   scope:   program-wide. docs/compiler-version.md, "Constant materialisation:
 *            the original rule, measured".
 *   retest:  compile something containing 448 and look for a six-byte MOVE.L.
 *
 * The remaining 8 bytes are the frame class -- the bitmap parked in a frame
 * slot rather than an address register, as in both siblings.
 */
#include "esq-graphics.h"

extern void CLEANUP_DrawGridTimeBanner(void);
extern void BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp, long x1,
                                             long y1, long x2, long y2);

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

void CLEANUP_DrawTimeBannerSegment(void)
{
    struct BitMap *saved;

    saved = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    SetAPen(Global_REF_RASTPORT_1, 7L);
    Global_REF_RASTPORT_1->Flags &= ~8;

    RectFill(Global_REF_RASTPORT_1, 448L, 34L, 663L, 67L);

    CLEANUP_DrawGridTimeBanner();

    BEVEL_DrawBevelFrameWithTopRight(Global_REF_RASTPORT_1, 448L, 34L, 695L, 67L);

    Global_REF_RASTPORT_1->BitMap = saved;
}
