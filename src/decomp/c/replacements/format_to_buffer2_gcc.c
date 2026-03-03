#include "esq_types.h"

extern u32 Global_FormatByteCount2;
extern u8 *Global_FormatBufferPtr2;

u32 FORMAT_Buffer2WriteChar(u32 ch) __attribute__((noinline));
void WDISP_FormatWithCallback(u32 (*writer)(u32), const u8 *fmt, void *ap) __attribute__((noinline));

u32 FORMAT_FormatToBuffer2(u8 *buffer, const u8 *fmt, void *ap) __attribute__((noinline, used));

u32 FORMAT_FormatToBuffer2(u8 *buffer, const u8 *fmt, void *ap)
{
    (void)ap;
    Global_FormatByteCount2 = 0;
    Global_FormatBufferPtr2 = buffer;

    WDISP_FormatWithCallback(FORMAT_Buffer2WriteChar, fmt, &ap);

    *Global_FormatBufferPtr2 = 0;
    return Global_FormatByteCount2;
}
