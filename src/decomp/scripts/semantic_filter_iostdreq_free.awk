BEGIN {
    has_field8_ff = 0
    has_field20_neg1 = 0
    has_field24_neg1 = 0
    has_size_48 = 0
    has_freemem_call = 0
    has_rts = 0
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

    if (u ~ /^MOVE\.B #\$?FF,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^MOVE\.B #-1,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^ST \([0-9]+,A[0-7]\)$/) has_field8_ff = 1
    if (u ~ /^MOVE\.L A0,20\(A[0-7]\)$/ || u ~ /^MOVE\.L #\$?FFFFFFFF,20\(A[0-7]\)$/ || u ~ /^MOVE\.L #-1,20\(A[0-7]\)$/ || u ~ /^MOVE\.L D0,\(20,A[0-7]\)$/) has_field20_neg1 = 1
    if (u ~ /^MOVE\.L A0,24\(A[0-7]\)$/ || u ~ /^MOVE\.L #\$?FFFFFFFF,24\(A[0-7]\)$/ || u ~ /^MOVE\.L #-1,24\(A[0-7]\)$/ || u ~ /^MOVE\.L D0,\(24,A[0-7]\)$/) has_field24_neg1 = 1
    if (u ~ /^MOVEQ #48,D0$/ || u ~ /^MOVE\.L #48,D0$/) has_size_48 = 1
    if (u ~ /JSR .*LVOFREEMEM/) has_freemem_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_FIELD8_FF=" has_field8_ff
    print "HAS_FIELD20_NEG1=" has_field20_neg1
    print "HAS_FIELD24_NEG1=" has_field24_neg1
    print "HAS_SIZE_48=" has_size_48
    print "HAS_FREEMEM_CALL=" has_freemem_call
    print "HAS_RTS=" has_rts
}
