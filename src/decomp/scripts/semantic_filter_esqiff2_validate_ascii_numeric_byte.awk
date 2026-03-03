BEGIN {
    has_entry = 0
    has_moveq1 = 0
    has_cmp_low = 0
    has_cmp_high = 0
    has_return = 0
    has_rts = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^ESQIFF2_VALIDATEASCIINUMERICBYTE:/) has_entry = 1
    if (uline ~ /^MOVEQ #1,D0$/) has_moveq1 = 1
    if (uline ~ /^CMP\.B D0,D7$/) has_cmp_low = 1
    if (uline ~ /^CMP\.B D1,D7$/) has_cmp_high = 1
    if (uline ~ /^\.RETURN:$/) has_return = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVEQ1=" has_moveq1
    print "HAS_CMP_LOW=" has_cmp_low
    print "HAS_CMP_HIGH=" has_cmp_high
    print "HAS_RETURN_LABEL=" has_return
    print "HAS_RTS=" has_rts
}
