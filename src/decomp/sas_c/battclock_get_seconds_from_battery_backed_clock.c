typedef long LONG;

extern LONG Global_REF_BATTCLOCK_RESOURCE;

LONG _LVOReadBattClock(void);

LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return _LVOReadBattClock();
}
