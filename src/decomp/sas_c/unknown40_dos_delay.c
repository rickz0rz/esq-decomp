typedef long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
#pragma libcall Global_REF_DOS_LIBRARY_2 Delay c6 101
extern LONG Delay(LONG ticks);

LONG DOS_Delay(LONG ticks)
{
    return Delay(ticks);
}
