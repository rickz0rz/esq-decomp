#include <exec/types.h>

LONG __stdargs TESTFN(UBYTE styleChar)
{
    if (styleChar == 'X') {
        return -1;
    }
    if (styleChar < '1' || styleChar > '7') {
        return 0;
    }
    return (LONG)(styleChar - '0');
}
