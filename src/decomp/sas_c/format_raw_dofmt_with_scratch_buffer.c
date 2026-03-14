#include <exec/types.h>
extern char FORMAT_ScratchBuffer[];
extern LONG FORMAT_FormatToBuffer2(char *outBuf, char *fmt, void *args);
extern void PARALLEL_RawDoFmtStackArgs(char *buffer);

LONG FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...)
{
    void *args = (void *)(&fmt + 1);

    FORMAT_FormatToBuffer2(FORMAT_ScratchBuffer, fmt, args);
    PARALLEL_RawDoFmtStackArgs(FORMAT_ScratchBuffer);
    return 0;
}

void UNKNOWN2A_Stub0(void)
{
}
