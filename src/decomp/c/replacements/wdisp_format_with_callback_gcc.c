#include "esq_types.h"

/*
 * Target 598 GCC trial function.
 * Core callback-based formatter loop used by WDISP_SPrintf.
 */
typedef void (*WdispOutputFunc)(u32 ch);

u8 *FORMAT_ParseFormatSpec(const u8 *fmt, u32 **varargs_ptr, WdispOutputFunc out_fn) __attribute__((noinline));

s32 WDISP_FormatWithCallback(WdispOutputFunc out_fn, const u8 *fmt, u32 *varargs_ptr)
    __attribute__((noinline, used));

s32 WDISP_FormatWithCallback(WdispOutputFunc out_fn, const u8 *fmt, u32 *varargs_ptr)
{
    u32 *argp = varargs_ptr;
    const u8 *p = fmt;

    for (;;) {
        u8 ch = *p++;

        if (ch == 0) {
            return 0;
        }

        if (ch == (u8)'%') {
            if (*p == (u8)'%') {
                p++;
            } else {
                u8 *next = FORMAT_ParseFormatSpec(p, &argp, out_fn);
                if (next != 0) {
                    p = next;
                    continue;
                }
            }
        }

        out_fn((u32)ch);
    }
}
