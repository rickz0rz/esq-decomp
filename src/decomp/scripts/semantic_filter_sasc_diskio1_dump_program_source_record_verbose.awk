BEGIN {
    has_entry = 0
    has_header_fmt = 0
    has_attr_intro = 0
    has_attr_test = 0
    has_timeslot_fmt = 0
    has_blackout_fmt = 0
    has_footer_fmt = 0
    fmt_calls = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) fmt_calls++

    if (line ~ /DISKIO_FMT_CHANNEL_LINE_UP_PCT_D/ || line ~ /DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT/ || line ~ /DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT/) has_header_fmt = 1
    if (line ~ /DISKIO_STR_ATTR/) has_attr_intro = 1
    if (line ~ /^BTST / || line ~ /^ANDI\.[BWL] / || line ~ /^AND\.[BWL] / || line ~ /^CMP\.[BWL] / || line ~ /^CMPI\.[BWL] /) has_attr_test = 1
    if (line ~ /DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X/ || line ~ /DISKIO_FMT_TSLT_MASK/) has_timeslot_fmt = 1
    if (line ~ /DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X/ || line ~ /DISKIO_FMT_BLKOUT_MASK/) has_blackout_fmt = 1
    if (line ~ /DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG/ || line ~ /DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG/) has_footer_fmt = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_HEADER_FMT=" has_header_fmt
    print "HAS_ATTR_INTRO=" has_attr_intro
    print "HAS_ATTR_TEST=" has_attr_test
    print "HAS_TIMESLOT_FMT=" has_timeslot_fmt
    print "HAS_BLACKOUT_FMT=" has_blackout_fmt
    print "HAS_FOOTER_FMT=" has_footer_fmt
    print "FMT_CALL_COUNT_GE_8=" (fmt_calls >= 8)
}
