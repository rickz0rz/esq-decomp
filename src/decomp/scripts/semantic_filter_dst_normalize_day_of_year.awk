BEGIN {
    label=0; leap_calls=0; d365=0; d366=0; cmp_loop=0; sub_year=0; ret=0
    boolize=0
}

/^DST_NormalizeDayOfYear:$/ { label=1 }
/DATETIME_IsLeapYear/ { leap_calls++ }
# Original branch style may materialize 365 directly.
/#\$16d|#365|365\.w/ { d365=1 }
/#366|366\.w/ { d366=1 }
# GCC may encode 365/366 via SEQ/EXT/ADD #366 (result 365 or 366).
/^SEQ[[:space:]]+[dD][0-7]$|^EXT\.W[[:space:]]+[dD][0-7]$|^EXT\.L[[:space:]]+[dD][0-7]$/ { boolize=1 }
/^CMP\.W[[:space:]]+[dDaA][0-7],[dDaA][0-7]$|^CMP\.L[[:space:]]+[dDaA][0-7],[dDaA][0-7]$/ { cmp_loop=1 }
/^SUB\.W[[:space:]]+[dD][0-7],[dD][0-7]$|^SUB\.L[[:space:]]+[dD][0-7],[dD][0-7]$|^ADDQ\.W[[:space:]]+#1,[dD][0-7]$|^ADDQ\.L[[:space:]]+#1,[dD][0-7]$/ { sub_year=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (leap_calls >= 2) print "HAS_REPEATED_LEAPYEAR_CALL"
    if (d365 || boolize) print "HAS_365_CASE"
    if (d366) print "HAS_366_CASE"
    if (cmp_loop) print "HAS_NORMALIZE_COMPARE_LOOP"
    if (sub_year) print "HAS_SUBTRACT_AND_INCREMENT"
    if (ret) print "HAS_RTS"
}
