#include "esq_types.h"

typedef struct {
    u32 word0;
    u32 word1;
    u32 word2;
    u32 word3;
    u32 word4;
    u16 word10;
} NEWGRID_ClockScratch;

extern s32 GCOMMAND_MplexClockOffsetMinutes;
s16 NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(void *clock_ptr) __attribute__((noinline));

s32 NEWGRID_ComputeDaySlotFromClockWithOffset(void *clock_ptr) __attribute__((noinline, used));

s32 NEWGRID_ComputeDaySlotFromClockWithOffset(void *clock_ptr)
{
    NEWGRID_ClockScratch scratch;
    s32 slot;
    s32 offset_minutes;
    s32 upper_threshold;
    s32 lower_threshold;
    s32 minute;

    {
        u32 *src32 = (u32 *)clock_ptr;
        u32 *dst32 = (u32 *)&scratch;
        s32 i;

        for (i = 0; i < 5; ++i) {
            dst32[i] = src32[i];
        }
    }
    scratch.word10 = *((u16 *)((u8 *)clock_ptr + 20));

    slot = (u16)NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&scratch);

    offset_minutes = GCOMMAND_MplexClockOffsetMinutes;
    minute = (s16)scratch.word10;

    upper_threshold = 60 - offset_minutes;
    if (minute >= upper_threshold) {
        slot += 1;
        if (slot > 48) {
            slot = 1;
        }
        return slot;
    }

    lower_threshold = 30 - offset_minutes;
    if (minute >= lower_threshold) {
        if (minute <= 29) {
            slot += 1;
            if (slot > 48) {
                slot = 1;
            }
        }
    }

    return slot;
}
