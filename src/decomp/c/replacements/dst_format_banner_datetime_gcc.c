#include "esq_types.h"

/*
 * Target 620 GCC trial function.
 * Format banner date/time text from a small calendar struct and string tables.
 */
typedef struct DST_BannerTimeInfo {
    s16 day_of_week_index;
    s16 month_index;
    s16 day_number;
    s16 year_short;
    s16 day_of_year;
    s16 hour;
    s16 minute;
    s16 dst_mode_flag;
    s16 second;
    s16 ampm_flag;
    s16 leap_year_flag;
} DST_BannerTimeInfo;

extern const char *Global_JMPTBL_SHORT_DAYS_OF_WEEK[];
extern const char *Global_JMPTBL_SHORT_MONTHS[];
extern u8 DST_TAG_AM[];
extern u8 DST_TAG_PM[];
extern u8 DST_TAG_STD[];
extern u8 DST_TAG_DST[];
extern u8 DST_STR_NORM_YEAR[];
extern u8 DST_STR_LEAP_YEAR[];
extern u8 DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_[];

void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...) __attribute__((noinline));

void DST_FormatBannerDateTime(char *dst, const DST_BannerTimeInfo *info) __attribute__((noinline, used));

void DST_FormatBannerDateTime(char *dst, const DST_BannerTimeInfo *info)
{
    const char *dow = Global_JMPTBL_SHORT_DAYS_OF_WEEK[(u16)info->day_of_week_index];
    const char *mon = Global_JMPTBL_SHORT_MONTHS[(u16)info->month_index];
    const char *ampm = (info->ampm_flag != 0) ? (const char *)DST_TAG_PM : (const char *)DST_TAG_AM;
    const char *dst_tag = (info->dst_mode_flag == 1) ? (const char *)DST_TAG_DST : (const char *)DST_TAG_STD;
    const char *year_tag = (info->leap_year_flag != 0) ? (const char *)DST_STR_LEAP_YEAR : (const char *)DST_STR_NORM_YEAR;

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        (const char *)DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_,
        dst,
        dow,
        mon,
        (s32)info->day_number,
        (s32)info->year_short,
        (s32)info->second,
        (s32)info->day_of_year,
        (s32)info->hour,
        (s32)info->minute,
        ampm,
        dst_tag,
        year_tag
    );
}
