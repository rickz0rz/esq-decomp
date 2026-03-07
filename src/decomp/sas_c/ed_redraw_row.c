typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern LONG ED_EditCursorOffset;

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void ED_DrawCursorChar(void);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);

void ED_RedrawRow(LONG rowIndex)
{
    LONG savedCursor;
    LONG rowEnd;

    savedCursor = ED_EditCursorOffset;
    ED_EditCursorOffset = ESQIFF_JMPTBL_MATH_Mulu32(rowIndex, 40);

    rowEnd = ESQIFF_JMPTBL_MATH_Mulu32(rowIndex + 1, 40);
    while (ED_EditCursorOffset < rowEnd) {
        ED_DrawCursorChar();
        ++ED_EditCursorOffset;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);

    ED_EditCursorOffset = savedCursor;
}
