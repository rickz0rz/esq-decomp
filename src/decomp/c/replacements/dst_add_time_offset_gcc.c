#include "esq_types.h"

/*
 * Target 613 GCC trial function.
 * Add hour/minute offset (in seconds) to normalized datetime struct.
 */
s32 DATETIME_NormalizeStructToSeconds(void *dt) __attribute__((noinline));
void DATETIME_SecondsToStruct(s32 seconds, void *dt) __attribute__((noinline));

void DST_AddTimeOffset(void *dt, s16 hours, s16 minutes) __attribute__((noinline, used));

void DST_AddTimeOffset(void *dt, s16 hours, s16 minutes)
{
    s32 seconds = DATETIME_NormalizeStructToSeconds(dt);
    seconds += (s32)hours * 0x0E10;
    seconds += (s32)minutes * 0x3C;
    DATETIME_SecondsToStruct(seconds, dt);
}
