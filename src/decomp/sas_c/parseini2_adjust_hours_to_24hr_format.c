#include <exec/types.h>
LONG PARSEINI_AdjustHoursTo24HrFormat(WORD hour, WORD amPmFlag)
{
    WORD result;

    result = hour;
    if (result == 12 && amPmFlag == 0) {
        result = 0;
    } else if (result < 12 && amPmFlag == (WORD)-1) {
        result = (WORD)(result + 12);
    }

    return (LONG)result;
}
