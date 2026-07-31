/* RESTORES: CLEANUP_DrawBannerSpacerSegment
 * MODULE:   modules/groups/a/c/cleanup2_p1_p0_p0.s
 * STATUS:   behavioural
 *
 * Fills the spacer between the date and time banner segments and puts a
 * bevelled frame around it, drawn into the off-screen 696x400 bitmap.
 *
 * The rectangle is (256, 34) to (447, 67) and the bevel frame takes the SAME
 * four corners. The original does not recompute them: D2 and D3 still hold 447
 * and 67 from the RectFill, so it pushes those registers and re-materialises
 * only the two small constants. That falls out of passing the same literals.
 *
 * The bitmap save/restore and the ANDI.W #$fff7 flag clear are identical to
 * cleanup_draw_date_time_banner_row.c, which is the caller.
 *
 * The volatile graphics header is required -- the bevel drawer is ESQ assembly
 * and does not preserve A6 -- and the original's two base loads are exactly
 * what it produces.
 *
 * 142 ref vs 132 got. The bitmap save/restore, the flag clear, the four bevel
 * argument pushes and the register reuse of D2/D3 all match exactly.
 *
 * SASC-MISMATCH: constant-materialisation
 *   ref:     203c00000100     MOVE.L #256,D0        (6 bytes)
 *   got:     7040 e588        MOVEQ #64,D0 / ASL.L #2,D0   (4 bytes)
 *   summary: this is a clean sighting of the documented constant rule. The
 *            original spends six bytes on MOVE.L for 256 because 256 is neither
 *            2n nor ~n for any n in MOVEQ range; 6.51 generalises to
 *            MOVEQ + ASL by any shift count and reaches it as 64 << 2. The
 *            ORIGINAL NEVER SHIFTS BY MORE THAN ONE, which is exactly the
 *            two-sided test docs/compiler-version.md gives for a candidate
 *            compiler. Note the original DOES use MOVE.L #447 two instructions
 *            later and 6.51 agrees there, because 447 is not a shifted MOVEQ.
 *   scope:   program-wide. docs/compiler-version.md, "Constant materialisation:
 *            the original rule, measured".
 *   retest:  compile something containing 256 and look for a six-byte MOVE.L.
 *
 * SASC-MISMATCH: save-restore-through-frame-vs-register
 *   ref:     4e55fffc 2b680004fffc ... 216dfffc0004 4e5d
 *   got:     2a680004 ... 214d0004
 *   summary: the bitmap goes through a frame slot in the original and an
 *            address register in 6.51 -- the same item as the caller,
 *            cleanup_draw_date_time_banner_row.c.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern void BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp, long x1,
                                             long y1, long x2, long y2);

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

void CLEANUP_DrawBannerSpacerSegment(void)
{
    struct BitMap *saved;

    saved = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    SetAPen(Global_REF_RASTPORT_1, 7L);
    Global_REF_RASTPORT_1->Flags &= ~8;

    RectFill(Global_REF_RASTPORT_1, 256L, 34L, 447L, 67L);
    BEVEL_DrawBevelFrameWithTopRight(Global_REF_RASTPORT_1, 256L, 34L, 447L, 67L);

    Global_REF_RASTPORT_1->BitMap = saved;
}
