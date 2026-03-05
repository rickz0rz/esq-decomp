BEGIN {
    has_entry = 0
    has_guard_test = 0
    has_guard_set = 0
    has_group_guard = 0
    has_write_calls = 0
    has_oi_call = 0
    has_guard_clear = 0
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

    if (line ~ /^TST\.[BWL] .*FLUSHDATAFILESGUARDFLAG/ || line ~ /^CMP\.[BWL] #\$?0,.*FLUSHDATAFILESGUARDFLAG/ || line ~ /^MOVE\.[BWL] __MERGEDBSS\(A4\),D0/ || line ~ /^BNE(\.[A-Z]+)? /) has_guard_test = 1
    if (line ~ /^MOVE\.[BWL] #\$?1,.*FLUSHDATAFILESGUARDFLAG/ || line ~ /^MOVE\.[BWL] #\$?1,__MERGEDBSS\(A4\)/) has_guard_set = 1
    if (line ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || line ~ /CMPI\.[BWL] #\$?C9/) has_group_guard = 1
    if (line ~ /DISKIO2_WRITECURDAYDATAFILE/ || line ~ /DISKIO2_WRITENXTDAYDATAFILE/ || line ~ /DISKIO2_WRITEOINFODATAFILE/) has_write_calls = 1
    if (line ~ /COI_WRITEOIDATAFILE/) has_oi_call = 1
    if (line ~ /^CLR\.[BWL] .*FLUSHDATAFILESGUARDFLAG/ || line ~ /^MOVE\.[BWL] #\$?0,.*FLUSHDATAFILESGUARDFLAG/ || line ~ /^CLR\.[BWL] __MERGEDBSS\(A4\)/) has_guard_clear = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD_TEST=" has_guard_test
    print "HAS_GUARD_SET=" has_guard_set
    print "HAS_GROUP_GUARD=" has_group_guard
    print "HAS_WRITE_CALLS=" has_write_calls
    print "HAS_OI_CALL=" has_oi_call
    print "HAS_GUARD_CLEAR=" has_guard_clear
}
