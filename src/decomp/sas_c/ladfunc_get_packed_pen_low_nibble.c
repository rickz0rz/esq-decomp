#include <exec/types.h>
LONG LADFUNC_GetPackedPenLowNibble(UBYTE packed)
{
    const LONG NIBBLE_MASK = 0x0f;
    LONG out;

    out = (LONG)packed;
    out &= NIBBLE_MASK;
    return out;
}
