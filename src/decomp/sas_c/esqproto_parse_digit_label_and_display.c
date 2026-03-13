typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

typedef struct ESQPROTO_DigitLabelHeader {
    UBYTE digit0;
} ESQPROTO_DigitLabelHeader;

extern UWORD WDISP_WeatherStatusDigitChar;
extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusTextPtr;
extern UWORD ED_DiagnosticsScreenActive;
extern char *Global_REF_RASTPORT_1;

extern char *ESQPARS_ReplaceOwnedString(const char *new_value, char *old_value);
extern void DISPLIB_DisplayTextAtPosition(char *rast, LONG x, LONG y, const char *text);

char *ESQPROTO_ParseDigitLabelAndDisplay(const char *in)
{
    const UBYTE DIGIT_MIN = '0';
    const UBYTE DIGIT_MAX = '9';
    const UWORD DIGIT_FALLBACK = '0';
    const ULONG LABEL_SCAN_LIMIT = 10UL;
    const UBYTE TOKEN_RECORD_END = 0x12;
    const LONG DISPLAY_X = 0;
    const LONG DISPLAY_Y = 172;
    const ESQPROTO_DigitLabelHeader *header;
    const char *p;
    char local[16];
    ULONG i = 0;
    UWORD digit;

    header = (const ESQPROTO_DigitLabelHeader *)in;
    digit = (UWORD)header->digit0;
    p = in + sizeof(ESQPROTO_DigitLabelHeader);

    WDISP_WeatherStatusDigitChar = digit;
    if (digit < (UWORD)DIGIT_MIN || digit > (UWORD)DIGIT_MAX) {
        WDISP_WeatherStatusDigitChar = DIGIT_FALLBACK;
    }

    for (;;) {
        char c = *p++;
        local[i] = c;
        if (c == TOKEN_RECORD_END || i >= LABEL_SCAN_LIMIT) {
            break;
        }
        i++;
    }

    local[i] = 0;

    {
        char *src = local;
        char *dst = WDISP_WeatherStatusLabelBuffer;
        while ((*dst++ = *src++) != 0) {
        }
    }

    WDISP_WeatherStatusTextPtr =
        ESQPARS_ReplaceOwnedString(p, WDISP_WeatherStatusTextPtr);

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, DISPLAY_X, DISPLAY_Y, WDISP_WeatherStatusTextPtr);
    }

    return WDISP_WeatherStatusTextPtr;
}
