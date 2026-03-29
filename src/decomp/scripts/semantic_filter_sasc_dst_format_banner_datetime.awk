BEGIN {
    has_day_table = 0
    has_month_table = 0
    has_day_index_load = 0
    has_month_index_load = 0
    has_day_number_load = 0
    has_year_short_load = 0
    has_day_of_year_load = 0
    has_hour_load = 0
    has_minute_load = 0
    has_ampm_test = 0
    has_ampm_am = 0
    has_ampm_pm = 0
    has_dst_mode_cmp = 0
    has_dst_tag_std = 0
    has_dst_tag_dst = 0
    has_leap_test = 0
    has_year_norm = 0
    has_year_leap = 0
    has_format_literal = 0
    has_format_call = 0
    has_return = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /GLOBAL_JMPTBL_SHORT_DAYS_OF_WEEK|GLOBAL_JMPTBL_SHORT_DAYS_OF_WEE/) {
        has_day_table = 1
    }
    if (u ~ /GLOBAL_JMPTBL_SHORT_MONTHS/) {
        has_month_table = 1
    }

    if (u ~ /^MOVE\.W (\(A[0-7]\)|\$0\(A[0-7]\)),D0$/) has_day_index_load = 1
    if (u ~ /^MOVE\.W (2|\$2)\(A[0-7]\),D0$/) has_month_index_load = 1
    if (u ~ /^MOVE\.W (4|\$4)\(A[0-7]\),D0$/) has_day_number_load = 1
    if (u ~ /^MOVE\.W (6|\$6)\(A[0-7]\),D1$/) has_year_short_load = 1
    if (u ~ /^MOVE\.W (16|\$10)\(A[0-7]\),D2$/) has_day_of_year_load = 1
    if (u ~ /^MOVE\.W (8|\$8)\(A[0-7]\),D3$/) has_hour_load = 1
    if (u ~ /^MOVE\.W (10|\$A)\(A[0-7]\),D4$/) has_minute_load = 1
    if (u ~ /^TST\.W (18|\$12)\(A[0-7]\)$/) has_ampm_test = 1
    if (u ~ /DST_TAG_AM/) has_ampm_am = 1
    if (u ~ /DST_TAG_PM/) has_ampm_pm = 1
    if (u ~ /^CMP\.W (14|\$E)\(A[0-7]\),D[0-7]$/) has_dst_mode_cmp = 1
    if (u ~ /DST_TAG_STD/) has_dst_tag_std = 1
    if (u ~ /DST_TAG_DST/) has_dst_tag_dst = 1
    if (u ~ /^TST\.W (20|\$14)\(A[0-7]\)$/) has_leap_test = 1
    if (u ~ /DST_STR_NORM_YEAR|DST_STR_NORM_YEA/) has_year_norm = 1
    if (u ~ /DST_STR_LEAP_YEAR|DST_STR_LEAP_YEA/) has_year_leap = 1
    if (u ~ /DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_|DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_P|DST_FMT_PCT_S_COLON_PCT_S_PCT_S_/) has_format_literal = 1
    if (u ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER|GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRAT|GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW|FORMAT_RAWDOFMTWITHSCRATCHBUFFER|FORMAT_RAWDOFMTWITHSCRAT|FORMAT_RAWDOFMTW/) has_format_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_DAY_TABLE=" has_day_table
    print "HAS_MONTH_TABLE=" has_month_table
    print "HAS_DAY_INDEX_LOAD=" has_day_index_load
    print "HAS_MONTH_INDEX_LOAD=" has_month_index_load
    print "HAS_DAY_NUMBER_LOAD=" has_day_number_load
    print "HAS_YEAR_SHORT_LOAD=" has_year_short_load
    print "HAS_DAY_OF_YEAR_LOAD=" has_day_of_year_load
    print "HAS_HOUR_LOAD=" has_hour_load
    print "HAS_MINUTE_LOAD=" has_minute_load
    print "HAS_AMPM_TEST=" has_ampm_test
    print "HAS_AM_TAG=" has_ampm_am
    print "HAS_PM_TAG=" has_ampm_pm
    print "HAS_DST_MODE_CMP=" has_dst_mode_cmp
    print "HAS_STD_TAG=" has_dst_tag_std
    print "HAS_DST_TAG=" has_dst_tag_dst
    print "HAS_LEAP_TEST=" has_leap_test
    print "HAS_NORM_YEAR_TAG=" has_year_norm
    print "HAS_LEAP_YEAR_TAG=" has_year_leap
    print "HAS_FORMAT_LITERAL=" has_format_literal
    print "HAS_FORMAT_CALL=" has_format_call
    print "HAS_RETURN=" has_return
}
