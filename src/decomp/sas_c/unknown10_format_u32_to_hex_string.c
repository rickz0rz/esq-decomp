typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern const UBYTE kHexDigitTable[];

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
