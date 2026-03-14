#include <exec/types.h>
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
