#include <exec/types.h>
LONG LADFUNC_GetPackedPenHighNibble(UBYTE packed)
{
    const LONG NIBBLE_MASK = 0x0f;
    LONG out;

    out = (LONG)packed;
    out >>= 4;
    out &= NIBBLE_MASK;
    return out;
}
