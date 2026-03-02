BEGIN {
    label=0; fmt_call=0; days=0; months=0; am=0; pm=0; std=0; dst=0; leap=0; norm=0; fmt=0; c1=0; ret=0
}

/^DST_FormatBannerDateTime:$/ { label=1 }
/GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer/ { fmt_call=1 }
/Global_JMPTBL_SHORT_DAYS_OF_WEEK/ { days=1 }
/Global_JMPTBL_SHORT_MONTHS/ { months=1 }
/DST_TAG_AM/ { am=1 }
/DST_TAG_PM/ { pm=1 }
/DST_TAG_STD/ { std=1 }
/DST_TAG_DST/ { dst=1 }
/DST_STR_LEAP_YEAR/ { leap=1 }
/DST_STR_NORM_YEAR/ { norm=1 }
/DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_/ { fmt=1 }
/#\$1|#1|1\.[Ww]/ { c1=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (fmt_call) print "HAS_FORMAT_CALL"
    if (days) print "HAS_DAY_TABLE"
    if (months) print "HAS_MONTH_TABLE"
    if (am) print "HAS_AM_TAG"
    if (pm) print "HAS_PM_TAG"
    if (std) print "HAS_STD_TAG"
    if (dst) print "HAS_DST_TAG"
    if (leap) print "HAS_LEAP_STR"
    if (norm) print "HAS_NORM_STR"
    if (fmt) print "HAS_FORMAT_LITERAL"
    if (c1) print "HAS_CONST_1"
    if (ret) print "HAS_RTS"
}
