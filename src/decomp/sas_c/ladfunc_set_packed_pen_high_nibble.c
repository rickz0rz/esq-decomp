#include <exec/types.h>
LONG LADFUNC_SetPackedPenHighNibble(UBYTE highNibble, UBYTE lowNibble)
{
    const LONG NIBBLE_MASK = 0x0f;
    LONG out;

    out = (LONG)highNibble;
    out &= NIBBLE_MASK;
    out <<= 4;

    out |= ((LONG)lowNibble & NIBBLE_MASK);
    return out;
}
