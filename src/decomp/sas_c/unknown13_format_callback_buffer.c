typedef signed long LONG;

typedef struct FormatCallbackBuffer {
    LONG unk0;
    unsigned char *cursor; /* +4 */
    LONG unk8;
    LONG remaining; /* +12 */
} FormatCallbackBuffer;

extern LONG Global_FormatCallbackByteCount;
extern void *Global_FormatCallbackBufferPtr;

extern LONG STREAM_BufferedPutcOrFlush(LONG ch, void *node);
extern void WDISP_FormatWithCallback(void (*cb)(LONG), char *format, void *args);

void FORMAT_CallbackWriteChar(LONG ch)
{
    LONG out;
    FormatCallbackBuffer *buf;

    Global_FormatCallbackByteCount += 1;
    buf = (FormatCallbackBuffer *)Global_FormatCallbackBufferPtr;
    buf->remaining -= 1;

    if (buf->remaining >= 0) {
        unsigned char *p = buf->cursor;
        buf->cursor = p + 1;
        *p = (unsigned char)ch;
        out = (unsigned char)ch;
    } else {
        out = STREAM_BufferedPutcOrFlush((unsigned char)ch, buf);
    }

    (void)out;
}

LONG FORMAT_FormatToCallbackBuffer(void *callbackBuffer, char *format, void *args)
{
    Global_FormatCallbackByteCount = 0;
    Global_FormatCallbackBufferPtr = callbackBuffer;

    WDISP_FormatWithCallback(FORMAT_CallbackWriteChar, format, &args);
    (void)STREAM_BufferedPutcOrFlush(-1, callbackBuffer);

    return Global_FormatCallbackByteCount;
}
