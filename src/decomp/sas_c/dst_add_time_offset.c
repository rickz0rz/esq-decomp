#include <exec/types.h>
extern LONG DATETIME_NormalizeStructToSeconds(void *dt);
extern void DATETIME_SecondsToStruct(LONG seconds, void *dt);

void DST_AddTimeOffset(void *dt, WORD hours, WORD minutes)
{
    LONG seconds = DATETIME_NormalizeStructToSeconds(dt);
    seconds += (LONG)hours * 0x0E10;
    seconds += (LONG)minutes * 0x3C;
    DATETIME_SecondsToStruct(seconds, dt);
}
