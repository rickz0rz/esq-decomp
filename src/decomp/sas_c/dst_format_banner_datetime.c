#include <exec/types.h>
enum {
    DST_MODE_DST = 1
};

typedef struct DST_BannerTimeInfo {
    WORD day_of_week_index;
    WORD month_index;
    WORD day_number;
    WORD year_short;
    WORD day_of_year;
    WORD hour;
    WORD minute;
    WORD dst_mode_flag;
    WORD second;
    WORD ampm_flag;
    WORD leap_year_flag;
} DST_BannerTimeInfo;

extern const char *Global_JMPTBL_SHORT_DAYS_OF_WEEK[];
extern const char *Global_JMPTBL_SHORT_MONTHS[];
extern const char DST_TAG_AM[];
extern const char DST_TAG_PM[];
extern const char DST_TAG_STD[];
extern const char DST_TAG_DST[];
extern const char DST_STR_NORM_YEAR[];
extern const char DST_STR_LEAP_YEAR[];
extern const char DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_[];

extern void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

void DST_FormatBannerDateTime(char *dst, const DST_BannerTimeInfo *info)
{
    const char *dow = Global_JMPTBL_SHORT_DAYS_OF_WEEK[(UWORD)info->day_of_week_index];
    const char *mon = Global_JMPTBL_SHORT_MONTHS[(UWORD)info->month_index];
    const char *ampm = info->ampm_flag ? DST_TAG_PM : DST_TAG_AM;
    const char *dst_tag = (info->dst_mode_flag == DST_MODE_DST) ? DST_TAG_DST : DST_TAG_STD;
    const char *year_tag = info->leap_year_flag ? DST_STR_LEAP_YEAR : DST_STR_NORM_YEAR;

    FORMAT_RawDoFmtWithScratchBuffer(
        DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_,
        dst,
        dow,
        mon,
        (LONG)info->day_number,
        (LONG)info->year_short,
        (LONG)info->second,
        (LONG)info->day_of_year,
        (LONG)info->hour,
        (LONG)info->minute,
        ampm,
        dst_tag,
        year_tag
    );
}
