extern void *Global_REF_BATTCLOCK_RESOURCE;
#include <exec/types.h>

LONG _LVOReadBattClock(void *base);

LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return _LVOReadBattClock(Global_REF_BATTCLOCK_RESOURCE);
}
