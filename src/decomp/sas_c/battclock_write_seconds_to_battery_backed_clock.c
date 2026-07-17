extern void *Global_REF_BATTCLOCK_RESOURCE;
#include <exec/types.h>

LONG _LVOWriteBattClock(void *base, LONG seconds);

LONG BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds)
{
    return _LVOWriteBattClock(Global_REF_BATTCLOCK_RESOURCE, seconds);
}
