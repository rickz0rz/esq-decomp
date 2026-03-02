#include "esq_types.h"

/*
 * Target 590 GCC trial function.
 * Copy short 0x12-terminated label into the global wildcard buffer.
 */
extern u8 WDISP_StatusListMatchPattern[];

s32 ESQPROTO_CopyLabelToGlobal(const u8 *in) __attribute__((noinline, used));

s32 ESQPROTO_CopyLabelToGlobal(const u8 *in)
{
    u8 local[16];
    u32 i = 0;

    for (;;) {
        u8 c = *in++;
        local[i] = c;
        if (c == 0x12 || i >= 10u) {
            break;
        }
        i++;
    }

    local[i] = 0;

    {
        const u8 *src = local;
        u8 *dst = WDISP_StatusListMatchPattern;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    }

    return 0;
}
