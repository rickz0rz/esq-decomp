/* RESTORES: NEWGRID_DrawDateBanner
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * Draws the date strip across the top of the grid: a filled bar in the row
 * colour, two bevel boxes split at the column start, and the generated date
 * string centred in the right-hand box both horizontally and vertically.
 *
 * The RastPort is at offset 60 of the grid context, and the two trailing stores
 * (17 as a word at 52 and as a long at 32) record the strip height for whoever
 * lays out the rows below it.
 *
 * 334 bytes in the original, 308 emitted, and the itemisation is INCOMPLETE. Say
 * so rather than guess: casm.py aligns the first two thirds cleanly -- all of it
 * frame class and reload-vs-cache, the shapes seen everywhere else today -- and
 * then desynchronises through the centring arithmetic, because the original
 * reloads the RastPort and the font height from the frame between almost every
 * operation and 6.51 does not. Same instructions, too rearranged for a hunk
 * aligner to pair up.
 *
 * So: the -26 is confidently the frame class in kind, and NOT confidently
 * itemised in amount. It is recorded the way
 * cleanup_release_display_resources.c records its unattributed tail.
 *
 * The semantics are checked against the reference independently of the byte
 * count: RastPort at context offset 60, Font at RastPort offset 52, tf_Baseline
 * at font offset 26, the two bevel boxes splitting at ColumnStartXPx+35 and +36,
 * the horizontal centre over three column widths, and the two trailing height
 * stores as a word at 52 and a long at 32.
 *
 * SASC-MISMATCH: unattributed-tail-delta
 *   summary: The centring arithmetic cannot be paired instruction-for-instruction
 *            against the original because of the reload difference above. Anyone
 *            picking this up should re-run casm.py after the frame class is fixed
 *            by a compiler find -- the tail should align on its own then.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ff8c / 226dff94 six times / 4ced088cff7c 4e5d
 *   got:     the RastPort held in a register
 *   summary: The A5-frame class. Six reloads of the RastPort pointer alone.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
#include <string.h>
#include "esq-graphics.h"

extern void NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(char *out);
extern long NEWGRID_SetRowColor(void *ctx, long row, long which);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp,
                                                             long x1, long y1,
                                                             long x2, long y2);

extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_ColumnWidthPx;

struct GridContext {
    char pad[32];
    long stripHeightLong;       /* 32 */
    char pad2[16];
    short stripHeightWord;      /* 52 */
    char pad3[6];
    struct RastPort rp;         /* 60 */
};

void NEWGRID_DrawDateBanner(struct GridContext *ctx)
{
    char date[100];
    struct RastPort *rp;
    long x;
    long width;
    long spare;
    long textX;
    long height;
    long textWidth;

    rp = &ctx->rp;
    NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(date);

    SetDrMd(rp, 0L);
    SetAPen(rp, NEWGRID_SetRowColor(ctx, 0L, 7L));
    RectFill(rp, 0L, 0L, 695L, 33L);

    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rp, 0L, 0L, NEWGRID_ColumnStartXPx + 35, 33L);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rp, NEWGRID_ColumnStartXPx + 36, 0L, 695L, 33L);

    SetAPen(rp, 3L);

    x = NEWGRID_ColumnStartXPx;
    width = NEWGRID_ColumnWidthPx * 3;
    textWidth = TextLength(rp, date, (long)strlen(date));
    spare = width - textWidth;
    if (spare < 0)
        spare = spare + 1;
    spare = spare >> 1;
    textX = x + spare + 36;

    height = rp->Font->tf_Baseline;
    spare = 34 - height;
    if (spare < 0)
        spare = spare + 1;
    spare = (spare >> 1) + height - 1;

    Move(rp, textX, spare);
    Text(rp, date, (long)strlen(date));

    ctx->stripHeightWord = 17;
    ctx->stripHeightLong = 17;
}
