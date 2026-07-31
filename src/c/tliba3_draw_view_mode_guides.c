/* RESTORES: TLIBA3_DrawViewModeGuides
 * MODULE:   modules/groups/b/a/tliba3_p1_p1.s
 * STATUS:   behavioural
 *
 * Draws the scale ticks and both frame borders of a view mode, with the font
 * temporarily switched to Topaz and put back to PrevueC afterwards.
 *
 * The two tick calls are given the MIDPOINTS of the RastPort's bitmap, and the
 * two are computed differently:
 *
 *   vertical   (BitMap->BytesPerRow << 3) / 2     width in pixels, halved
 *   horizontal  BitMap->Rows / 2                  height, halved
 *
 * The shift is written as a shift because the original emits ASL.L #3 --
 * AGENTS.md records that writing `* 8` instead makes SAS/C widen the whole
 * computation through SWAP/CLR.W/SWAP and spill an argument, worth 28 bytes on
 * one 94-byte function.
 *
 * Both halvings are the SIGNED divide-by-two idiom (TST.L / BPL / ADDQ #1 /
 * ASR.L #1), so they happen in long even though both inputs are unsigned words.
 *
 * RastPort->BitMap is at +4 and both bitmap fields are read as words at +0 and
 * +2, which is BytesPerRow and Rows. Written through the struct so the offsets
 * fold into displacements.
 *
 * The volatile graphics header is required -- the four drawing helpers are ESQ
 * assembly and do not preserve A6. The original loads the base twice, once for
 * the opening SetFont/SetAPen/SetDrMd run and once for the closing SetFont,
 * which is exactly the convention.
 *
 * 130 ref vs 148 got, and the +18 is entirely the A6 policy.
 *
 * The arithmetic is VERBATIM, which is the point worth recording: both
 * midpoints emit e780 4a80 6a02 5280 e280 -- ASL.L #3 then the signed
 * divide-by-two idiom -- exactly as the original does. That is the AGENTS.md
 * shift rule paying off; writing `* 8` here would have widened the whole
 * computation through SWAP/CLR.W/SWAP and added a stack slot.
 *
 *   +18  the volatile base reloads before all five library calls; the original
 *        loads it twice, once for the opening SetFont/SetAPen/SetDrMd run and
 *        once for the closing SetFont. Three extra loads at 6 bytes each.
 *
 * esq-graphics-leaf.h would close all 18 and is refused for the usual reason:
 * four ESQ helpers are called between the two runs, none of them preserves A6,
 * and tools/a6_audit.py flags exactly that. The class is written up in
 * ed_draw_are_you_sure_prompt.c and is not duplicated as a SASC-MISMATCH block
 * here.
 */
#include "esq-graphics.h"

extern void TLIBA3_DrawVerticalScaleTicks(struct RastPort *rp, long mid);
extern void TLIBA3_DrawHorizontalScaleTicks(struct RastPort *rp, long mid);
extern void TLIBA3_DrawOuterFrameBorder(struct RastPort *rp);
extern void TLIBA3_DrawInnerFrameBorder(struct RastPort *rp);

extern struct TextFont *Global_HANDLE_TOPAZ_FONT;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

void TLIBA3_DrawViewModeGuides(struct RastPort *rp)
{
    SetFont(rp, Global_HANDLE_TOPAZ_FONT);
    SetAPen(rp, 1L);
    SetDrMd(rp, 0L);

    TLIBA3_DrawVerticalScaleTicks(rp, ((long)rp->BitMap->BytesPerRow << 3) / 2);
    TLIBA3_DrawHorizontalScaleTicks(rp, (long)rp->BitMap->Rows / 2);

    TLIBA3_DrawOuterFrameBorder(rp);
    TLIBA3_DrawInnerFrameBorder(rp);

    SetFont(rp, Global_HANDLE_PREVUEC_FONT);
}
