#include "esq_types.h"

extern u8 ESQFUNC_BasePaletteRgbTriples[];
extern u8 KYBD_CustomPaletteTriplesRBase[];
extern const char Global_STR_COLOR_PERCENT_D[];

s32 PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...) __attribute__((noinline));
s32 PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b) __attribute__((noinline));
s32 SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(s32 ch) __attribute__((noinline));
void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void) __attribute__((noinline));

s32 PARSEINI_ParseColorTable(const char *key, const char *value, s32 mode) __attribute__((noinline, used));

s32 PARSEINI_ParseColorTable(const char *key, const char *value, s32 mode)
{
    u8 *table = 0;
    s32 limit = 0;
    s32 color_index;
    char temp[112];

    if (mode == 4) {
        table = KYBD_CustomPaletteTriplesRBase;
        limit = 8;
    } else if (mode == 5) {
        table = ESQFUNC_BasePaletteRgbTriples;
        limit = 8;
    }

    for (color_index = 0; color_index < limit; color_index++) {
        s32 channel;

        PARSEINI_JMPTBL_WDISP_SPrintf(temp, Global_STR_COLOR_PERCENT_D, color_index);
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, temp) != 0) {
            continue;
        }

        for (channel = 0; channel < 3; channel++) {
            s32 dst = (color_index * 3) + channel;
            u8 ch = (u8)value[channel];
            table[dst] = (u8)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit((s32)ch);
        }
    }

    if (mode == 4) {
        TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
    }

    return 0;
}
