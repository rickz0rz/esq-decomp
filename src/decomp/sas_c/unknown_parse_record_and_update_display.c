typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef unsigned short UWORD;

extern UBYTE WDISP_WeatherStatusLabelBuffer[];
extern UBYTE *WDISP_WeatherStatusOverlayTextPtr;
extern UBYTE WDISP_WeatherStatusCountdown;
extern UBYTE WDISP_WeatherStatusColorCode;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern UWORD ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;

extern LONG UNKNOWN_JMPTBL_ESQ_WildcardMatch(const UBYTE *pattern, const UBYTE *text);
extern UBYTE *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(UBYTE *new_value, UBYTE *old_value);
extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rast, LONG x, LONG y, UBYTE *text);

LONG UNKNOWN_ParseRecordAndUpdateDisplay(const UBYTE *in)
{
    const UBYTE *p = in;
    UBYTE local[16];
    UBYTE countdown = *p++;
    UBYTE color = *p++;
    UBYTE brush = *p++;
    ULONG i = 0;

    p += 1;

    if (brush < 2u || brush > 6u) {
        brush = 1;
    }

    for (;;) {
        UBYTE c = *p++;
        local[i] = c;
        if (c == 0x12 || i >= 10u) {
            break;
        }
        i++;
    }

    local[i] = 0;
    if (local[0] == 0) {
        return 0;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(WDISP_WeatherStatusLabelBuffer, local) != 0) {
        return 0;
    }

    WDISP_WeatherStatusOverlayTextPtr =
        ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((UBYTE *)p, WDISP_WeatherStatusOverlayTextPtr);
    WDISP_WeatherStatusCountdown = countdown;
    WDISP_WeatherStatusColorCode = color;
    WDISP_WeatherStatusBrushIndex = brush;

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, 0, 172, WDISP_WeatherStatusOverlayTextPtr);
    }

    return 0;
}
