BEGIN {
    has_entry = 0
    has_loop_seed_7 = 0
    has_call_decode = 0
    has_cmp_4 = 0
    has_cmp_1c = 0
    has_offset_add_4 = 0
    has_program_a = 0
    has_program_b = 0
    has_anchor_a = 0
    has_anchor_b = 0
    has_tail_a = 0
    has_tail_b = 0
    has_index_store = 0
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

    if (uline ~ /^ESQSHARED4_LOADCOPPERCOLORWORDSFROMNIBBLETABLE:/ || uline ~ /^ESQSHARED4_LOADCOPPERCOLORWORDS[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /#(\$)?7/ || uline ~ /#0*7/) has_loop_seed_7 = 1
    if (index(uline, "ESQSHARED4_DECODERGBNIBBLETRIPLET") > 0 || index(uline, "DECODERGBNIBBLE") > 0) has_call_decode = 1
    if (uline ~ /#(\$)?4/ || uline ~ /#0*4/) has_cmp_4 = 1
    if (uline ~ /#(\$)?1C/ || uline ~ /#28/) has_cmp_1c = 1
    if (uline ~ /ADDQ\.W #(\$)?4/ || uline ~ /ADDI\.W #(\$)?4/ || uline ~ /ADD\.W #(\$)?4/) has_offset_add_4 = 1
    if (index(uline, "ESQ_BANNERCOLORSWEEPPROGRAMA") > 0 || index(uline, "ESQ_BANNERCOLORSWEEPPROGR") > 0) has_program_a = 1
    if (index(uline, "ESQ_BANNERCOLORSWEEPPROGRAMB") > 0 || index(uline, "ESQ_BANNERCOLORSWEEPPROGR") > 0) has_program_b = 1
    if (index(uline, "ESQ_BANNERCOLORSWEEPPROGRAMA_ANC") > 0 || index(uline, "ANCHORCOLORWORD") > 0) has_anchor_a = 1
    if (index(uline, "ESQ_BANNERCOLORSWEEPPROGRAMB_ANC") > 0 || index(uline, "ANCHORCOLORWORD") > 0) has_anchor_b = 1
    if (index(uline, "ESQ_BANNERCOLORSWEEPPROGRAMA_TAI") > 0 || index(uline, "TAILCOLORWORD") > 0) has_tail_a = 1
    if (index(uline, "ESQ_BANNERCOLORSWEEPPROGRAMB_TAI") > 0 || index(uline, "TAILCOLORWORD") > 0) has_tail_b = 1
    if (uline ~ /0\(A[0-7],D[0-7]\.[WL]\)/ || uline ~ /\(A[0-7],D[0-7]\.[WL]\)/) has_index_store = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_SEED_7=" has_loop_seed_7
    print "HAS_CALL_DECODE=" has_call_decode
    print "HAS_CMP_4=" has_cmp_4
    print "HAS_CMP_1C=" has_cmp_1c
    print "HAS_OFFSET_ADD_4=" has_offset_add_4
    print "HAS_PROGRAM_A=" has_program_a
    print "HAS_PROGRAM_B=" has_program_b
    print "HAS_ANCHOR_A=" has_anchor_a
    print "HAS_ANCHOR_B=" has_anchor_b
    print "HAS_TAIL_A=" has_tail_a
    print "HAS_TAIL_B=" has_tail_b
    print "HAS_INDEX_STORE=" has_index_store
    print "HAS_RTS=" has_rts
}
