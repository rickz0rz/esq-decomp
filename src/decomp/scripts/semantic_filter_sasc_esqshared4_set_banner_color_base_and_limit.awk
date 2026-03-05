BEGIN {
    has_entry = 0
    has_base_write = 0
    has_clamp_a = 0
    has_clamp_b = 0
    has_wait_a = 0
    has_wait_b = 0
    has_d9 = 0
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

    if (uline ~ /^ESQSHARED4_SETBANNERCOLORBASEANDLIMIT:/ || uline ~ /^ESQSHARED4_SETBANNERCOLORBASEANDL[A-Z0-9_]*:/ || uline ~ /^ESQSHARED4_SETBANNERCOLORBASEAND[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQPARS2_BANNERCOLORBASEVALUE") > 0 || index(uline, "ESQPARS2_BANNERCOLORBASEVAL") > 0) has_base_write = 1
    if (index(uline, "ESQ_BANNERCOLORCLAMPVALUEA") > 0 || index(uline, "ESQ_BANNERCOLORCLAMPVALUE") > 0) has_clamp_a = 1
    if (index(uline, "ESQ_BANNERCOLORCLAMPVALUEB") > 0 || index(uline, "ESQ_BANNERCOLORCLAMPVALUE") > 0) has_clamp_b = 1
    if (index(uline, "ESQ_BANNERCOLORCLAMPWAITROWA") > 0 || index(uline, "ESQ_BANNERCOLORCLAMPWAITROW") > 0) has_wait_a = 1
    if (index(uline, "ESQ_BANNERCOLORCLAMPWAITROWB") > 0 || index(uline, "ESQ_BANNERCOLORCLAMPWAITROW") > 0) has_wait_b = 1
    if (uline ~ /#(\$)?D9/ || uline ~ /#217/) has_d9 = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BASE_WRITE=" has_base_write
    print "HAS_CLAMP_A=" has_clamp_a
    print "HAS_CLAMP_B=" has_clamp_b
    print "HAS_WAIT_A=" has_wait_a
    print "HAS_WAIT_B=" has_wait_b
    print "HAS_D9_CONST=" has_d9
    print "HAS_RTS=" has_rts
}
