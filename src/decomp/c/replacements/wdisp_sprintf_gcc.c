#include "esq_types.h"

/*
 * Target 027 GCC trial function.
 * SPrintf-style formatter to caller buffer.
 */
extern u8 *Global_PrintfBufferPtr;
extern u32 Global_PrintfByteCount;

u32 UNKNOWN10_PrintfPutcToBuffer(u32 ch) __attribute__((noinline));
void WDISP_FormatWithCallback(u32 (*writer)(u32), const u8 *fmt, void *ap) __attribute__((noinline));

u32 WDISP_SPrintf(u8 *out_buf, const u8 *fmt, void *ap) __attribute__((noinline, used));

u32 WDISP_SPrintf(u8 *out_buf, const u8 *fmt, void *ap)
{
    (void)ap;
    Global_PrintfByteCount = 0;
    Global_PrintfBufferPtr = out_buf;

    WDISP_FormatWithCallback(UNKNOWN10_PrintfPutcToBuffer, fmt, &ap);

    *Global_PrintfBufferPtr = 0;
    return Global_PrintfByteCount;
}
