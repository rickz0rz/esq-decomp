typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern UWORD WDISP_WeatherStatusDigitChar;
extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusTextPtr;
extern UWORD ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;

extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *new_value, char *old_value);
extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rast, LONG x, LONG y, char *text);

char *ESQPROTO_ParseDigitLabelAndDisplay(const char *in)
{
    const char *p = in;
    char local[16];
    ULONG i = 0;
    UWORD digit = (UWORD)(*p++);

    WDISP_WeatherStatusDigitChar = digit;
    if (digit < (UWORD)'0' || digit > (UWORD)'9') {
        WDISP_WeatherStatusDigitChar = (UWORD)'0';
    }

    for (;;) {
        char c = *p++;
        local[i] = c;
        if (c == 0x12 || i >= 10UL) {
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
        ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((char *)p, WDISP_WeatherStatusTextPtr);

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, 0, 172, WDISP_WeatherStatusTextPtr);
    }

    return WDISP_WeatherStatusTextPtr;
}
