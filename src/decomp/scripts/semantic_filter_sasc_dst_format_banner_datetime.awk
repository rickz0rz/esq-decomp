BEGIN {
    fmt_call = 0
    days = 0
    months = 0
    am = 0
    pm = 0
    std = 0
    dst = 0
    leap = 0
    norm = 0
    fmt = 0
    c1 = 0
    has_rts_or_jmp = 0
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

    if (u ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER|GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRAT|GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) fmt_call = 1
    if (u ~ /GLOBAL_JMPTBL_SHORT_DAYS_OF_WEEK|GLOBAL_JMPTBL_SHORT_DAYS_OF_WEE/) days = 1
    if (u ~ /GLOBAL_JMPTBL_SHORT_MONTHS/) months = 1
    if (u ~ /DST_TAG_AM/) am = 1
    if (u ~ /DST_TAG_PM/) pm = 1
    if (u ~ /DST_TAG_STD/) std = 1
    if (u ~ /DST_TAG_DST/) dst = 1
    if (u ~ /DST_STR_LEAP_YEAR|DST_STR_LEAP_YEA/) leap = 1
    if (u ~ /DST_STR_NORM_YEAR|DST_STR_NORM_YEA/) norm = 1
    if (u ~ /DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_|DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_P|DST_FMT_PCT_S_COLON_PCT_S_PCT_S_/) fmt = 1
    if (u ~ /#\$1|#1|1\.W/) c1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_FORMAT_CALL=" fmt_call
    print "HAS_DAY_TABLE=" days
    print "HAS_MONTH_TABLE=" months
    print "HAS_AM_TAG=" am
    print "HAS_PM_TAG=" pm
    print "HAS_STD_TAG=" std
    print "HAS_DST_TAG=" dst
    print "HAS_LEAP_STR=" leap
    print "HAS_NORM_STR=" norm
    print "HAS_FORMAT_LITERAL=" fmt
    print "HAS_CONST_1=" c1
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
