typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_RowHeightPx;

extern UBYTE *NEWGRID2_JMPTBL_STR_SkipClass3Chars(UBYTE *s);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID_DrawGridCellText(void *rastPort, UBYTE *leftText, UBYTE *rightText, LONG rowFlag);

void NEWGRID_DrawGridCell(void *rastPort, UBYTE *cell, LONG rowFlag)
{
    UBYTE *left;
    UBYTE *right;
    LONG x2;
    LONG y2;

    left = NEWGRID2_JMPTBL_STR_SkipClass3Chars(cell + 1);
    right = NEWGRID2_JMPTBL_STR_SkipClass3Chars(cell + 19);

    x2 = (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35;
    y2 = (LONG)(UWORD)NEWGRID_RowHeightPx - 1;

    if (rowFlag == 0) {
        NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(rastPort, 0, 0, x2, y2);
    } else {
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rastPort, 0, 0, x2, y2);
    }

    NEWGRID_DrawGridCellText(rastPort, left, right, rowFlag);
}
