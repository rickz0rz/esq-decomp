typedef signed long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
extern LONG _LVODelay(void *dosBase, LONG ticks);

LONG DOS_Delay(LONG ticks)
{
    return _LVODelay(Global_REF_DOS_LIBRARY_2, ticks);
}
