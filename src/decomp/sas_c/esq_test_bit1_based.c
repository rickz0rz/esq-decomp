typedef unsigned long ULONG;
typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

LONG ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex)
{
    ULONG n;
    ULONG bitOffset;
    UWORD byteOffset;

    n = bitIndex - 1;
    bitOffset = n & 7;
    byteOffset = (UWORD)n;
    byteOffset >>= 3;

    if ((base[byteOffset] & (UBYTE)(1UL << bitOffset)) != 0) {
        return -1;
    }

    return 0;
}
