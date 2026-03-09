typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern UBYTE TLIBA1_DayEntryModeCounter;
extern WORD WDISP_WeatherStatusDigitChar;
extern LONG P_TYPE_WeatherForecastMsgPtr;
extern char *SCRIPT_PtrNoForecastWeatherData;

extern void WDISP_DrawWeatherStatusDayEntry(char *rastPort, LONG dayIndex, LONG x, LONG y);

extern LONG _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOTextLength(void *gfxBase, char *rastPort, const char *text, LONG len);
extern LONG _LVOMove(void *gfxBase, char *rastPort, LONG x, LONG y);
extern LONG _LVOText(void *gfxBase, char *rastPort, const char *text, LONG len);

void WDISP_DrawWeatherStatusSummary(char *rastPort, LONG xSpan, LONG ySpan)
{
    LONG i;
    char *textPtr;
    char *p;
    LONG textLen;
    LONG x;
    LONG y;
    LONG fontTop;
    LONG fontBaseline;

    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);

    if (TLIBA1_DayEntryModeCounter > 0 && WDISP_WeatherStatusDigitChar != 48) {
        for (i = 0; i < 3; ++i) {
            WDISP_DrawWeatherStatusDayEntry(rastPort, i, xSpan, ySpan);
        }
        return;
    }

    if (P_TYPE_WeatherForecastMsgPtr != 0) {
        textPtr = (char *)P_TYPE_WeatherForecastMsgPtr;
    } else {
        textPtr = SCRIPT_PtrNoForecastWeatherData;
    }

    p = textPtr;
    while (*p != '\0') {
        ++p;
    }
    textLen = (LONG)(p - textPtr);

    x = xSpan - _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, textPtr, textLen);
    if (x < 0) {
        ++x;
    }
    x >>= 1;

    fontTop = (LONG)(UWORD)(*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + 20));
    y = ySpan - fontTop;
    if (y < 0) {
        ++y;
    }
    y >>= 1;
    fontBaseline = (LONG)(UWORD)(*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + 26));
    y += fontBaseline;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, x, y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, textPtr, textLen);
}
