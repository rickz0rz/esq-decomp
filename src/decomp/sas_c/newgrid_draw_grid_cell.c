typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
    UBYTE leftText[18];
    UBYTE rightText[1];
} NEWGRID_Entry;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_RowHeightPx;

extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID_DrawGridCellText(void *rastPort, char *leftText, char *rightText, LONG rowFlag);

void NEWGRID_DrawGridCell(void *rastPort, UBYTE *cell, LONG rowFlag)
{
    NEWGRID_Entry *cellView;
    char *left;
    char *right;
    LONG x2;
    LONG y2;

    cellView = (NEWGRID_Entry *)cell;
    left = NEWGRID2_JMPTBL_STR_SkipClass3Chars(cellView->leftText);
    right = NEWGRID2_JMPTBL_STR_SkipClass3Chars(cellView->rightText);

    x2 = (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35;
    y2 = (LONG)(UWORD)NEWGRID_RowHeightPx - 1;

    if (rowFlag == 0) {
        NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(rastPort, 0, 0, x2, y2);
    } else {
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rastPort, 0, 0, x2, y2);
    }

    NEWGRID_DrawGridCellText(rastPort, left, right, rowFlag);
}
