#include "esq_types.h"

typedef struct {
    u32 word0;
    u32 word1;
    u32 word2;
    u32 word3;
    u32 word4;
    u16 word10;
} NEWGRID_ClockScratch;

extern u8 CLOCK_FormatVariantCode;

s32 NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(void *clock_ptr) __attribute__((noinline));
s32 NEWGRID_JMPTBL_MATH_DivS32(s32 a, s32 b) __attribute__((noinline));
u32 NEWGRID_JMPTBL_MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));
void NEWGRID_JMPTBL_DATETIME_SecondsToStruct(s32 seconds, void *clock_ptr) __attribute__((noinline));
s32 NEWGRID_ComputeDaySlotFromClockWithOffset(void *clock_ptr) __attribute__((noinline));

s32 NEWGRID_AdjustClockStringBySlotWithOffset(void *clock_ptr) __attribute__((noinline, used));

s32 NEWGRID_AdjustClockStringBySlotWithOffset(void *clock_ptr)
{
    NEWGRID_ClockScratch scratch;
    s32 seconds;
    s32 slot_div;

    {
        u8 *src = (u8 *)clock_ptr;
        u8 *dst = (u8 *)&scratch;
        s32 i;

        for (i = 0; i < 22; ++i) {
            dst[i] = src[i];
        }
    }

    seconds = NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(&scratch);
    slot_div = NEWGRID_JMPTBL_MATH_DivS32((s32)(u8)CLOCK_FormatVariantCode, 30);
    seconds -= (s32)NEWGRID_JMPTBL_MATH_Mulu32(60, (u32)slot_div);

    NEWGRID_JMPTBL_DATETIME_SecondsToStruct(seconds, &scratch);
    return NEWGRID_ComputeDaySlotFromClockWithOffset(&scratch);
}
