typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Context {
    UBYTE pad0[60];
    UBYTE rastPort[1];
} NEWGRID_Context;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern UWORD NEWGRID_RowHeightPx;
extern UBYTE CONFIG_NewgridPlaceholderBevelFlag;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG NEWGRID_SetRowColor(char *gridCtx, LONG row, LONG colorSel);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVORectFill(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);

void NEWGRID_DrawGridCellBackground(char *gridCtx, WORD row, WORD col, LONG colorSel)
{
    const LONG GRID_X_OFFSET = 36;
    const LONG GRID_RIGHT_EDGE = 695;
    const LONG ROWCOL_SPLIT = 3;
    const LONG COLOR_NONE = -1;
    const LONG ZERO = 0;
    const LONG ONE = 1;
    const WORD COL_BEVEL = 3;
    const UBYTE BEVEL_ENABLED_CHAR = 89;
    NEWGRID_Context *ctxView;
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;
    LONG rc;

    (void)Global_REF_GRAPHICS_LIBRARY;

    ctxView = (NEWGRID_Context *)gridCtx;
    x1 = (LONG)(UWORD)NEWGRID_ColumnStartXPx + ((LONG)(UWORD)NEWGRID_ColumnWidthPx * (LONG)row) + GRID_X_OFFSET;
    y1 = ZERO;

    rc = (LONG)row + (LONG)col;
    if (rc >= ROWCOL_SPLIT) {
        x2 = GRID_RIGHT_EDGE;
    } else {
        x2 = x1 + ((LONG)(UWORD)NEWGRID_ColumnWidthPx * (LONG)col) - ONE;
    }

    y2 = (LONG)(UWORD)NEWGRID_RowHeightPx - ONE;

    if (colorSel != COLOR_NONE) {
        NEWGRID_SetRowColor(gridCtx, (LONG)row, colorSel);
        _LVOSetAPen((char *)ctxView->rastPort, colorSel);
        _LVORectFill((char *)ctxView->rastPort, x1, y1, x2, y2);
    }

    if (col == COL_BEVEL && CONFIG_NewgridPlaceholderBevelFlag == BEVEL_ENABLED_CHAR) {
        NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame((char *)ctxView->rastPort, x1, y1, x2, y2);
    } else {
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight((char *)ctxView->rastPort, x1, y1, x2, y2);
    }
}
