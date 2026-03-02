#include "esq_types.h"

extern u16 Global_WORD_H_VALUE;
extern u16 Global_WORD_T_VALUE;
extern u16 Global_WORD_MAX_VALUE;

s32 PARSEINI_ComputeHTCMaxValues(void) __attribute__((noinline, used));

s32 PARSEINI_ComputeHTCMaxValues(void)
{
    s32 delta = (s32)(u16)Global_WORD_H_VALUE - (s32)(u16)Global_WORD_T_VALUE;
    if (delta < 0) {
        delta += 64000;
    }

    if ((s32)(u16)Global_WORD_MAX_VALUE < delta) {
        Global_WORD_MAX_VALUE = (u16)delta;
    }

    return delta;
}
