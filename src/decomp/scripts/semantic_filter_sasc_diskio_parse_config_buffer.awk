BEGIN {
    has_entry = 0
    has_parse = 0
    has_refresh_update = 0
    has_mulu = 0
    has_store_minutes = 0
    has_store_seconds = 0
    has_rts = 0
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

    if (l ~ /^DISKIO_PARSECONFIGBUFFER:/ || l ~ /^DISKIO_PARSECONFIGBUFF/) has_entry = 1
    if ((index(l, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(l, "GROUP_AG_JMPTBL_PARSE_READSIGNED") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_parse = 1
    if ((index(l, "ESQFUNC_UPDATEREFRESHMODESTATE") > 0 || index(l, "GROUP_AG_JMPTBL_ESQFUNC_UPDATERE") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_refresh_update = 1
    if (index(l, "MATH_MULU32") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_mulu = 1
    if (index(l, "CONFIG_REFRESHINTERVALMINUTES") > 0 && l ~ /^MOVE\.B /) has_store_minutes = 1
    if (index(l, "CONFIG_REFRESHINTERVALSECONDS") > 0 && l ~ /^MOVE\.L /) has_store_seconds = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PARSE=" has_parse
    print "HAS_REFRESH_UPDATE=" has_refresh_update
    print "HAS_MULU=" has_mulu
    print "HAS_STORE_MINUTES=" has_store_minutes
    print "HAS_STORE_SECONDS=" has_store_seconds
    print "HAS_RTS=" has_rts
}
