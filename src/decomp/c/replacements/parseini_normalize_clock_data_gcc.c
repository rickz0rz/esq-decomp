#include "esq_types.h"

s32 PARSEINI2_JMPTBL_DATETIME_IsLeapYear(s32 year) __attribute__((noinline));
s32 PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(void *clock_data) __attribute__((noinline));

static u16 read_u16(const void *p, s32 off)
{
    return *(const u16 *)((const u8 *)p + off);
}

static void write_u16(void *p, s32 off, u16 v)
{
    *(u16 *)((u8 *)p + off) = v;
}

s32 PARSEINI_NormalizeClockData(void *dst, const void *src) __attribute__((noinline, used));

s32 PARSEINI_NormalizeClockData(void *dst, const void *src)
{
    s32 i;
    s16 year;
    s16 month;

    for (i = 0; i < 5; i++) {
        ((u32 *)dst)[i] = ((const u32 *)src)[i];
    }
    write_u16(dst, 20, read_u16(src, 20));

    year = (s16)read_u16(dst, 6);
    if (year < 1900) {
        year = (s16)(year + 1900);
        write_u16(dst, 6, (u16)year);
    }

    month = (s16)read_u16(dst, 8);
    if (month >= 12) {
        write_u16(dst, 18, (u16)-1);
    } else {
        write_u16(dst, 18, 0);
    }

    if (read_u16(dst, 8) == 0) {
        write_u16(dst, 8, 12);
    }
    if ((s16)read_u16(dst, 8) > 12) {
        write_u16(dst, 8, (u16)((s16)read_u16(dst, 8) - 12));
    }

    write_u16(dst, 4, (u16)((s16)read_u16(dst, 4) + 1));

    if (PARSEINI2_JMPTBL_DATETIME_IsLeapYear((s32)(s16)read_u16(dst, 6)) != 0) {
        write_u16(dst, 20, (u16)-1);
    } else {
        write_u16(dst, 20, 0);
    }

    return PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(dst);
}
