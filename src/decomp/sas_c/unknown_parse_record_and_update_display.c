typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef unsigned short UWORD;

extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern UBYTE WDISP_WeatherStatusCountdown;
extern UBYTE WDISP_WeatherStatusColorCode;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern UWORD ED_DiagnosticsScreenActive;
extern char *Global_REF_RASTPORT_1;

extern LONG UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);
extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(const char *new_value, char *old_value);
extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rast, LONG x, LONG y, char *text);

LONG UNKNOWN_ParseRecordAndUpdateDisplay(const char *in)
{
    const UBYTE BRUSH_MIN = 2u;
    const UBYTE BRUSH_MAX = 6u;
    const UBYTE BRUSH_DEFAULT = 1;
    const UBYTE TOKEN_RECORD_END = 0x12;
    const ULONG LABEL_MAX = 10u;
    const UBYTE CH_NUL = 0;
    const LONG RESULT_OK = 0;
    const LONG DISPLAY_X = 0;
    const LONG DISPLAY_Y = 172;
    const char *p = in;
    char local[16];
    UBYTE countdown = *p++;
    UBYTE color = *p++;
    UBYTE brush = *p++;
    ULONG i = 0;

    p += 1;

    if (brush < BRUSH_MIN || brush > BRUSH_MAX) {
        brush = BRUSH_DEFAULT;
    }

    for (;;) {
        char c = *p++;
        local[i] = c;
        if (c == TOKEN_RECORD_END || i >= LABEL_MAX) {
            break;
        }
        i++;
    }

    local[i] = CH_NUL;
    if (local[0] == CH_NUL) {
        return RESULT_OK;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(WDISP_WeatherStatusLabelBuffer, local) != 0) {
        return RESULT_OK;
    }

    WDISP_WeatherStatusOverlayTextPtr =
        ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((char *)p, WDISP_WeatherStatusOverlayTextPtr);
    WDISP_WeatherStatusCountdown = countdown;
    WDISP_WeatherStatusColorCode = color;
    WDISP_WeatherStatusBrushIndex = brush;

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, DISPLAY_X, DISPLAY_Y, WDISP_WeatherStatusOverlayTextPtr);
    }

    return RESULT_OK;
}
