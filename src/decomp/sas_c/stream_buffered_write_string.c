#include <exec/types.h>
extern LONG Global_PreallocHandleNode1_WriteRemaining;
extern UBYTE *Global_PreallocHandleNode1_BufferCursor;
extern UBYTE Global_PreallocHandleNode1;

extern LONG STREAM_BufferedPutcOrFlush(LONG ch, void *node);

LONG STREAM_BufferedWriteString(UBYTE *s)
{
    UBYTE *p;
    LONG len;

    p = s;
    while (*p != 0) {
        p++;
    }

    len = (LONG)(p - s);

    for (;;) {
        UBYTE ch;

        ch = *s++;
        if (ch == 0) {
            break;
        }

        Global_PreallocHandleNode1_WriteRemaining -= 1;
        if (Global_PreallocHandleNode1_WriteRemaining < 0) {
            (void)STREAM_BufferedPutcOrFlush((LONG)ch, (void *)&Global_PreallocHandleNode1);
            continue;
        }

        *Global_PreallocHandleNode1_BufferCursor++ = ch;
    }

    (void)STREAM_BufferedPutcOrFlush(-1, (void *)&Global_PreallocHandleNode1);
    return len;
}
