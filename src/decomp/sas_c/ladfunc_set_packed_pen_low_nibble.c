typedef unsigned char UBYTE;
typedef signed long LONG;

LONG LADFUNC_SetPackedPenLowNibble(UBYTE packed, UBYTE lowNibble)
{
    LONG out;

    out = (LONG)packed;
    out &= 0xf0;
    out |= ((LONG)lowNibble & 0x0f);
    return out;
}
