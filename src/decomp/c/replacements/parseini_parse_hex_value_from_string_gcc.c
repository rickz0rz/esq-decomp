#include "esq_types.h"

extern u8 WDISP_CharClassTable[];

s32 SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(s32 ch) __attribute__((noinline));

s32 PARSEINI_ParseHexValueFromString(const char *p) __attribute__((noinline, used));

s32 PARSEINI_ParseHexValueFromString(const char *p)
{
    u32 value = 0;

    while (p != 0) {
        u32 ch = (u8)*p;
        if ((WDISP_CharClassTable[ch] & (1u << 7)) == 0) {
            break;
        }

        value <<= 4;
        value += (u8)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit((s32)ch);
        p++;
    }

    return (s32)value;
}
