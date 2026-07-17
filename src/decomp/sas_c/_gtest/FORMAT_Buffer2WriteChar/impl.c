#include <exec/types.h>
extern char *Global_FormatBufferPtr2;
extern LONG Global_FormatByteCount2;
LONG __stdargs TESTFN(LONG ch)
{
    char *cursor;
    Global_FormatByteCount2 += 1;
    cursor = Global_FormatBufferPtr2;
    *cursor = (char)ch;
    Global_FormatBufferPtr2 = cursor + 1;
    return ch;
}
