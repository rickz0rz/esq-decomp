#include <exec/types.h>
LONG TLIBA1_ParseStyleCodeChar(UBYTE styleChar)
{
    if (styleChar == 'X') {
        return -1;
    }
    if (styleChar < '1' || styleChar > '7') {
        return 0;
    }
    return (LONG)(styleChar - '0');
}
