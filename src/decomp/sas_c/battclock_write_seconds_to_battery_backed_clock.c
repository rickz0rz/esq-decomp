#include <exec/types.h>

LONG _LVOWriteBattClock(LONG seconds);

LONG BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds)
{
    return _LVOWriteBattClock(seconds);
}
