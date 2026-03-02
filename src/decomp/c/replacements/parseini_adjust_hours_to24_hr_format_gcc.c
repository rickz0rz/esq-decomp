#include "esq_types.h"

s32 PARSEINI_AdjustHoursTo24HrFormat(s32 hour, s32 ampm_flag) __attribute__((noinline, used));

s32 PARSEINI_AdjustHoursTo24HrFormat(s32 hour, s32 ampm_flag)
{
    s32 h = (s16)hour;
    s32 ap = (s16)ampm_flag;

    if (h == 12 && ap == 0) {
        h = 0;
    } else if (h < 12 && ap == -1) {
        h += 12;
    }

    return h;
}
