BEGIN {
    has_sub1 = 0
    has_and7 = 0
    has_lsr3 = 0
    has_btst = 0
    has_boolize = 0
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
    if (u ~ /^BTST / || u ~ /\(A[0-7],D[0-7]\.W\)/ || u ~ /LSL\.L D[0-7],D[0-7]/ || u ~ /AND\.B \(.*A[0-7].*D[0-7]/) has_btst = 1
    if (u ~ /^SNE / || u ~ /^SEQ / || u ~ /^EXT\.[WL] D[0-7]/ || u ~ /^MOVEQ #-1,D[0-7]$/ || u ~ /^CLR\.L D[0-7]$/) has_boolize = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SUB1=" has_sub1
    print "HAS_AND7=" has_and7
    print "HAS_LSR3=" has_lsr3
    print "HAS_BTST=" has_btst
    print "HAS_BOOLIZE=" has_boolize
    print "HAS_RTS=" has_rts
}
