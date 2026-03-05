typedef long LONG;

extern LONG Global_REF_BATTCLOCK_RESOURCE;

LONG _LVOWriteBattClock(LONG seconds);

LONG BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds)
{
    return _LVOWriteBattClock(seconds);
}
