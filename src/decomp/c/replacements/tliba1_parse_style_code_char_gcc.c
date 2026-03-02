#include "esq_types.h"

s32 TLIBA1_ParseStyleCodeChar(u8 style_ch) __attribute__((noinline, used));

s32 TLIBA1_ParseStyleCodeChar(u8 style_ch)
{
    if (style_ch == (u8)'X') {
        return -1;
    }

    if (style_ch < (u8)'1' || style_ch > (u8)'7') {
        return 0;
    }

    return (s32)(style_ch - (u8)'0');
}
