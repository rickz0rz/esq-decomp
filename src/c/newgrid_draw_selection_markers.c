/* RESTORES: NEWGRID_DrawSelectionMarkers
 * MODULE:   modules/groups/b/a/newgrid1b_p1.s
 * STATUS:   behavioural
 *
 * Draws one grid cell with up to four single-character selection markers: two
 * stacked on the left edge and two on the right. NEWGRID_SetSelectionMarkers
 * fills the four characters through pointers, and a marker of 0 means "draw
 * nothing on that side".
 *
 * Only the FIRST character of each pair gates its side. If left1 is zero
 * neither left marker is drawn, even when left2 is set.
 *
 * The left markers push the cell text right by their own width, then the text
 * origin is moved back by the same amount to place them. The right markers are
 * positioned from the far edge of three columns instead.
 *
 * The three y values are all built from the same half row height and the font
 * baseline, and differ only in the `- 4` and the extra half row. y1 is the top
 * line, y2 the second line for a selected last line, and y3 the second line
 * otherwise.
 *
 * The closing horizontal bevel needs all three of: the last line reached, row
 * index 3, and CONFIG_NewgridPlaceholderBevelFlag equal to 89 -- the letter
 * 'Y'.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffdc                   LINK.W A5,#-36
 *   got:     9efc0030                   SUBA.W #48,A7
 *   summary: 684 bytes in the original against 656 emitted, 28 SHORT over 32
 *            regions. The original reloads the rastport and the font pointer
 *            from the frame at nearly every use; 6.51 holds both. Not itemised
 *            further -- see AGENTS.md rule 3.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

struct GridCtx {
    char            pad0[60];
    struct RastPort rp;             /* 60 */
};

extern void NEWGRID_DrawGridCellBackground(struct GridCtx *ctx, long col,
                                           long row, long a);
extern void NEWGRID_SetSelectionMarkers(long a, long b, char *m1, char *m2,
                                        char *m3, char *m4);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(struct RastPort *rp,
                                                       long x, long y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(struct RastPort *rp,
                            long x0, long y0, long x1, long y1);

extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_ColumnWidthPx;
extern unsigned short NEWGRID_RowHeightPx;
extern long           DISPTEXT_ControlMarkerXOffsetPx;
extern unsigned char  CONFIG_NewgridPlaceholderBevelFlag;

long NEWGRID_DrawSelectionMarkers(struct GridCtx *ctx, short col, short row,
                                  long cellArg, long markA, long markB)
{
    struct RastPort *rp;
    char left1, left2, right1, right2;
    long leftWidth, rightWidth, x, y1, y2, y3, baseline, half, last;

    rp = &ctx->rp;
    NEWGRID_DrawGridCellBackground(ctx, (long)col, (long)row, cellArg);
    NEWGRID_SetSelectionMarkers(markA, markB, &left1, &left2, &right1, &right2);

    if (left1 != 0)
        leftWidth = TextLength(rp, &left1, 1L);
    else
        leftWidth = 0;

    if (right1 != 0)
        rightWidth = TextLength(rp, &right1, 1L);
    else
        rightWidth = 0;

    x = (long)NEWGRID_ColumnStartXPx
        + (long)col * (long)NEWGRID_ColumnWidthPx + leftWidth + 42;

    baseline = rp->Font->tf_Baseline;
    half = (long)NEWGRID_RowHeightPx / 2;
    y1 = (half - baseline - 4) / 2 + baseline + 3;
    y2 = (half - baseline - 4) / 2 + baseline + half - 1;
    y3 = (half - baseline) / 2 + baseline + half - 1;

    NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, y1);

    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0)
            NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, y2);
        else
            NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, y3);
    }

    if (left1 != 0) {
        x -= leftWidth;
        Move(rp, x, y1);
        Text(rp, &left1, 1L);
        Move(rp, x, y2);
        Text(rp, &left2, 1L);
    }

    if (right1 != 0) {
        x = (long)NEWGRID_ColumnStartXPx + (long)NEWGRID_ColumnWidthPx * 3
            - rightWidth + 29;
        Move(rp, x, y1);
        Text(rp, &right1, 1L);
        Move(rp, x, y2);
        Text(rp, &right2, 1L);
    }

    last = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (last != 0 && row == 3 && CONFIG_NewgridPlaceholderBevelFlag == 89)
        NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(rp,
            (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L,
            (long)NEWGRID_RowHeightPx + DISPTEXT_ControlMarkerXOffsetPx - 1);

    return last;
}
