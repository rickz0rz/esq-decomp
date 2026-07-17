#include <exec/types.h>
extern LONG Global_PrintfByteCount;
extern UBYTE *Global_PrintfBufferPtr;
LONG __stdargs TESTFN(LONG ch)
{
    Global_PrintfByteCount += 1;
    *Global_PrintfBufferPtr++ = (UBYTE)ch;
    return ch;
}
