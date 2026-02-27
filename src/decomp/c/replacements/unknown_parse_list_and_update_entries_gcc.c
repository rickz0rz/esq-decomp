#include "esq_types.h"

/*
 * Target 084 GCC trial function.
 * Parse status-list payload and update day-entry table rows.
 */
extern u8 WDISP_StatusListMatchPattern[];
extern u16 CLOCK_CurrentDayOfYear;
extern u16 CLOCK_CurrentYearValue;
extern u8 TLIBA1_DayEntryModeCounter;
extern u8 WDISP_StatusDayEntry0[];

s32 UNKNOWN_JMPTBL_ESQ_WildcardMatch(const u8 *pattern, const u8 *text) __attribute__((noinline));
s32 UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(s32 day, s32 year) __attribute__((noinline));
u8 *STRING_CopyPadNul(u8 *dst, const u8 *src, u32 max_len) __attribute__((noinline));
s32 PARSE_ReadSignedLongSkipClass3_Alt(const u8 *in) __attribute__((noinline));
u32 MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));

static void copy_label_0x12(const u8 **pp, u8 *dst)
{
    u32 i = 0;

    for (;;) {
        u8 c = *(*pp)++;
        dst[i] = c;
        if (c == 0x12 || i >= 10u) {
            break;
        }
        i++;
    }

    dst[i] = 0;
}

static s32 *status_entry_ptr(u32 index)
{
    u32 off = MATH_Mulu32(index, 20u);
    return (s32 *)(WDISP_StatusDayEntry0 + off);
}

s32 UNKNOWN_ParseListAndUpdateEntries(const u8 *in) __attribute__((noinline, used));

s32 UNKNOWN_ParseListAndUpdateEntries(const u8 *in)
{
    const u8 *p = in;
    u8 list_name[16];
    u8 field_buf[8];
    u32 i;
    u8 marker;

    copy_label_0x12(&p, list_name);
    if (list_name[0] == 0) {
        return 0;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(WDISP_StatusListMatchPattern, list_name) != 0) {
        return 0;
    }

    for (i = 0; i < 4u; ++i) {
        s32 *entry = status_entry_ptr(i);
        s32 day = (s32)((u16)(CLOCK_CurrentDayOfYear + (u16)i + 1u));
        s32 year = (s32)CLOCK_CurrentYearValue;

        entry[4] = 1;
        entry[0] = UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(day, year);
    }

    TLIBA1_DayEntryModeCounter = *p++;
    marker = *p++;

    while (marker == (u8)'+') {
        s32 key;
        s32 found = -1;
        s32 idx;

        STRING_CopyPadNul(field_buf, p, 3u);
        field_buf[3] = 0;
        key = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
        p += 3;

        for (idx = 0; idx <= 4; ++idx) {
            s32 *entry = status_entry_ptr((u32)idx);
            if (entry[0] == key) {
                found = idx;
                break;
            }
        }

        if (found < 0 || found > 3) {
            marker = 0;
        }

        if (marker == (u8)'+') {
            s32 *entry = status_entry_ptr((u32)found);

            entry[4] = 0;

            STRING_CopyPadNul(field_buf, p, 1u);
            field_buf[1] = 0;
            if (field_buf[0] == (u8)'?') {
                entry[1] = 1;
            } else {
                entry[1] = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
            }

            p += 1;
            STRING_CopyPadNul(field_buf, p, 3u);
            field_buf[3] = 0;
            if (field_buf[0] == (u8)'?') {
                entry[2] = -999;
            } else {
                entry[2] = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
            }

            p += 3;
            STRING_CopyPadNul(field_buf, p, 3u);
            field_buf[3] = 0;
            if (field_buf[0] == (u8)'?') {
                entry[3] = -999;
            } else {
                entry[3] = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
            }

            p += 3;
            marker = *p++;
        } else {
            p += 7;
            marker = *p++;
        }
    }

    return 0;
}
