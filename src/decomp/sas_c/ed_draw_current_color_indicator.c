typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;
extern const char Global_STR_CURRENT_COLOR_FORMATTED[];

extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(LONG value);
extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(LONG value);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_DrawCurrentColorIndicator(UBYTE colorValue)
{
    const LONG SWATCH_MIN_X = 204;
    const LONG SWATCH_MIN_Y = 250;
    const LONG SWATCH_MAX_X = 474;
    const LONG SWATCH_MAX_Y = 275;
    const LONG LABEL_Y = 272;
    const LONG LABEL_X = 205;
    const LONG PEN_DEFAULT_FOREGROUND = 1;
    const LONG PEN_DEFAULT_BACKGROUND = 2;
    char colorLabel[41];
    LONG hi;
    LONG lo;

    hi = GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble((LONG)colorValue);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, (LONG)(UBYTE)hi);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, SWATCH_MIN_X, SWATCH_MIN_Y, SWATCH_MAX_X, SWATCH_MAX_Y);

    lo = GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble((LONG)colorValue);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, (LONG)(UBYTE)lo);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, (LONG)(UBYTE)hi);

    GROUP_AM_JMPTBL_WDISP_SPrintf(colorLabel, Global_STR_CURRENT_COLOR_FORMATTED, (LONG)colorValue);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, LABEL_Y, LABEL_X, colorLabel);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_DEFAULT_FOREGROUND);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_DEFAULT_BACKGROUND);
}
