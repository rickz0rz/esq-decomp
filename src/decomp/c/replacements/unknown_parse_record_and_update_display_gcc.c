#include "esq_types.h"

/*
 * Target 592 GCC trial function.
 * Parse one weather-status record, update globals, and redraw when diagnostics are active.
 */
extern u8 WDISP_WeatherStatusLabelBuffer[];
extern u8 *WDISP_WeatherStatusOverlayTextPtr;
extern u8 WDISP_WeatherStatusCountdown;
extern u8 WDISP_WeatherStatusColorCode;
extern u8 WDISP_WeatherStatusBrushIndex;
extern u16 ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;

s32 UNKNOWN_JMPTBL_ESQ_WildcardMatch(const u8 *pattern, const u8 *text) __attribute__((noinline));
u8 *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(u8 *new_value, u8 *old_value) __attribute__((noinline));
void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rast, s32 x, s32 y, u8 *text) __attribute__((noinline));

s32 UNKNOWN_ParseRecordAndUpdateDisplay(const u8 *in) __attribute__((noinline, used));

s32 UNKNOWN_ParseRecordAndUpdateDisplay(const u8 *in)
{
    const u8 *p = in;
    u8 local[16];
    u8 countdown = *p++;
    u8 color = *p++;
    u8 brush = *p++;
    u32 i = 0;

    p += 1;

    if (brush < 2u || brush > 6u) {
        brush = 1;
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
    if (local[0] == 0) {
        return 0;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(WDISP_WeatherStatusLabelBuffer, local) != 0) {
        return 0;
    }

    WDISP_WeatherStatusOverlayTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((u8 *)p, WDISP_WeatherStatusOverlayTextPtr);
    WDISP_WeatherStatusCountdown = countdown;
    WDISP_WeatherStatusColorCode = color;
    WDISP_WeatherStatusBrushIndex = brush;

    if (ED_DiagnosticsScreenActive != 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1,
            0,
            172,
            WDISP_WeatherStatusOverlayTextPtr
        );
    }

    return 0;
}
