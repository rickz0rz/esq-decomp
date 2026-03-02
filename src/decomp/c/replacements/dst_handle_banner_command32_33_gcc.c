#include "esq_types.h"

/*
 * Target 619 GCC trial function.
 * Parse cmd $32/$33 banner payload into secondary/primary windows, then refresh queue.
 */
extern void *DST_BannerWindowPrimary;
extern void *DST_BannerWindowSecondary;

void DATETIME_ParseString(void *out_struct, const char *text, s32 width) __attribute__((noinline));
void DATETIME_CopyPairAndRecalc(void *dst, const void *lhs, const void *rhs) __attribute__((noinline));
void DST_UpdateBannerQueue(void *pair) __attribute__((noinline));

void DST_HandleBannerCommand32_33(u8 cmd, const char *text) __attribute__((noinline, used));

void DST_HandleBannerCommand32_33(u8 cmd, const char *text)
{
    u8 parsed_a[22];
    u8 parsed_b[22];

    if (cmd == 0x32) {
        DATETIME_ParseString(parsed_a, text, 4);
        DATETIME_ParseString(parsed_b, text, 19);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowSecondary, parsed_a, parsed_b);
    } else if (cmd == 0x33) {
        DATETIME_ParseString(parsed_a, text, 4);
        DATETIME_ParseString(parsed_b, text, 19);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowPrimary, parsed_a, parsed_b);
    }

    DST_UpdateBannerQueue(&DST_BannerWindowPrimary);
}
