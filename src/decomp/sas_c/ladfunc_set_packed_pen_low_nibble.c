#include <exec/types.h>
LONG LADFUNC_SetPackedPenLowNibble(UBYTE packed, UBYTE lowNibble)
{
    const LONG NIBBLE_MASK = 0x0f;
    LONG out;

    out = (LONG)packed;
    out &= 0xf0;
    out |= ((LONG)lowNibble & NIBBLE_MASK);
    return out;
}
