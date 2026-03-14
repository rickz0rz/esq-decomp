#include <exec/types.h>
UBYTE *STRING_AppendAtNull(UBYTE *dst, const UBYTE *src)
{
    UBYTE *ret;

    ret = dst;

    while (*dst != 0) {
        dst++;
    }

    do {
        *dst++ = *src;
    } while (*src++ != 0);

    return ret;
}
