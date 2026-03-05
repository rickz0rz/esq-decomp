typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern UWORD WDISP_WeatherStatusDigitChar;
extern UBYTE WDISP_WeatherStatusLabelBuffer[];
extern UBYTE *WDISP_WeatherStatusTextPtr;
extern UWORD ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;

extern UBYTE *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(UBYTE *new_value, UBYTE *old_value);
extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rast, LONG x, LONG y, UBYTE *text);

UBYTE *ESQPROTO_ParseDigitLabelAndDisplay(const UBYTE *in)
{
    const UBYTE *p = in;
    UBYTE local[16];
    ULONG i = 0;
    UWORD digit = (UWORD)(*p++);

    WDISP_WeatherStatusDigitChar = digit;
    if (digit < (UWORD)'0' || digit > (UWORD)'9') {
        WDISP_WeatherStatusDigitChar = (UWORD)'0';
    }

    for (;;) {
        UBYTE c = *p++;
        local[i] = c;
        if (c == 0x12 || i >= 10UL) {
            break;
        }
        i++;
    }

    local[i] = 0;

    {
        const UBYTE *src = local;
        UBYTE *dst = WDISP_WeatherStatusLabelBuffer;
        while ((*dst++ = *src++) != 0) {
        }
    }

    WDISP_WeatherStatusTextPtr =
        ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((UBYTE *)p, WDISP_WeatherStatusTextPtr);

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, 0, 172, WDISP_WeatherStatusTextPtr);
    }

    return WDISP_WeatherStatusTextPtr;
}
