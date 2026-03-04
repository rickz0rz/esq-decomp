typedef signed long LONG;

extern void *Global_REF_BATTCLOCK_RESOURCE;
extern LONG _LVOWriteBattClock(void *battClockBase, LONG seconds);

LONG BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds)
{
    return _LVOWriteBattClock(Global_REF_BATTCLOCK_RESOURCE, seconds);
}
