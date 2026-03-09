typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern LONG ED_EditCursorOffset;

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void ED_DrawCursorChar(void);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);

void ED_RedrawRow(LONG rowIndex)
{
    const LONG ROW_WIDTH = 40;
    const LONG PEN_FOREGROUND = 1;
    const LONG PEN_BACKGROUND = 2;
    LONG savedCursor;
    LONG rowEnd;

    savedCursor = ED_EditCursorOffset;
    ED_EditCursorOffset = ESQIFF_JMPTBL_MATH_Mulu32(rowIndex, ROW_WIDTH);

    rowEnd = ESQIFF_JMPTBL_MATH_Mulu32(rowIndex + 1, ROW_WIDTH);
    while (ED_EditCursorOffset < rowEnd) {
        ED_DrawCursorChar();
        ++ED_EditCursorOffset;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_FOREGROUND);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_BACKGROUND);

    ED_EditCursorOffset = savedCursor;
}
