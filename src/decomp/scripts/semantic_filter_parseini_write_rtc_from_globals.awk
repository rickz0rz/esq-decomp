BEGIN {
    has_util_guard = 0
    has_batt_guard = 0
    has_adjust = 0
    has_check = 0
    has_seconds = 0
    has_write = 0
    has_month_plus1 = 0
    has_clock_struct = 0
    has_cache_hour = 0
    has_cache_ampm = 0
    has_terminal = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /GLOBALREFUTILITYLIBRARY/) has_util_guard = 1
    if (n ~ /GLOBALREFBATTCLOCKRESOURCE/) has_batt_guard = 1
    if (n ~ /PARSEINIADJUSTHOURSTO24HRFORMAT/) has_adjust = 1
    if (n ~ /PARSEINI2JMPTBLCLOCKCHECKDATEORSECONDSFROMEPOCH/) has_check = 1
    if (n ~ /PARSEINI2JMPTBLCLOCKSECONDSFROMEPOCH/) has_seconds = 1
    if (n ~ /PARSEINI2JMPTBLBATTCLOCKWRITESECONDSTOBATTERYBACKEDCLOCK/) has_write = 1
    if (u ~ /ADDQ|ADDI|\\+1| 1/ || n ~ /CLOCKCACHEMONTHINDEX0/) has_month_plus1 = 1
    if (n ~ /GLOBALREFCLOCKDATASTRUCT/) has_clock_struct = 1
    if (n ~ /CLOCKCACHEHOUR/) has_cache_hour = 1
    if (n ~ /CLOCKCACHEAMPMFLAG/) has_cache_ampm = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_UTIL_GUARD=" has_util_guard
    print "HAS_BATT_GUARD=" has_batt_guard
    print "HAS_ADJUST=" has_adjust
    print "HAS_CHECK=" has_check
    print "HAS_SECONDS=" has_seconds
    print "HAS_WRITE=" has_write
    print "HAS_MONTH_PLUS1=" has_month_plus1
    print "HAS_CLOCK_STRUCT=" has_clock_struct
    print "HAS_CACHE_HOUR=" has_cache_hour
    print "HAS_CACHE_AMPM=" has_cache_ampm
    print "HAS_TERMINAL=" has_terminal
}
