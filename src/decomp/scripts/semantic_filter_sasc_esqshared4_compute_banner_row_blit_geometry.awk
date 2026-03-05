BEGIN {
    has_entry = 0
    has_mul_58 = 0
    has_span_write = 0
    has_width_shift = 0
    has_stride_write = 0
    has_blit_add_58 = 0
    has_blit_write = 0
    has_block_shift = 0
    has_row_word_write = 0
    has_word_limit_write = 0
    has_rts = 0
    has_scale88_seq = 0
    has_moveq_58 = 0
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

    if (uline ~ /^ESQSHARED4_COMPUTEBANNERROWBLITGEOMETRY:/ || uline ~ /^ESQSHARED4_COMPUTEBANNERROWBLITG[A-Z0-9_]*:/) has_entry = 1

    if (uline ~ /MULU .*#(\$)?58/ || uline ~ /MULU #88/) has_mul_58 = 1
    if (uline ~ /^ASL\.L #(\$)?2,D[0-7]$/ || uline ~ /^SUB\.L D[0-7],D[0-7]$/ || uline ~ /^ASL\.L #(\$)?3,D[0-7]$/) has_scale88_seq = 1
    if (index(uline, "ESQPARS2_BANNERROWCOPYSPANBYTES") > 0 || index(uline, "ESQPARS2_BANNERROWCOPYSPANB") > 0) has_span_write = 1

    if (uline ~ /^LSR\.W #(\$)?3,D[0-7]$/ || uline ~ /^LSR\.L #(\$)?3,D[0-7]$/ || uline ~ /^ASR\.L #(\$)?3,D[0-7]$/ || uline ~ /^ASR\.W #(\$)?3,D[0-7]$/) has_width_shift = 1
    if (index(uline, "ESQPARS2_BANNERROWCOPYSTRIDEBYTES") > 0 || index(uline, "ESQPARS2_BANNERROWCOPYSTRIDEB") > 0) has_stride_write = 1

    if (uline ~ /^MOVEQ(\.L)? #(\$)?58,D[0-7]$/) has_moveq_58 = 1
    if ((uline ~ /^ADDI\.[WL] #(\$)?58,D[0-7]$/ || uline ~ /^ADD\.[WL] #(\$)?58,D[0-7]$/ || uline ~ /^ADD\.[WL] D[0-7],D[0-7]$/ || uline ~ /^ADDQ\.[WL] #(\$)?8,D[0-7]$/) && (has_stride_write || has_moveq_58)) has_blit_add_58 = 1
    if (index(uline, "ESQSHARED_BLITADDRESSOFFSET") > 0 || index(uline, "ESQSHARED_BLITADDRESSOFFS") > 0) has_blit_write = 1

    if (uline ~ /^LSR\.W #(\$)?5,D[0-7]$/ || uline ~ /^LSR\.L #(\$)?5,D[0-7]$/ || uline ~ /^ASR\.L #(\$)?5,D[0-7]$/ || uline ~ /^ASR\.W #(\$)?5,D[0-7]$/) has_block_shift = 1
    if (index(uline, "ESQPARS2_BANNERROWCOPYWORDCOUNT") > 0 || index(uline, "ESQPARS2_BANNERROWCOPYWORDC") > 0) has_row_word_write = 1
    if (index(uline, "ESQPARS2_BANNERCOPYBLOCKWORDLIMIT") > 0 || index(uline, "ESQPARS2_BANNERCOPYBLOCKWORDL") > 0) has_word_limit_write = 1

    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    if (has_mul_58 == 0 && has_scale88_seq == 1) has_mul_58 = 1
    print "HAS_MUL_58=" has_mul_58
    print "HAS_SPAN_WRITE=" has_span_write
    print "HAS_WIDTH_SHIFT=" has_width_shift
    print "HAS_STRIDE_WRITE=" has_stride_write
    print "HAS_BLIT_ADD_58=" has_blit_add_58
    print "HAS_BLIT_WRITE=" has_blit_write
    print "HAS_BLOCK_SHIFT=" has_block_shift
    print "HAS_ROW_WORD_WRITE=" has_row_word_write
    print "HAS_WORD_LIMIT_WRITE=" has_word_limit_write
    print "HAS_RTS=" has_rts
}
