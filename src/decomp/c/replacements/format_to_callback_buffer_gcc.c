#include "esq_types.h"

/*
 * Target 023 GCC trial function.
 * Format via callback and flush terminator.
 */
typedef struct FormatCallbackBuffer FormatCallbackBuffer;

extern u32 Global_FormatCallbackByteCount;
extern FormatCallbackBuffer *Global_FormatCallbackBufferPtr;

u32 FORMAT_CallbackWriteChar(u32 ch) __attribute__((noinline));
void WDISP_FormatWithCallback(u32 (*writer)(u32), const u8 *fmt, void *ap) __attribute__((noinline));
u32 STREAM_BufferedPutcOrFlush(s32 ch, FormatCallbackBuffer *buffer) __attribute__((noinline));

u32 FORMAT_FormatToCallbackBuffer(FormatCallbackBuffer *buffer, const u8 *fmt, void *ap) __attribute__((noinline, used));

u32 FORMAT_FormatToCallbackBuffer(FormatCallbackBuffer *buffer, const u8 *fmt, void *ap)
{
    (void)ap;
    Global_FormatCallbackByteCount = 0;
    Global_FormatCallbackBufferPtr = buffer;

    WDISP_FormatWithCallback(FORMAT_CallbackWriteChar, fmt, &ap);
    STREAM_BufferedPutcOrFlush(-1, buffer);

    return Global_FormatCallbackByteCount;
}
