BEGIN {
    has_entry = 0
    has_program_info_fmt = 0
    has_source_fmt = 0
    has_null_guard = 0
    has_loop_bound = 0
    has_clock_ref = 0
    has_attr_test = 0
    has_line_fmt_or_null = 0
    has_trailing_newline = 0
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

    if (line ~ /DISKIO_FMT_PROGRAM_INFO_PCT_LD/ || line ~ /DISKIO_FMT_PROGRAM_INFO_PCT_/) has_program_info_fmt = 1
    if (line ~ /DISKIO_FMT_PROG_SRCE_PCT_S_VERBOSEPROGRAMINFO/ || line ~ /DISKIO_FMT_PROG_SRCE_PCT_S_VERBOSEPROG/ || line ~ /DISKIO_FMT_PROG_SRCE_PCT_S_VERBO/) has_source_fmt = 1
    if (line ~ /^TST\.[BWL] / || line ~ /^CMP\.[BWL] #\$?0,/ || line ~ /^BEQ(\.[A-Z]+)? /) has_null_guard = 1
    if (line ~ /CMP\.[BWL] D0,D6/ || line ~ /CMP\.[BWL] #\$?31,/ || line ~ /CMP\.[BWL] #\$?49,/) has_loop_bound = 1
    if (line ~ /GLOBAL_REF_STR_CLOCK_FORMAT/) has_clock_ref = 1
    if (line ~ /^BTST / || line ~ /^ANDI\.[BWL] / || line ~ /^AND\.[BWL] / || line ~ /^CMP\.[BWL] / || line ~ /^CMPI\.[BWL] /) has_attr_test = 1
    if (line ~ /DISKIO_FMT_PCT_S_VERBOSEPROGRAMSTRINGLINE/ || line ~ /DISKIO_FMT_PCT_S_VERBOSEPROGRAMSTRI/ || line ~ /DISKIO_STR_NULLLINE/) has_line_fmt_or_null = 1
    if (line ~ /DISKIO_STR_NEWLINEONLY_B/ || line ~ /DISKIO_STR_NEWLINEONLY_/) has_trailing_newline = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROGRAM_INFO_FMT=" has_program_info_fmt
    print "HAS_SOURCE_FMT=" has_source_fmt
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_CLOCK_REF=" has_clock_ref
    print "HAS_ATTR_TEST=" has_attr_test
    print "HAS_LINE_FMT_OR_NULL=" has_line_fmt_or_null
    print "HAS_TRAILING_NEWLINE=" has_trailing_newline
    print "FMT_CALL_COUNT_GE_6=" (fmt_calls >= 6)
}
