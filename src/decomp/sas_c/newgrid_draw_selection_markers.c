#include <graphics/rastport.h>
#include <graphics/text.h>

typedef struct NEWGRID_Context {
    UBYTE pad0[60];
    struct RastPort rastPort;
} NEWGRID_Context;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern UWORD NEWGRID_RowHeightPx;
extern UBYTE CONFIG_NewgridPlaceholderBevelFlag;
extern LONG DISPTEXT_ControlMarkerXOffsetPx;

extern void NEWGRID_DrawGridCellBackground(char *gridCtx, WORD row, WORD col, LONG colorSel);
extern void NEWGRID_SetSelectionMarkers(LONG primarySel, LONG secondarySel, char *m3, char *m2, char *m1, char *m0);
extern LONG _LVOTextLength(char *rp, const char *s, LONG len);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(char *rp, LONG x, LONG y);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void _LVOMove(char *rp, LONG x, LONG y);
extern void _LVOText(char *rp, const char *s, LONG len);
extern void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(char *rp, LONG x1, LONG y1, LONG x2, LONG y2);

static LONG asr1_round_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG NEWGRID_DrawSelectionMarkers(
    char *ctx,
    WORD col,
    WORD rowKind,
    LONG colorSel,
    LONG primarySel,
    LONG secondarySel)
{
    NEWGRID_Context *ctxView;
    struct RastPort *rp;
    char m0;
    char m1;
    char m2;
    char m3;
    LONG w0;
    LONG w2;
    LONG x;
    LONG yTop;
    LONG yAlt;
    LONG yBottom;
    LONG rowHeight;
    LONG fontHeight;
    LONG isLast;

    ctxView = (NEWGRID_Context *)ctx;
    rp = &ctxView->rastPort;
    NEWGRID_DrawGridCellBackground(ctx, col, rowKind, colorSel);
    NEWGRID_SetSelectionMarkers(primarySel, secondarySel, &m3, &m2, &m1, &m0);

    if (m0 != 0) {
        w0 = _LVOTextLength((char *)rp, &m0, 1);
    } else {
        w0 = 0;
    }

    if (m2 != 0) {
        w2 = _LVOTextLength((char *)rp, &m2, 1);
    } else {
        w2 = 0;
    }

    x = (LONG)(UWORD)NEWGRID_ColumnStartXPx + ((LONG)(UWORD)NEWGRID_ColumnWidthPx * (LONG)col) + w0 + 42;
    rowHeight = (LONG)(UWORD)NEWGRID_RowHeightPx;
    fontHeight = (LONG)rp->Font->tf_YSize;

    yTop = asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight + 3;
    yAlt = asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight + asr1_round_toward_zero(rowHeight) - 1;
    yBottom = asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight) + fontHeight + asr1_round_toward_zero(rowHeight) - 1;

    NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine((char *)rp, x, yTop);
    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0) {
            NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine((char *)rp, x, yAlt);
        } else {
            NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine((char *)rp, x, yBottom);
        }
    }

    if (m0 != 0) {
        x -= w0;
        _LVOMove((char *)rp, x, yTop);
        _LVOText((char *)rp, &m0, 1);
        _LVOMove((char *)rp, x, yAlt);
        _LVOText((char *)rp, &m1, 1);
    }

    if (m2 != 0) {
        x = (LONG)(UWORD)NEWGRID_ColumnStartXPx + ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - w2 + 29;
        _LVOMove((char *)rp, x, yTop);
        _LVOText((char *)rp, &m2, 1);
        _LVOMove((char *)rp, x, yAlt);
        _LVOText((char *)rp, &m3, 1);
    }

    isLast = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (isLast != 0 && rowKind == 3 && CONFIG_NewgridPlaceholderBevelFlag == (UBYTE)89) {
        NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(
            (char *)rp,
            (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36,
            0,
            695,
            (LONG)(UWORD)NEWGRID_RowHeightPx + DISPTEXT_ControlMarkerXOffsetPx - 1);
    }

    return isLast;
}
