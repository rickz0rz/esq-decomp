/* RESTORES: NEWGRID_HandleAltGridState
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2.s
 * STATUS:   behavioural
 *
 * A two-state machine on NEWGRID_AltGridStateLatch. State 4 draws one entry and
 * then the frame; state 5 draws the frame alone with the visible-line count
 * forced to -1. Any other latch value, and a NULL context, reset the latch to 4
 * and do nothing else.
 *
 * NEWGRID_DrawGridFrameAlt returns "the current line is the last one", and that
 * return picks the next state: true keeps state 4, false moves to state 5. The
 * same value also becomes the draw flag passed to NEWGRID_DrawGridCell, so the
 * cell and the frame always agree.
 *
 * The alternate entry table is used when the selector is 1, or when the
 * half-hour slot index is 1. That second test is a WORD compare in the original
 * (SUBQ.W #1,D0), so the helper is declared to return short here.
 *
 * The aux record holds a pointer per selector at offset 56. Both the pointer
 * and the first byte of what it points at must be non-zero, or the function
 * returns without drawing.
 *
 * SASC-MISMATCH: a5-frame-and-call-width
 *   ref:     4e55fff8                   LINK.W A5,#-8
 *   got:     48e70734                   no frame; locals live in registers
 *   summary: 450 bytes in the original against 472 emitted, +22 over 25
 *            regions. 6.51 keeps both entry pointers in callee-saved registers
 *            where the original spills them to the frame. The rest is the usual
 *            4EBA against 6100 call width. Not itemised further -- see
 *            AGENTS.md rule 3.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

struct GridCtx {
    char            pad0[32];
    long            visibleLines;   /* 32 */
    char            pad1[16];
    short           headerHalf;     /* 52 */
    char            pad2[6];
    struct RastPort rp;             /* 60 */
};

struct GridAux {
    char  pad0[56];
    char *slots[1];                 /* 56, indexed by the selector */
};

extern void *ESQDISP_GetEntryPointerByMode(long index, long m);
extern struct GridAux *ESQDISP_GetEntryAuxPointerByMode(
                                                       long index, long m);
extern short ESQ_GetHalfHourSlotIndex(void *daySlot);
extern long  TLIBA_FindFirstWildcardMatchIndex(
                                                       struct GridAux *aux);
extern void  DISPTEXT_SetLayoutParams(long width, long a,
                                                      long b);
extern long  DISPTEXT_ComputeVisibleLineCount(long mode);
extern void  NEWGRID_DrawGridEntry(struct RastPort *rp, void *entry,
                                   struct GridAux *aux, long selector,
                                   long a, long b, long c);
extern long  NEWGRID_DrawGridFrameAlt(struct GridCtx *ctx);
extern void  NEWGRID_DrawGridCell(struct RastPort *rp, void *entry, long flag);

extern long  NEWGRID_AltGridStateLatch;
extern short NEWGRID_ShowtimeEntryVariantFlag;
extern unsigned short NEWGRID_ColumnWidthPx;
extern char  CLOCK_DaySlotIndex[];

long NEWGRID_HandleAltGridState(struct GridCtx *ctx, long index, short selector)
{
    void *entry;
    struct GridAux *aux;
    long state;

    if (ctx == 0) {
        NEWGRID_AltGridStateLatch = 4;
        return NEWGRID_AltGridStateLatch;
    }

    if (NEWGRID_AltGridStateLatch == 4) {
        entry = ESQDISP_GetEntryPointerByMode(index, 1L);
        aux   = ESQDISP_GetEntryAuxPointerByMode(index, 1L);
        if (aux != 0) {
            if (selector == 1 ||
                ESQ_GetHalfHourSlotIndex(CLOCK_DaySlotIndex)
                    == 1) {
                index = TLIBA_FindFirstWildcardMatchIndex(aux);
                entry = ESQDISP_GetEntryPointerByMode(index, 2L);
                aux = ESQDISP_GetEntryAuxPointerByMode(index,
                                                                       2L);
            }
        }

        if (entry == 0 || aux == 0)
            return NEWGRID_AltGridStateLatch;
        if (aux->slots[selector] == 0)
            return NEWGRID_AltGridStateLatch;
        if (*aux->slots[selector] == 0)
            return NEWGRID_AltGridStateLatch;

        DISPTEXT_SetLayoutParams(
            (long)NEWGRID_ColumnWidthPx * 3 - 12, 20L, 1L);

        if (NEWGRID_ShowtimeEntryVariantFlag != 0)
            NEWGRID_DrawGridEntry(&ctx->rp, entry, aux, (long)selector,
                                  2L, 1L, 4L);
        else
            NEWGRID_DrawGridEntry(&ctx->rp, entry, aux, (long)selector,
                                  3L, 1L, 4L);

        ctx->visibleLines = DISPTEXT_ComputeVisibleLineCount(2L);
        if (NEWGRID_DrawGridFrameAlt(ctx) != 0)
            state = 4;
        else
            state = 5;
        NEWGRID_AltGridStateLatch = state;
        if (state == 4)
            NEWGRID_DrawGridCell(&ctx->rp, entry, 1L);
        else
            NEWGRID_DrawGridCell(&ctx->rp, entry, 0L);
    } else if (NEWGRID_AltGridStateLatch == 5) {
        ctx->visibleLines = -1;
        if (NEWGRID_DrawGridFrameAlt(ctx) != 0)
            NEWGRID_AltGridStateLatch = 4;
        else
            NEWGRID_AltGridStateLatch = 5;
    } else {
        NEWGRID_AltGridStateLatch = 4;
    }

    return NEWGRID_AltGridStateLatch;
}
