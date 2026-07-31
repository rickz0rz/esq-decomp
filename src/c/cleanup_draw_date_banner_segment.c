/* RESTORES: CLEANUP_DrawDateBannerSegment
 * MODULE:   modules/groups/a/c/cleanup2_p1_p0_p0.s
 * STATUS:   behavioural
 *
 * Draws the date half of the banner into the off-screen bitmap: a pen-7 fill,
 * the short month/day-of-week/day text, and a bevelled frame.
 *
 * The fill and the frame do NOT share corners, which is the detail worth
 * pinning: RectFill runs from x=40 and the bevel frame from x=0, both to 255.
 * The sibling cleanup_draw_banner_spacer_segment.c does share them, so the
 * pattern cannot be assumed.
 *
 * 255 is reached as MOVEQ #0 / NOT.B -- the ~n rule from
 * docs/compiler-version.md -- and is written as the literal 255 here; the
 * materialisation is the compiler's choice.
 *
 * The bitmap save/restore and the ANDI.W #$fff7 flag clear are the same shape
 * as the two siblings in this module.
 *
 * 142 ref vs 132 got. The RectFill corners are VERBATIM, including
 * 7400 4602 for 255 -- MOVEQ #0 / NOT.B, the ~n rule -- and so are the bevel
 * arguments (48780043 / 487800ff / 48780022 / 42a7) and the flag clear.
 *
 * The 10 bytes are the frame class: the original saves the RastPort BitMap into
 * a frame slot across the three calls (LINK.W A5,#-4 / 2b680004fffc /
 * 216dfffc0004 / UNLK) where 6.51 keeps it in A5. Same item as the two
 * siblings in this module; see cleanup_draw_banner_spacer_segment.c for the
 * write-up.
 */
#include "esq-graphics.h"

extern void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void);
extern void BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp, long x1,
                                             long y1, long x2, long y2);

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

void CLEANUP_DrawDateBannerSegment(void)
{
    struct BitMap *saved;

    saved = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    SetAPen(Global_REF_RASTPORT_1, 7L);
    Global_REF_RASTPORT_1->Flags &= ~8;

    RectFill(Global_REF_RASTPORT_1, 40L, 34L, 255L, 67L);

    RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY();

    BEVEL_DrawBevelFrameWithTopRight(Global_REF_RASTPORT_1, 0L, 34L, 255L, 67L);

    Global_REF_RASTPORT_1->BitMap = saved;
}
