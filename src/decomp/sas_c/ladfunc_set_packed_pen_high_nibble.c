typedef unsigned char UBYTE;
typedef signed long LONG;

LONG LADFUNC_SetPackedPenHighNibble(UBYTE highNibble, UBYTE lowNibble)
{
    LONG out;

    out = (LONG)highNibble;
    out &= 0x0f;
    out <<= 4;

    out |= ((LONG)lowNibble & 0x0f);
    return out;
}
