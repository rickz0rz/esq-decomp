#include <exec/types.h>

enum {
    NIBBLE_MASK = 0x0f,
    HIGH_NIBBLE_SHIFT = 4
};

LONG __stdargs TESTFN(UBYTE highNibble, UBYTE lowNibble)
{
    LONG out;

    out = (LONG)highNibble;
    out &= NIBBLE_MASK;
    out <<= HIGH_NIBBLE_SHIFT;

    out |= ((LONG)lowNibble & NIBBLE_MASK);
    return out;
}
