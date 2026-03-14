#include <exec/types.h>
ULONG STRING_ToUpperChar(ULONG c)
{
    UBYTE ch = (UBYTE)c;

    if (ch >= 'a' && ch <= 'z') {
        ch = (UBYTE)(ch - 0x20);
    }

    return (ULONG)ch;
}
