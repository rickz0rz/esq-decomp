#include <exec/types.h>

LONG _LVOReadBattClock(void);

LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return _LVOReadBattClock();
}
