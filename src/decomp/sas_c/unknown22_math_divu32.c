typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

static ULONG swap32(ULONG v)
{
    return (v << 16) | (v >> 16);
}

ULONG MATH_DivU32(ULONG dividend, ULONG divisor)
{
    ULONG d0 = dividend;
    ULONG d1 = divisor;
    ULONG d2;
    ULONG d3;
    UWORD q;
    UWORD r;

    d1 = swap32(d1);
    d2 = (ULONG)(UWORD)d1;
    if ((UWORD)d2 == 0U) {
        d0 = swap32(d0);
        d1 = swap32(d1);
        d2 = swap32(d2);
        d2 = (d2 & 0xffff0000UL) | (ULONG)(UWORD)d0;
        if ((UWORD)d0 != 0U) {
            q = (UWORD)(d2 / (UWORD)d1);
            r = (UWORD)(d2 % (UWORD)d1);
            d2 = ((ULONG)r << 16) | (ULONG)q;
            d0 = (d0 & 0xffff0000UL) | (ULONG)q;
        }

        d0 = swap32(d0);
        d2 = (d2 & 0xffff0000UL) | (ULONG)(UWORD)d0;
        q = (UWORD)(d2 / (UWORD)d1);
        r = (UWORD)(d2 % (UWORD)d1);
        d2 = ((ULONG)r << 16) | (ULONG)q;
        d0 = (d0 & 0xffff0000UL) | (ULONG)q;
        d2 = swap32(d2);
        d1 = (d1 & 0xffff0000UL) | (ULONG)(UWORD)d2;
        return d0;
    }

    d3 = 16U;
    if ((UWORD)d1 < 0x80U) {
        d1 = (d1 << 8) | (d1 >> 24);
        d3 -= 8U;
    }
    if ((UWORD)d1 < 0x800U) {
        d1 = (d1 << 4) | (d1 >> 28);
        d3 -= 4U;
    }
    if ((UWORD)d1 < 0x2000U) {
        d1 = (d1 << 2) | (d1 >> 30);
        d3 -= 2U;
    }
    if (((UWORD)d1 & 0x8000U) == 0U) {
        d1 = (d1 << 1) | (d1 >> 31);
        d3 -= 1U;
    }

    d2 = (ULONG)(UWORD)d0;
    d0 >>= d3;
    d2 = swap32(d2);
    d2 &= 0xffff0000UL;
    d2 >>= d3;
    d3 = swap32(d3);

    q = (UWORD)(d0 / (UWORD)d1);
    r = (UWORD)(d0 % (UWORD)d1);
    d0 = ((ULONG)r << 16) | (ULONG)q;
    d3 = (d3 & 0xffff0000UL) | (ULONG)q;
    d0 = (d0 & 0xffff0000UL) | (ULONG)(UWORD)d2;
    d2 = (d2 & 0xffff0000UL) | (ULONG)(UWORD)d3;
    d1 = swap32(d1);
    d2 = ((ULONG)(UWORD)d2) * (ULONG)(UWORD)d1;
    d0 -= d2;
    if ((d0 & 0x80000000UL) != 0U) {
        d3 -= 1U;
        d0 += d1;
        while ((d0 & 0x80000000UL) != 0U) {
            d0 += d1;
        }
    }

    d1 = (ULONG)(UWORD)d3;
    d3 = swap32(d3);
    d0 = (d0 << (UWORD)d3) | (d0 >> (32U - (UWORD)d3));
    d0 = swap32(d0);

    return d1;
}
