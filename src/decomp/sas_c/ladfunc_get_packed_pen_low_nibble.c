typedef unsigned char UBYTE;
typedef signed long LONG;

LONG LADFUNC_GetPackedPenLowNibble(UBYTE packed)
{
    LONG out;

    out = (LONG)packed;
    out &= 0x0f;
    return out;
}
