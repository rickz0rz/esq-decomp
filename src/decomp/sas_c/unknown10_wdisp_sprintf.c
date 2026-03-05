typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG Global_PrintfByteCount;
extern UBYTE *Global_PrintfBufferPtr;

extern void UNKNOWN10_PrintfPutcToBuffer(LONG ch);
extern void WDISP_FormatWithCallback(void (*outputFunc)(LONG), char *formatStr, void *varArgsPtr);

LONG WDISP_SPrintf(char *outBuf, char *formatStr, ...)
{
    Global_PrintfByteCount = 0;
    Global_PrintfBufferPtr = (UBYTE *)outBuf;

    WDISP_FormatWithCallback(
        UNKNOWN10_PrintfPutcToBuffer,
        formatStr,
        (void *)(&formatStr + 1)
    );

    *Global_PrintfBufferPtr = 0;
    return Global_PrintfByteCount;
}
