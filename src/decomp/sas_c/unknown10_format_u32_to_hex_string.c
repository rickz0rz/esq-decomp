#include <exec/types.h>
extern const char kHexDigitTable[];

ULONG FORMAT_U32ToHexString(UBYTE *dst, ULONG value)
{
    UBYTE temp[12];
    UBYTE *p = temp;
    ULONG len;

    do {
        ULONG nibble = value & 15UL;
        *p++ = kHexDigitTable[nibble];
        value >>= 4;
    } while (value != 0);

    len = (ULONG)(p - temp);
    while (p != temp) {
        *dst++ = *--p;
    }
    *dst = 0;
    return len;
}
