#include "esq_types.h"

/*
 * Target 086 GCC trial function.
 * Write a NUL-terminated string through PreallocHandleNode1 buffered stream.
 */
extern s32 Global_PreallocHandleNode1_WriteRemaining;
extern u8 *Global_PreallocHandleNode1_BufferCursor;
extern u8 Global_PreallocHandleNode1;

s32 STREAM_BufferedPutcOrFlush(s32 c, void *node) __attribute__((noinline));
s32 STREAM_BufferedWriteString(u8 *s) __attribute__((noinline, used));

s32 STREAM_BufferedWriteString(u8 *s)
{
    u8 *p = s;
    s32 len;

    while (*p != 0) {
        ++p;
    }
    len = (s32)(p - s);

    for (;;) {
        u8 c = *s++;
        if (c == 0) {
            break;
        }

        Global_PreallocHandleNode1_WriteRemaining -= 1;
        if (Global_PreallocHandleNode1_WriteRemaining < 0) {
            (void)STREAM_BufferedPutcOrFlush((s32)c, (void *)&Global_PreallocHandleNode1);
            continue;
        }

        {
            u8 *dst = Global_PreallocHandleNode1_BufferCursor;
            Global_PreallocHandleNode1_BufferCursor = dst + 1;
            *dst = c;
        }
    }

    (void)STREAM_BufferedPutcOrFlush(-1, (void *)&Global_PreallocHandleNode1);
    return len;
}
