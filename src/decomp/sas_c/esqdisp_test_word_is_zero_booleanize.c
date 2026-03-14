#include <exec/types.h>
LONG ESQDISP_TestWordIsZeroBooleanize(WORD value)
{
    if (value == 0) {
        return -1;
    }
    return 0;
}
