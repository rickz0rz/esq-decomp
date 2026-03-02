#include "esq_types.h"

/*
 * Target 623 GCC trial function.
 * Build a banner time entry using queue snapshot + classification helpers.
 */
typedef struct DST_ClockState {
    u32 l0;
    u32 l4;
    u32 l8;
    u32 l12;
    u32 l16;
    u16 w20;
} DST_ClockState;

typedef struct DST_DateTimeLike {
    u16 w0;
    u16 w2;
    u16 w4;
    u16 w6;
    u16 w8;
    u16 w10;
    u16 w12;
    u16 w14;
    u16 w16;
} DST_DateTimeLike;

extern DST_ClockState CLOCK_DaySlotIndex;
extern s16 WDISP_BannerSlotCursor;
extern s16 CLOCK_CacheYear;
extern u8 ESQ_SecondarySlotModeFlagChar;
extern u8 ESQ_STR_6;
extern u8 CLOCK_FormatVariantCode;
extern void *DST_BannerWindowSecondary;
extern void *DST_BannerWindowPrimary;

s16 DATETIME_IsLeapYear(s32 year) __attribute__((noinline));
s32 GROUP_AG_JMPTBL_MATH_DivS32(s32 a, s32 b) __attribute__((noinline));
u32 GROUP_AG_JMPTBL_MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));
s32 DATETIME_BuildFromBaseDay(void *a, void *b, s32 day, s32 base) __attribute__((noinline));
s16 DATETIME_ClassifyValueInRange(void *window, s32 value) __attribute__((noinline));
void DATETIME_SecondsToStruct(void *out_struct, s32 seconds) __attribute__((noinline));

s32 DST_BuildBannerTimeEntry(s16 lane, u8 slot_hint, s16 *row_out, DST_DateTimeLike *out_dt) __attribute__((noinline, used));

s32 DST_BuildBannerTimeEntry(s16 lane, u8 slot_hint, s16 *row_out, DST_DateTimeLike *out_dt)
{
    DST_ClockState scratch = CLOCK_DaySlotIndex;
    s32 day_of_year = (s32)slot_hint;
    s32 days_in_year;
    s32 seconds;
    s16 class_secondary = 0;
    s16 class_primary;
    s16 row;

    if (WDISP_BannerSlotCursor >= 0x00ff && (s16)slot_hint != WDISP_BannerSlotCursor) {
        day_of_year |= 1;
    }

    if (lane >= 39) {
        day_of_year += 1;
    }

    days_in_year = (DATETIME_IsLeapYear((s32)CLOCK_CacheYear) != 0) ? 366 : 0x16d;
    if (day_of_year > days_in_year) {
        day_of_year -= days_in_year;
    }

    (void)GROUP_AG_JMPTBL_MATH_DivS32((s32)lane - 1, 2);
    (void)GROUP_AG_JMPTBL_MATH_Mulu32(30, (u32)lane);
    (void)GROUP_AG_JMPTBL_MATH_DivS32((((s32)lane - 1) >> 1) + 5, 12);
    (void)GROUP_AG_JMPTBL_MATH_DivS32((((s32)lane - 1) >> 1) + 5, 24);

    seconds = DATETIME_BuildFromBaseDay(&scratch, &scratch, 54, (s32)scratch.w20);

    if (ESQ_SecondarySlotModeFlagChar == 89) {
        class_secondary = DATETIME_ClassifyValueInRange(DST_BannerWindowSecondary, seconds);
    }
    class_primary = DATETIME_ClassifyValueInRange(DST_BannerWindowPrimary, seconds);

    row = (s16)((s32)(u8)ESQ_STR_6 - 54);
    if (class_primary == 1) {
        row -= 1;
    }
    if (class_secondary == 1) {
        row += 1;
    }

    *row_out = row;

    if (out_dt != (DST_DateTimeLike *)0) {
        s32 adjust = (class_primary == 1) ? 1 : 0;
        s32 sec2 = seconds + (s32)GROUP_AG_JMPTBL_MATH_Mulu32((u32)(row + adjust), 0x0e10);
        sec2 += (s32)GROUP_AG_JMPTBL_MATH_Mulu32((u32)(u8)CLOCK_FormatVariantCode, 60);
        DATETIME_SecondsToStruct(out_dt, sec2);
        out_dt->w14 = (u16)class_secondary;
    }

    return (s32)row;
}
