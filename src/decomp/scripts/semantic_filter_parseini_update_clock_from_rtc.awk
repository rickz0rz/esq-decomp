BEGIN {
    has_util_guard = 0
    has_batt_guard = 0
    has_get_secs = 0
    has_convert = 0
    has_check = 0
    has_normalize = 0
    has_fallback = 0
    has_dst = 0
    has_6 = 0
    has_11 = 0
    has_31 = 0
    has_9999 = 0
    has_23 = 0
    has_59 = 0
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
    if (n ~ /PARSEINI2JMPTBLBATTCLOCKGETSECONDSFROMBATTERYBACKEDCLOCK/) has_get_secs = 1
    if (n ~ /PARSEINI2JMPTBLCLOCKCONVERTAMIGASECONDSTOCLOCKDATA/) has_convert = 1
    if (n ~ /PARSEINI2JMPTBLCLOCKCHECKDATEORSECONDSFROMEPOCH/) has_check = 1
    if (n ~ /PARSEININORMALIZECLOCKDATA/) has_normalize = 1
    if (n ~ /PARSEINIFALLBACKCLOCKDATARECORD/) has_fallback = 1
    if (n ~ /DSTPRIMARYCOUNTDOWN/) has_dst = 1
    if (u ~ /[^0-9]6[^0-9]/ || u ~ /^6$/) has_6 = 1
    if (u ~ /[^0-9]11[^0-9]/ || u ~ /^11$/) has_11 = 1
    if (u ~ /[^0-9]31[^0-9]/ || u ~ /^31$/) has_31 = 1
    if (u ~ /[^0-9]9999[^0-9]/ || u ~ /^9999$/) has_9999 = 1
    if (u ~ /[^0-9]23[^0-9]/ || u ~ /^23$/) has_23 = 1
    if (u ~ /[^0-9]59[^0-9]/ || u ~ /^59$/) has_59 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_UTIL_GUARD=" has_util_guard
    print "HAS_BATT_GUARD=" has_batt_guard
    print "HAS_GET_SECS=" has_get_secs
    print "HAS_CONVERT=" has_convert
    print "HAS_CHECK=" has_check
    print "HAS_NORMALIZE=" has_normalize
    print "HAS_FALLBACK=" has_fallback
    print "HAS_DST=" has_dst
    print "HAS_6=" has_6
    print "HAS_11=" has_11
    print "HAS_31=" has_31
    print "HAS_9999=" has_9999
    print "HAS_23=" has_23
    print "HAS_59=" has_59
    print "HAS_TERMINAL=" has_terminal
}
