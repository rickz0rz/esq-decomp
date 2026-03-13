BEGIN {
    has_entry = 0
    has_query_soft = 0
    has_query_pct = 0
    has_sprintf = 0
    has_positive_branch = 0
    has_err_fmt = 0
    has_full_fmt = 0
    has_scratch = 0
    has_return_zero = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /DISKIO_QUERYVOLUMESOFTERRORCOUNT/) has_query_soft = 1
    if (l ~ /DISKIO_QUERYDISKUSAGEPERCENTANDSETBUFFERSIZE/ || l ~ /DISKIO_QUERYDISKUSAGEPERCENTANDS/) has_query_pct = 1
    if (l ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || l ~ /WDISP_SPRINTF/) has_sprintf = 1

    if (l ~ /^TST\.L D[0-7]$/ || l ~ /^CMP\.L #\$?0,D[0-7]$/ || l ~ /^BLE(\.[A-Z]+)? / || l ~ /^BGT(\.[A-Z]+)? /) has_positive_branch = 1

    if (l ~ /GLOBAL_STR_DISK_ERRORS_FORMATTED/) has_err_fmt = 1
    if (l ~ /GLOBAL_STR_DISK_IS_FULL_FORMATTED/ || l ~ /GLOBAL_STR_DISK_IS_FULL_FORMATTE/) has_full_fmt = 1
    if (l ~ /DISKIO_ERRORMESSAGESCRATCH/) has_scratch = 1

    if (l ~ /^MOVEQ(\.L)? #\$?0,D0$/ || l ~ /^CLR\.L D0$/ || l ~ /^MOVE\.L #\$?0,D0$/) has_return_zero = 1
    if (l == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_QUERY_SOFT=" has_query_soft
    print "HAS_QUERY_PCT=" has_query_pct
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_POSITIVE_BRANCH=" has_positive_branch
    print "HAS_ERR_FMT=" has_err_fmt
    print "HAS_FULL_FMT=" has_full_fmt
    print "HAS_SCRATCH=" has_scratch
    print "HAS_RETURN_ZERO=" has_return_zero
    print "HAS_RETURN=" has_return
}
