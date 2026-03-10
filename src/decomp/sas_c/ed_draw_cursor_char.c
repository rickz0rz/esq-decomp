typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern LONG ED_EditCursorOffset;
extern LONG ED_CursorColumnIndex;
extern LONG ED_ViewportOffset;
extern UBYTE ED_EditBufferLive[];
extern char ED_EditBufferScratch[];

extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(LONG value);
extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(LONG value);
extern void ED_UpdateCursorPosFromIndex(LONG index);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOMove(void *gfxBase, char *rastPort, LONG x, LONG y);
extern void _LVOText(void *gfxBase, char *rastPort, const char *text, LONG len);

void ED_DrawCursorChar(void)
{
    const LONG COLUMN_STRIDE_SHIFT = 4;
    const LONG CURSOR_X_OFFSET = 40;
    const LONG ROW_HEIGHT = 30;
    const LONG CURSOR_Y_OFFSET = 90;
    const LONG CHAR_LEN_1 = 1;
    LONG packed = (LONG)ED_EditBufferLive[ED_EditCursorOffset];
    LONG x;
    LONG y;

    _LVOSetAPen(
        Global_REF_GRAPHICS_LIBRARY,
        Global_REF_RASTPORT_1,
        (LONG)(UBYTE)GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(packed));

    _LVOSetBPen(
        Global_REF_GRAPHICS_LIBRARY,
        Global_REF_RASTPORT_1,
        (LONG)(UBYTE)GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(packed));

    ED_UpdateCursorPosFromIndex(ED_EditCursorOffset);

    x = (ED_CursorColumnIndex << COLUMN_STRIDE_SHIFT) - ED_CursorColumnIndex + CURSOR_X_OFFSET;
    y = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, ROW_HEIGHT) + CURSOR_Y_OFFSET;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, x, y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, &ED_EditBufferScratch[ED_EditCursorOffset], CHAR_LEN_1);
}
