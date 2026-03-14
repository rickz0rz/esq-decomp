#include <exec/types.h>
typedef struct WeatherStatusRecordHeader {
    UBYTE countdown0;
    UBYTE color1;
    UBYTE brush2;
    UBYTE pad3;
} WeatherStatusRecordHeader;

extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern UBYTE WDISP_WeatherStatusCountdown;
extern UBYTE WDISP_WeatherStatusColorCode;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern UWORD ED_DiagnosticsScreenActive;
extern char *Global_REF_RASTPORT_1;

extern LONG ESQ_WildcardMatch(const char *pattern, const char *text);
extern char *ESQPARS_ReplaceOwnedString(const char *new_value, char *old_value);
extern void DISPLIB_DisplayTextAtPosition(char *rast, LONG x, LONG y, const char *text);

LONG UNKNOWN_ParseRecordAndUpdateDisplay(const char *in)
{
    const UBYTE BRUSH_MIN = 2u;
    const UBYTE BRUSH_MAX = 6u;
    const UBYTE BRUSH_DEFAULT = 1;
    const UBYTE TOKEN_RECORD_END = 0x12;
    const ULONG LABEL_SCAN_LIMIT = 10u;
    const UBYTE CH_NUL = 0;
    const LONG RESULT_OK = 0;
    const LONG DISPLAY_X = 0;
    const LONG DISPLAY_Y = 172;
    const WeatherStatusRecordHeader *header;
    const char *p;
    char statusLabel[16];
    UBYTE countdown;
    UBYTE color;
    UBYTE brush;
    ULONG i = 0;

    header = (const WeatherStatusRecordHeader *)in;
    countdown = header->countdown0;
    color = header->color1;
    brush = header->brush2;
    p = in + sizeof(WeatherStatusRecordHeader);

    if (brush < BRUSH_MIN || brush > BRUSH_MAX) {
        brush = BRUSH_DEFAULT;
    }

    for (;;) {
        char c = *p++;
        statusLabel[i] = c;
        if (c == TOKEN_RECORD_END || i >= LABEL_SCAN_LIMIT) {
            break;
        }
        i++;
    }

    statusLabel[i] = CH_NUL;
    if (statusLabel[0] == CH_NUL) {
        return RESULT_OK;
    }

    if (ESQ_WildcardMatch(WDISP_WeatherStatusLabelBuffer, statusLabel) != 0) {
        return RESULT_OK;
    }

    WDISP_WeatherStatusOverlayTextPtr =
        ESQPARS_ReplaceOwnedString(p, WDISP_WeatherStatusOverlayTextPtr);
    WDISP_WeatherStatusCountdown = countdown;
    WDISP_WeatherStatusColorCode = color;
    WDISP_WeatherStatusBrushIndex = brush;

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, DISPLAY_X, DISPLAY_Y, WDISP_WeatherStatusOverlayTextPtr);
    }

    return RESULT_OK;
}
