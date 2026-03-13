typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef unsigned short UWORD;

typedef struct UNKNOWN_StatusRecordHeader {
    UBYTE countdown0;
    UBYTE color1;
    UBYTE brush2;
    UBYTE pad3;
} UNKNOWN_StatusRecordHeader;

extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern UBYTE WDISP_WeatherStatusCountdown;
extern UBYTE WDISP_WeatherStatusColorCode;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern UWORD ED_DiagnosticsScreenActive;
extern char *Global_REF_RASTPORT_1;

extern LONG ESQ_WildcardMatch(const char *pattern, const char *text);
extern char *ESQPARS_ReplaceOwnedString(const char *new_value, char *old_value);
extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rast, LONG x, LONG y, const char *text);

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
    const UNKNOWN_StatusRecordHeader *header;
    const char *p;
    char local[16];
    UBYTE countdown;
    UBYTE color;
    UBYTE brush;
    ULONG i = 0;

    header = (const UNKNOWN_StatusRecordHeader *)in;
    countdown = header->countdown0;
    color = header->color1;
    brush = header->brush2;
    p = in + sizeof(UNKNOWN_StatusRecordHeader);

    if (brush < BRUSH_MIN || brush > BRUSH_MAX) {
        brush = BRUSH_DEFAULT;
    }

    for (;;) {
        char c = *p++;
        local[i] = c;
        if (c == TOKEN_RECORD_END || i >= LABEL_SCAN_LIMIT) {
            break;
        }
        i++;
    }

    local[i] = CH_NUL;
    if (local[0] == CH_NUL) {
        return RESULT_OK;
    }

    if (ESQ_WildcardMatch(WDISP_WeatherStatusLabelBuffer, local) != 0) {
        return RESULT_OK;
    }

    WDISP_WeatherStatusOverlayTextPtr =
        ESQPARS_ReplaceOwnedString(p, WDISP_WeatherStatusOverlayTextPtr);
    WDISP_WeatherStatusCountdown = countdown;
    WDISP_WeatherStatusColorCode = color;
    WDISP_WeatherStatusBrushIndex = brush;

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, DISPLAY_X, DISPLAY_Y, WDISP_WeatherStatusOverlayTextPtr);
    }

    return RESULT_OK;
}
