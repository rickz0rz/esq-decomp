/* RESTORES: ESQDISP_NormalizeClockAndRedrawBanner
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0.s
 * STATUS:   behavioural
 *
 * Normalizes the clock, refreshes the banner queue, then redraws the clock
 * banner into the off-screen bitmap and restores the RastPort.
 *
 * The bitmap swap is the interesting part and it is a real save/restore, not a
 * one-way store: the original reads 4(A0) into a frame local, points the
 * RastPort at the 696x400 bitmap for the duration of the draw, and writes the
 * saved value back afterwards. Offset 4 of a RastPort is its BitMap field, so
 * this is written through the struct rather than as a cast-and-add -- AGENTS.md
 * records that the struct form folds the offset into a displacement where the
 * cast form materialises the address per access.
 *
 * The refresh runs when the queue update returns ZERO (BNE skips the call).
 *
 * 96 ref vs 92 got. The two PEA globals, the LEA 12(A7),A7 cleanup, the
 * TST.L / BNE around the refresh, the MOVE.L #bitmap,4(A0) store and the
 * PEA 1 all match exactly.
 *
 * SASC-MISMATCH: save-restore-through-frame-vs-register
 *   ref:     2b680004fffc ... 216dfffc0004
 *            MOVE.L 4(A0),-4(A5) / MOVE.L -4(A5),4(A0)
 *   got:     26680004 ... 214b0004
 *            MOVEA.L 4(A0),A3 / MOVE.L A3,4(A0)
 *   summary: the original saves the RastPort's BitMap into a FRAME SLOT across
 *            the draw and writes it back from there; 6.51 holds it in an
 *            address register. Same save and same restore, 4 bytes cheaper.
 *            The struct form is what makes both sides fold the offset into a
 *            (d16,An) displacement rather than materialising the address.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern long  DST_UpdateBannerQueue(void *window);
extern void  DST_RefreshBannerBuffer(void);
extern void  ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(long *slots, void *clock);
extern void  ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(void);
extern void  ESQDISP_DrawStatusBanner_Impl(long which);

extern long   CLOCK_DaySlotIndex[];
extern char   DST_BannerWindowPrimary[];
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

void ESQDISP_NormalizeClockAndRedrawBanner(void *clock)
{
    struct BitMap *saved;

    ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(CLOCK_DaySlotIndex, clock);

    if (DST_UpdateBannerQueue(DST_BannerWindowPrimary) == 0)
        DST_RefreshBannerBuffer();

    saved = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner();

    Global_REF_RASTPORT_1->BitMap = saved;

    ESQDISP_DrawStatusBanner_Impl(1L);
}
