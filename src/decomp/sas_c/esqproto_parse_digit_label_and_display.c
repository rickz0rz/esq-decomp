typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern UWORD WDISP_WeatherStatusDigitChar;
extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusTextPtr;
extern UWORD ED_DiagnosticsScreenActive;
extern char *Global_REF_RASTPORT_1;

extern char *ESQPARS_ReplaceOwnedString(const char *new_value, char *old_value);
extern void DISPLIB_DisplayTextAtPosition(char *rast, LONG x, LONG y, const char *text);

char *ESQPROTO_ParseDigitLabelAndDisplay(const char *in)
{
    const char *p;
    char local[16];
    ULONG i;
    UWORD digit;

    p = in;
    i = 0;
    digit = (UWORD)(UBYTE)*p++;

    WDISP_WeatherStatusDigitChar = digit;
    if (digit < (UWORD)'0' || digit > (UWORD)'9') {
        WDISP_WeatherStatusDigitChar = (UWORD)'0';
    }

    for (;;) {
        char c = *p++;
        local[i] = c;
        if (c == 0x12 || i >= 10) {
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
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 0, 172, WDISP_WeatherStatusTextPtr);
    }

    return WDISP_WeatherStatusTextPtr;
}
