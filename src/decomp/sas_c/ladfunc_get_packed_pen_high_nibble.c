typedef unsigned char UBYTE;
typedef signed long LONG;

LONG LADFUNC_GetPackedPenHighNibble(UBYTE packed)
{
    LONG out;

    out = (LONG)packed;
    out >>= 4;
    out &= 0x0f;
    return out;
}
