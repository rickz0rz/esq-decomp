BEGIN {
    has_entry = 0
    has_base = 0
    has_d1 = 0
    has_a = 0
    has_b = 0
    has_wa = 0
    has_wb = 0
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

    if (uline ~ /^ESQSHARED4_SETBANNERCOLORBASEANDLIMIT:/) has_entry = 1
    if (uline ~ /^MOVE\.W D0,ESQPARS2_BANNERCOLORBASEVALUE$/) has_base = 1
    if (uline ~ /^MOVE\.W #0XD9,D1$/ || uline ~ /^MOVE\.W #\$D9,D1$/) has_d1 = 1
    if (uline ~ /^MOVE\.B D0,ESQ_BANNERCOLORCLAMPVALUEA$/) has_a = 1
    if (uline ~ /^MOVE\.B D0,ESQ_BANNERCOLORCLAMPVALUEB$/) has_b = 1
    if (uline ~ /^MOVE\.B D1,ESQ_BANNERCOLORCLAMPWAITROWA$/) has_wa = 1
    if (uline ~ /^MOVE\.B D1,ESQ_BANNERCOLORCLAMPWAITROWB$/) has_wb = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BASE=" has_base
    print "HAS_D1=" has_d1
    print "HAS_A=" has_a
    print "HAS_B=" has_b
    print "HAS_WA=" has_wa
    print "HAS_WB=" has_wb
    print "HAS_RTS=" has_rts
}
