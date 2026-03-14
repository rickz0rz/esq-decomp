#include <exec/types.h>
LONG ESQDISP_TestEntryGridEligibility(const UBYTE *entry, WORD index)
{
    LONG result;

    result = 0;

    if (index > 0) {
        if (index < 49) {
            if (entry != 0) {
                if ((entry[7 + index] & 0x10) != 0) {
                    result = 1;
                } else {
                    if (entry[(WORD)(index - 4)] >= 5) {
                        if (entry[(WORD)(index - 4)] <= 10) {
                            result = 1;
                        }
                    }
                }
            }
        }
    }

    return result;
}
