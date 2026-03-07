typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern LONG ED_EditCursorOffset;
extern LONG ED_CursorColumnIndex;
extern LONG ED_ViewportOffset;
extern UBYTE ED_EditBufferLive[];
extern char ED_EditBufferScratch[];

extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(LONG value);
extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(LONG value);
extern void ED_UpdateCursorPosFromIndex(LONG index);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOMove(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVOText(void *gfxBase, void *rastPort, const char *text, LONG len);

void ED_DrawCursorChar(void)
{
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

    x = (ED_CursorColumnIndex << 4) - ED_CursorColumnIndex + 40;
    y = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 30) + 90;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, x, y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, &ED_EditBufferScratch[ED_EditCursorOffset], 1);
}
