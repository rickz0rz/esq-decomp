typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

typedef struct DST_ClockState {
    ULONG l0;
    ULONG l4;
    ULONG l8;
    ULONG l12;
    ULONG l16;
    UWORD w20;
} DST_ClockState;

typedef struct DST_DateTimeLike {
    UWORD w0;
    UWORD w2;
    UWORD w4;
    UWORD w6;
    UWORD w8;
    UWORD w10;
    UWORD w12;
    UWORD w14;
    UWORD w16;
} DST_DateTimeLike;

extern DST_ClockState CLOCK_DaySlotIndex;
extern WORD WDISP_BannerSlotCursor;
extern WORD CLOCK_CacheYear;
extern UBYTE ESQ_SecondarySlotModeFlagChar;
extern UBYTE ESQ_STR_6;
extern UBYTE CLOCK_FormatVariantCode;
extern void *DST_BannerWindowSecondary;
extern void *DST_BannerWindowPrimary;

extern LONG DATETIME_IsLeapYear(LONG year);
extern LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern ULONG GROUP_AG_JMPTBL_MATH_Mulu32(ULONG a, ULONG b);
extern LONG DATETIME_BuildFromBaseDay(void *a, void *b, LONG day, LONG base);
extern WORD DATETIME_ClassifyValueInRange(void *window, LONG value);
extern void DATETIME_SecondsToStruct(void *out_struct, LONG seconds);

LONG DST_BuildBannerTimeEntry(WORD lane, UBYTE slot_hint, WORD *row_out, DST_DateTimeLike *out_dt)
{
    const WORD BANNER_SLOT_CURSOR_NONE = 0x00ff;
    const WORD LANE_DAY_INCREMENT_START = 39;
    const LONG DAYS_IN_LEAP_YEAR = 366;
    const LONG DAYS_IN_COMMON_YEAR = 365;
    const LONG BASE_DAY_INDEX = 54;
    const UBYTE SECONDARY_SLOT_MODE_ENABLED = 89;
    const LONG ROW_SECONDS_STEP = 0x0e10;
    const LONG FORMAT_VARIANT_SECONDS_STEP = 60;
    DST_ClockState scratch = CLOCK_DaySlotIndex;
    LONG day_of_year = (LONG)slot_hint;
    LONG days_in_year;
    LONG seconds;
    WORD class_secondary = 0;
    WORD class_primary;
    WORD row;

    if (WDISP_BannerSlotCursor >= BANNER_SLOT_CURSOR_NONE && (WORD)slot_hint != WDISP_BannerSlotCursor) {
        day_of_year |= 1;
    }

    if (lane >= LANE_DAY_INCREMENT_START) {
        day_of_year += 1;
    }

    days_in_year = (DATETIME_IsLeapYear((LONG)CLOCK_CacheYear) != 0) ? DAYS_IN_LEAP_YEAR : DAYS_IN_COMMON_YEAR;
    if (day_of_year > days_in_year) {
        day_of_year -= days_in_year;
    }

    (void)GROUP_AG_JMPTBL_MATH_DivS32((LONG)lane - 1, 2);
    (void)GROUP_AG_JMPTBL_MATH_Mulu32(30, (ULONG)lane);
    (void)GROUP_AG_JMPTBL_MATH_DivS32((((LONG)lane - 1) >> 1) + 5, 12);
    (void)GROUP_AG_JMPTBL_MATH_DivS32((((LONG)lane - 1) >> 1) + 5, 24);

    seconds = DATETIME_BuildFromBaseDay(&scratch, &scratch, BASE_DAY_INDEX, (LONG)scratch.w20);

    if (ESQ_SecondarySlotModeFlagChar == SECONDARY_SLOT_MODE_ENABLED) {
        class_secondary = DATETIME_ClassifyValueInRange(DST_BannerWindowSecondary, seconds);
    }
    class_primary = DATETIME_ClassifyValueInRange(DST_BannerWindowPrimary, seconds);

    row = (WORD)((LONG)(UBYTE)ESQ_STR_6 - BASE_DAY_INDEX);
    if (class_primary == 1) {
        row -= 1;
    }
    if (class_secondary == 1) {
        row += 1;
    }

    *row_out = row;

    if (out_dt != (DST_DateTimeLike *)0) {
        LONG adjust = (class_primary == 1) ? 1 : 0;
        LONG sec2 = seconds + (LONG)GROUP_AG_JMPTBL_MATH_Mulu32((ULONG)(row + adjust), ROW_SECONDS_STEP);
        sec2 += (LONG)GROUP_AG_JMPTBL_MATH_Mulu32((ULONG)(UBYTE)CLOCK_FormatVariantCode, FORMAT_VARIANT_SECONDS_STEP);
        DATETIME_SecondsToStruct(out_dt, sec2);
        out_dt->w14 = (UWORD)class_secondary;
    }

    return (LONG)row;
}
