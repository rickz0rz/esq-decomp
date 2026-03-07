typedef long LONG;

LONG _LVOReadBattClock(void);

LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return _LVOReadBattClock();
}
