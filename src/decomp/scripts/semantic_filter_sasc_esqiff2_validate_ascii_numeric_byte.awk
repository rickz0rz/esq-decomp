BEGIN {
    has_entry = 0
    has_moveq1 = 0
    has_cmp_low = 0
    has_cmp_high = 0
    has_restore = 0
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
    u = toupper(line)

    if (u ~ /^ESQIFF2_VALIDATEASCIINUMERICBYTE:/ || u ~ /^ESQIFF2_VALIDATEASCIINUMERICB[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #1,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$1,D[0-7]$/) has_moveq1 = 1
    if (u ~ /^CMP\.B D0,D[0-7]$/ || u ~ /^CMPI\.B #1,D[0-7]$/ || u ~ /^CMPI\.B #\$1,D[0-7]$/) has_cmp_low = 1
    if (u ~ /^CMP\.B D1,D[0-7]$/ || u ~ /^CMP\.B D0,D[0-7]$/ || u ~ /^CMPI\.B #48,D[0-7]$/ || u ~ /^CMPI\.B #\$30,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #48,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$30,D[0-7]$/) has_cmp_high = 1
    if (u ~ /^MOVE\.L \(A7\)\+,D7$/ || u ~ /^MOVEM\.L \(A7\)\+,D[0-7].*$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVEQ1=" has_moveq1
    print "HAS_CMP_LOW=" has_cmp_low
    print "HAS_CMP_HIGH=" has_cmp_high
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
