/* RESTORES: CLEANUP_DrawDateTimeBannerRow
 * MODULE:   modules/groups/a/c/cleanup2_p1_p0.s
 * STATUS:   behavioural
 *
 * Redraws the date/time banner row into the off-screen 696x400 bitmap and puts
 * the RastPort back.
 *
 * The bitmap swap is a real save/restore through the RastPort's BitMap field at
 * +4, the same shape as esqdisp_normalize_clock_and_redraw_banner.c. Written
 * through the struct so both accesses fold into (d16,An) displacements.
 *
 * ANDI.W #$fff7 on the word at +32 clears bit 3 of RastPort.Flags. It is
 * written as `&= ~8` because that is what the mask means; the emitted constant
 * is the same.
 *
 * The fill is (0, 34) to (695, 67) in pen 7, and the three segment drawers run
 * inside the swap so they all land on the off-screen bitmap.
 *
 * The volatile graphics header is required -- the three segment drawers are ESQ
 * assembly and do not preserve A6. The original reloads the base before
 * RectFill for exactly that reason, and it has nothing to reload for
 * afterwards because it makes no further library call.
 *
 * 128 ref vs 116 got. The bitmap save and restore, the SetAPen 7, the
 * ANDI.W #$fff7 flag clear, the RectFill corners (7000 7222 243c000002b7 7643)
 * and all three segment calls match exactly.
 *
 * SASC-MISMATCH: save-restore-through-frame-vs-register
 *   ref:     4e55fffc 2b680004fffc ... 216dfffc0004 4e5d
 *            LINK / MOVE.L 4(A0),-4(A5) / MOVE.L -4(A5),4(A0) / UNLK
 *   got:     2a680004 ... 214d0004
 *            MOVEA.L 4(A0),A5 / MOVE.L A5,4(A0)
 *   summary: the original saves the RastPort BitMap into a frame slot across
 *            the three segment calls; 6.51 holds it in an address register.
 *            The frame plus the wider store and reload is the 12 bytes. Same
 *            item as esqdisp_normalize_clock_and_redraw_banner.c.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern void CLEANUP_DrawDateBannerSegment(void);
extern void CLEANUP_DrawBannerSpacerSegment(void);
extern void CLEANUP_DrawTimeBannerSegment(void);

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

void CLEANUP_DrawDateTimeBannerRow(void)
{
    struct BitMap *saved;

    saved = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    SetAPen(Global_REF_RASTPORT_1, 7L);
    Global_REF_RASTPORT_1->Flags &= ~8;

    RectFill(Global_REF_RASTPORT_1, 0L, 34L, 695L, 67L);

    CLEANUP_DrawDateBannerSegment();
    CLEANUP_DrawBannerSpacerSegment();
    CLEANUP_DrawTimeBannerSegment();

    Global_REF_RASTPORT_1->BitMap = saved;
}
