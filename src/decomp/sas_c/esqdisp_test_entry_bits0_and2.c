#include <exec/types.h>
LONG ESQDISP_TestEntryBits0And2_Core(const UBYTE *entry)
{
    if (entry == 0) {
        return 0;
    }

    if ((entry[40] & 1) == 0) {
        return 0;
    }

    if ((entry[40] & 4) == 0) {
        return 0;
    }

    return 1;
}

LONG ESQDISP_TestEntryBits0And2(const UBYTE *entry)
{
    return ESQDISP_TestEntryBits0And2_Core(entry);
}
