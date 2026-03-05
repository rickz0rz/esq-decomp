BEGIN {
    has_entry = 0
    has_header_fmt = 0
    has_ptr_fmt = 0
    has_ptr_guard = 0
    has_detail_fmt = 0
    has_exception_fmt = 0
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

    if (line ~ /DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG/ || line ~ /DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DEFAULT/ || line ~ /DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG/) has_header_fmt = 1
    if (line ~ /DISKIO_FMT_COI_DASH_PTR_PCT_08LX/ || line ~ /DISKIO_FMT_COI_DASH_PTR/) has_ptr_fmt = 1
    if (line ~ /DISKIO_STR_DEF_DEFAULT/ || line ~ /DISKIO_FMT_DEF_CITY_PCT_08LX/ || line ~ /DISKIO_FMT_DEF_ORDER_PCT_08LX/) has_detail_fmt = 1
    if (line ~ /DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD/ || line ~ /DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX/ || line ~ /DISKIO_FMT_EXCEPTION_COUNT/ || line ~ /DISKIO_FMT_EXCEPTION_BLOCK/) has_exception_fmt = 1

    if (line ~ /^TST\.[BWL] / || line ~ /^CMP\.[BWL] #\$?0,/ || line ~ /^BEQ(\.[A-Z]+)? / || line ~ /^BEQ(\.[A-Z]+)? DISKIO1_DUMPDEFAULTCOIINFOBLOCK_RETURN/) has_ptr_guard = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_HEADER_FMT=" has_header_fmt
    print "HAS_PTR_FMT=" has_ptr_fmt
    print "HAS_PTR_GUARD=" has_ptr_guard
    print "HAS_DETAIL_FMT=" has_detail_fmt
    print "HAS_EXCEPTION_FMT=" has_exception_fmt
    print "FMT_CALL_COUNT_GE_4=" (fmt_calls >= 4)
}
