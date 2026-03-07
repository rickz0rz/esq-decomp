typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;
extern const char Global_STR_CURRENT_COLOR_FORMATTED[];

extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(LONG value);
extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(LONG value);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVORectFill(void *gfxBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_DrawCurrentColorIndicator(UBYTE colorValue)
{
    char colorLabel[41];
    LONG hi;
    LONG lo;

    hi = GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble((LONG)colorValue);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, (LONG)(UBYTE)hi);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 204, 250, 474, 275);

    lo = GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble((LONG)colorValue);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, (LONG)(UBYTE)lo);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, (LONG)(UBYTE)hi);

    GROUP_AM_JMPTBL_WDISP_SPrintf(colorLabel, Global_STR_CURRENT_COLOR_FORMATTED, (LONG)colorValue);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 272, 205, colorLabel);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
}
