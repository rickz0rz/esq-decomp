#include "esq_types.h"

extern u8 TEXTDISP_PrimaryGroupCode;
extern s16 CLOCK_CurrentDayOfWeekIndex;

s32 TLIBA2_ParseEntryTimeWindow(void *entry, s32 index, s32 *out_pair) __attribute__((noinline));
void TLIBA2_JMPTBL_DST_AddTimeOffset(void *clock_fields, s32 hour_delta, s32 minute_delta) __attribute__((noinline));

s32 TLIBA2_ComputeBroadcastTimeWindow(
    s16 primary_group_code,
    void *entry,
    s32 entry_index,
    s32 slot_index,
    s32 *out_date_fields,
    s32 *out_time_fields) __attribute__((noinline, used));

s32 TLIBA2_ComputeBroadcastTimeWindow(
    s16 primary_group_code,
    void *entry,
    s32 entry_index,
    s32 slot_index,
    s32 *out_date_fields,
    s32 *out_time_fields)
{
    s16 *const now = &CLOCK_CurrentDayOfWeekIndex;
    s16 clock_fields[11];
    s16 minute_delta;
    s16 hour_delta;
    s32 parse_ok;
    s32 parsed_pair[2];
    s32 month_word;
    s32 am_pm_flag;
    s32 i;

    for (i = 0; i < 11; ++i) {
        clock_fields[i] = now[i];
    }

    month_word = (s32)clock_fields[4];
    am_pm_flag = (s32)clock_fields[9];

    if (!((month_word == 12 && am_pm_flag == 0) || (month_word < 5 && am_pm_flag == 0))) {
        if ((slot_index & 1) == 0) {
            minute_delta = 0;
        } else {
            minute_delta = 30;
        }

        {
            s32 v = slot_index - 1;
            if (v < 0) {
                v += 1;
            }
            hour_delta = (s16)((v >> 1) + 5);
        }
    } else if (slot_index > 38) {
        if ((slot_index & 1) == 0) {
            minute_delta = 0;
        } else {
            minute_delta = 30;
        }

        {
            s32 v = slot_index - 39;
            if (v < 0) {
                v += 1;
            }
            hour_delta = (s16)(v >> 1);
        }
    } else {
        if ((slot_index & 1) == 0) {
            minute_delta = 0;
        } else {
            minute_delta = (s16)0xFFE2;
        }

        {
            s32 v = 5 - slot_index;
            if (v < 0) {
                v += 1;
            }
            hour_delta = (s16)(-(v >> 1));
        }
    }

    if ((s32)primary_group_code != (s32)TEXTDISP_PrimaryGroupCode) {
        hour_delta = (s16)(hour_delta + 24);
    }

    clock_fields[4] = 12;
    clock_fields[5] = 0;
    clock_fields[9] = 0;

    TLIBA2_JMPTBL_DST_AddTimeOffset(clock_fields, (s32)hour_delta, (s32)minute_delta);

    out_date_fields[0] = (s32)clock_fields[3];
    out_date_fields[1] = (s32)clock_fields[1];
    out_date_fields[2] = (s32)clock_fields[2];

    out_time_fields[0] = (s32)clock_fields[4];
    out_time_fields[1] = (s32)clock_fields[5];

    if (out_time_fields[0] == 12 && clock_fields[9] == 0) {
        out_time_fields[0] = 0;
    } else if (out_time_fields[0] < 12 && (s16)(clock_fields[9] + 1) == 0) {
        out_time_fields[0] += 12;
    }

    if (entry != (void *)0) {
        parse_ok = TLIBA2_ParseEntryTimeWindow(entry, entry_index, parsed_pair);
    } else {
        parse_ok = 0;
    }

    if (parse_ok != 0 && parsed_pair[1] > out_time_fields[1]) {
        out_time_fields[1] = parsed_pair[1];
    }

    return parse_ok;
}
