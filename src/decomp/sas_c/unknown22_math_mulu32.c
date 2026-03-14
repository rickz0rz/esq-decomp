#include <exec/types.h>
ULONG MATH_Mulu32(ULONG a, ULONG b)
{
    ULONG d0 = a;
    ULONG d1 = b;
    ULONG d2 = d0;
    ULONG d3 = d1;
    UWORD low;

    d2 = (d2 << 16) | (d2 >> 16);
    d3 = (d3 << 16) | (d3 >> 16);
    d2 = (ULONG)((UWORD)d1) * (ULONG)((UWORD)d2);
    d3 = (ULONG)((UWORD)d0) * (ULONG)((UWORD)d3);
    d0 = (ULONG)((UWORD)d1) * (ULONG)((UWORD)d0);

    low = (UWORD)d2;
    low = (UWORD)(low + (UWORD)d3);
    d2 = (d2 & 0xffff0000UL) | (ULONG)low;

    d2 = (d2 << 16) | (d2 >> 16);
    d2 &= 0xffff0000UL;
    d0 += d2;

    return d0;
}
