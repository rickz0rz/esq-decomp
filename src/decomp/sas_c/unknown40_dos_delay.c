typedef long LONG;

LONG _LVODelay(LONG ticks);

LONG DOS_Delay(LONG ticks)
{
    return _LVODelay(ticks);
}
