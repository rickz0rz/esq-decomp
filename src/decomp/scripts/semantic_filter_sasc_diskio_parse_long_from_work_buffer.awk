BEGIN {
    has_entry = 0
    has_consume = 0
    has_sentinel_cmp = 0
    has_sentinel_return = 0
    has_parse_call = 0
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

    if (l ~ /^DISKIO_PARSELONGFROMWORKBUFFER:/ || l ~ /^DISKIO_PARSELONGFROMWORKBUF:/) has_entry = 1
    if (index(l, "DISKIO_CONSUMECSTRINGFROMWORKBUF") > 0 && (l ~ /^BSR(\.[A-Z]+)? / || l ~ /^JSR /)) has_consume = 1
    if (l ~ /^CMP\.L [AD][0-7],[AD][0-7]$/ || l ~ /^CMP\.L #\$?0*FFFF,D[0-7]$/ || l ~ /^CMP\.L D[0-7],#\$?0*FFFF$/ || (index(l, "#$FFFF") > 0 && l ~ /^CMP\./)) has_sentinel_cmp = 1
    if (l ~ /^MOVE\.L #\$?0*FFFF,D[0-7]$/ || l ~ /^MOVE\.L A[0-7],D[0-7]$/) has_sentinel_return = 1
    if ((index(l, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(l, "PARSE_READSIGNEDLONGSKIPCLASS3_A") > 0 || index(l, "GROUP_AG_JMPTBL_PARSE_READSIGNED") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_parse_call = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CONSUME=" has_consume
    print "HAS_SENTINEL_CMP=" has_sentinel_cmp
    print "HAS_SENTINEL_RETURN=" has_sentinel_return
    print "HAS_PARSE_CALL=" has_parse_call
    print "HAS_RTS=" has_rts
}
