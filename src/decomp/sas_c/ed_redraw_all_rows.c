typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern LONG ED_EditCursorOffset;
extern LONG ED_BlockOffset;
extern LONG ED_TextLimit;
extern UBYTE ED_EditBufferLive[];

extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(LONG value);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern void ED_DrawCursorChar(void);

void ED_RedrawAllRows(void)
{
    LONG savedCursor;
    LONG endY;

    savedCursor = ED_EditCursorOffset;

    _LVOSetAPen(
        Global_REF_GRAPHICS_LIBRARY,
        Global_REF_RASTPORT_1,
        (LONG)(UBYTE)GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble((LONG)ED_EditBufferLive[0]));

    endY = ESQIFF_JMPTBL_MATH_Mulu32(ED_TextLimit, 30) + 68;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 68, 640, endY);

    ED_EditCursorOffset = 0;
    while (ED_EditCursorOffset < ED_BlockOffset) {
        ED_DrawCursorChar();
        ++ED_EditCursorOffset;
    }

    ED_EditCursorOffset = savedCursor;
}
