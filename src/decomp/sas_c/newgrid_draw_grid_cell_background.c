typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern UWORD NEWGRID_RowHeightPx;
extern UBYTE CONFIG_NewgridPlaceholderBevelFlag;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void NEWGRID_SetRowColor(void *gridCtx, LONG row, LONG colorSel);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVORectFill(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);

void NEWGRID_DrawGridCellBackground(void *gridCtx, WORD row, WORD col, LONG colorSel)
{
    UBYTE *rast;
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;
    LONG rc;

    (void)Global_REF_GRAPHICS_LIBRARY;

    rast = (UBYTE *)gridCtx + 60;
    x1 = (LONG)(UWORD)NEWGRID_ColumnStartXPx + ((LONG)(UWORD)NEWGRID_ColumnWidthPx * (LONG)row) + 36;
    y1 = 0;

    rc = (LONG)row + (LONG)col;
    if (rc >= 3) {
        x2 = 695;
    } else {
        x2 = x1 + ((LONG)(UWORD)NEWGRID_ColumnWidthPx * (LONG)col) - 1;
    }

    y2 = (LONG)(UWORD)NEWGRID_RowHeightPx - 1;

    if (colorSel != -1) {
        NEWGRID_SetRowColor(gridCtx, (LONG)row, colorSel);
        _LVOSetAPen(rast, colorSel);
        _LVORectFill(rast, x1, y1, x2, y2);
    }

    if (col == 3 && CONFIG_NewgridPlaceholderBevelFlag == (UBYTE)89) {
        NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(rast, x1, y1, x2, y2);
    } else {
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, x1, y1, x2, y2);
    }
}
