#include <exec/types.h>

LONG __stdargs TESTFN(const UBYTE *base, ULONG bitIndex)
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

void ESQ_SetBit1Based(UBYTE *base, ULONG bitIndex)
{
    ULONG n;
    ULONG bitOffset;
    UWORD byteOffset;

    n = bitIndex - 1;
    bitOffset = n & 7;
    byteOffset = (UWORD)n;
    byteOffset >>= 3;

    base[byteOffset] = (UBYTE)(base[byteOffset] | (UBYTE)(1UL << bitOffset));
}
