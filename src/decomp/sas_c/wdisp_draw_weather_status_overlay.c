typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct WDISP_WeatherBrush {
    UBYTE pad0[176];
    UWORD width;
    UWORD height;
} WDISP_WeatherBrush;

extern UBYTE WDISP_WeatherStatusCountdown;
extern UWORD WDISP_WeatherStatusDigitChar;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern char *P_TYPE_WeatherCurrentMsgPtr;
extern const char *Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;

extern ULONG ESQFUNC_PwBrushListHead;
extern ULONG ESQFUNC_WeatherBrushPredicateNames;
extern ULONG ESQFUNC_STR_I5[];
extern const char Global_STR_WDISP_C[];

extern void *WDISP_JMPTBL_BRUSH_FindBrushByPredicate(void *predicate, void *listHead);
extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(const char *src, char *oldPtr);
extern void MEMORY_DeallocateMemory(const char *tag, LONG pool, void *ptr, LONG size);

void WDISP_DrawWeatherStatusOverlay(char *rastPort, LONG xSpan, LONG ySpan)
{
    WDISP_WeatherBrush *brush;
    char *textCopy;
    char *scan;
    const char *fallback;
    LONG textLen;
    LONG lineCount;
    LONG brushWidth;
    LONG brushHeight;

    (void)rastPort;
    (void)xSpan;
    (void)ySpan;

    if (WDISP_WeatherStatusCountdown == 0 || WDISP_WeatherStatusDigitChar == 48) {
        fallback = P_TYPE_WeatherCurrentMsgPtr;
        if (fallback == (char *)0) {
            fallback = Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;
        }
        (void)fallback;
        return;
    }

    if (WDISP_WeatherStatusBrushIndex == 1) {
        brush = (WDISP_WeatherBrush *)WDISP_JMPTBL_BRUSH_FindBrushByPredicate(
            (void *)ESQFUNC_WeatherBrushPredicateNames,
            (void *)&ESQFUNC_PwBrushListHead
        );
    } else {
        brush = (WDISP_WeatherBrush *)WDISP_JMPTBL_BRUSH_FindBrushByPredicate(
            (void *)ESQFUNC_STR_I5[(ULONG)WDISP_WeatherStatusBrushIndex],
            (void *)&ESQFUNC_PwBrushListHead);
    }

    if (brush != (WDISP_WeatherBrush *)0) {
        brushWidth = brush->width;
        brushHeight = brush->height;
    } else {
        brushWidth = 0xAA;
        brushHeight = 90;
    }
    (void)brushWidth;
    (void)brushHeight;

    textCopy = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(WDISP_WeatherStatusOverlayTextPtr, (char *)0);
    if (textCopy == (char *)0) {
        return;
    }

    textLen = 0;
    while (textCopy[textLen] != 0) {
        textLen++;
    }

    lineCount = 0;
    scan = textCopy;
    while (scan[0] != 0) {
        if (scan[0] == 24) {
            scan[0] = 0;
            lineCount++;
        }
        scan++;
    }

    scan = textCopy;
    if (scan[0] == 0) {
        scan++;
        lineCount--;
    }

    if (lineCount > 10) {
        lineCount = 10;
    }

    MEMORY_DeallocateMemory(Global_STR_WDISP_C, 301, textCopy, textLen + 1);
}
