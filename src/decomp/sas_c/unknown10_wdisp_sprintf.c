#include <exec/types.h>
typedef LONG (*WdispOutputFunc)(LONG);

extern LONG Global_PrintfByteCount;
extern UBYTE *Global_PrintfBufferPtr;

extern LONG UNKNOWN10_PrintfPutcToBuffer(LONG ch);
extern void WDISP_FormatWithCallback(WdispOutputFunc outputFunc, const char *formatStr, void *varArgsPtr);

LONG WDISP_SPrintf(char *outBuf, const char *formatStr, ...)
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
