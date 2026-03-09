typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG LADFUNC_GetPackedPenLowNibble(UBYTE packed);
extern LONG LADFUNC_GetPackedPenHighNibble(UBYTE packed);

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOSetAPen(void *graphicsBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *graphicsBase, char *rastPort, LONG pen);
extern void GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);

void LADFUNC_DisplayTextPackedPens(char *rastPort, LONG x, LONG y, UBYTE packedPens, const char *text)
{
    LONG pen;

    pen = LADFUNC_GetPackedPenLowNibble(packedPens);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, pen);

    pen = LADFUNC_GetPackedPenHighNibble(packedPens);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rastPort, pen);

    GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(rastPort, x, y, text);
}
