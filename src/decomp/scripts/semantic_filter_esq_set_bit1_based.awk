BEGIN {
    has_sub1 = 0
    has_and7 = 0
    has_lsr3 = 0
    has_bset_or_equiv = 0
    has_write = 0
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

    if (u ~ /SUBQ\.[BWL] #1,D[0-7]/ || u ~ /SUBI?\.[BWL] #1,D[0-7]/) has_sub1 = 1
    if (u ~ /#\$?7,D[0-7]/ || u ~ /#7,D[0-7]/) has_and7 = 1
    if (u ~ /LSR\.[BWL] #3,D[0-7]/) has_lsr3 = 1

    if (u ~ /^BSET / || u ~ /LSL\.L D[0-7],D[0-7]/ || u ~ /^OR\.B D[0-7],D[0-7]$/ || u ~ /^OR\.B .*\(A[0-7]/) has_bset_or_equiv = 1
    if (u ~ /\(A[0-7],D[0-7]\.[WL]\)/ || u ~ /\(0,A[0-7],D[0-7]\.[WL]\)/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]/ || u ~ /^OR\.B .*A[0-7],D[0-7]\.[WL]\)/) has_write = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SUB1=" has_sub1
    print "HAS_AND7=" has_and7
    print "HAS_LSR3=" has_lsr3
    print "HAS_BSET_OR_EQUIV=" has_bset_or_equiv
    print "HAS_WRITE=" has_write
    print "HAS_RTS=" has_rts
}
