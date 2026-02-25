#include "esq_types.h"

/*
 * Target 022 GCC trial function.
 * Callback writer used by formatter pipeline.
 */
typedef struct FormatCallbackBuffer {
    u32 unk0;
    u8 *write_ptr;    /* +4 */
    u32 unk8;
    s32 bytes_left;   /* +12 */
} FormatCallbackBuffer;

extern u32 Global_FormatCallbackByteCount;
extern FormatCallbackBuffer *Global_FormatCallbackBufferPtr;
u32 STREAM_BufferedPutcOrFlush(u32 ch, FormatCallbackBuffer *buffer) __attribute__((noinline));

u32 FORMAT_CallbackWriteChar(u32 ch) __attribute__((noinline, used));

u32 FORMAT_CallbackWriteChar(u32 ch)
{
    Global_FormatCallbackByteCount += 1;

    FormatCallbackBuffer *buffer = Global_FormatCallbackBufferPtr;
    buffer->bytes_left -= 1;
    if (buffer->bytes_left < 0) {
        return STREAM_BufferedPutcOrFlush((u8)ch, buffer);
    }

    u8 *p = buffer->write_ptr;
    buffer->write_ptr = p + 1;
    *p = (u8)ch;
    return (u8)ch;
}
