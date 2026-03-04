typedef signed long LONG;

extern void *Global_REF_BATTCLOCK_RESOURCE;
extern LONG _LVOReadBattClock(void *battClockBase);

LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return _LVOReadBattClock(Global_REF_BATTCLOCK_RESOURCE);
}
