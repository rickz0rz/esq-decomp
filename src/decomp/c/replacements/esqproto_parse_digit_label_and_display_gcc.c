#include "esq_types.h"

/*
 * Target 591 GCC trial function.
 * Parse leading digit + label payload, update weather-status globals, redraw when diagnostics are active.
 */
extern u16 WDISP_WeatherStatusDigitChar;
extern u8 WDISP_WeatherStatusLabelBuffer[];
extern u8 *WDISP_WeatherStatusTextPtr;
extern u16 ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;

u8 *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(u8 *new_value, u8 *old_value) __attribute__((noinline));
void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rast, s32 x, s32 y, u8 *text) __attribute__((noinline));

s32 ESQPROTO_ParseDigitLabelAndDisplay(const u8 *in) __attribute__((noinline, used));

s32 ESQPROTO_ParseDigitLabelAndDisplay(const u8 *in)
{
    const u8 *p = in;
    u8 local[16];
    u32 i = 0;
    u16 digit = (u16)(*p++);

    WDISP_WeatherStatusDigitChar = digit;
    if (digit < (u16)'0' || digit > (u16)'9') {
        WDISP_WeatherStatusDigitChar = (u16)'0';
    }

    for (;;) {
        u8 c = *p++;
        local[i] = c;
        if (c == 0x12 || i >= 10u) {
            break;
        }
        i++;
    }

    local[i] = 0;

    {
        const u8 *src = local;
        u8 *dst = WDISP_WeatherStatusLabelBuffer;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    }

    WDISP_WeatherStatusTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((u8 *)p, WDISP_WeatherStatusTextPtr);

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 0, 172, WDISP_WeatherStatusTextPtr);
    }

    return 0;
}
