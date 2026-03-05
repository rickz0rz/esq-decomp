BEGIN {
    has_entry = 0
    has_span = 0
    has_stride = 0
    has_active_flag = 0
    has_58 = 0
    has_banner_a = 0
    has_banner_b = 0
    has_tail_write = 0
    has_source_write = 0
    has_call_interleaved = 0
    has_scratch_base = 0
    has_call_copy_rows = 0
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

    if (uline ~ /^ESQSHARED4_BLITBANNERROWSFORACTIVEFIELD:/ || uline ~ /^ESQSHARED4_BLITBANNERROWSFORACTI[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQPARS2_BANNERROWCOPYSPANBYTES") > 0 || index(uline, "BANNERROWCOPYSPAN") > 0) has_span = 1
    if (index(uline, "ESQPARS2_BANNERROWCOPYSTRIDEBYTES") > 0 || index(uline, "ESQPARS2_BANNERROWCOPYSTRIDEBYTE") > 0 || index(uline, "BANNERROWCOPYSTRIDE") > 0) has_stride = 1
    if (index(uline, "ESQPARS2_ACTIVECOPPERLISTSELECTFLAG") > 0 || index(uline, "ESQPARS2_ACTIVECOPPERLISTSELECTF") > 0 || index(uline, "ACTIVECOPPERLISTSELECT") > 0) has_active_flag = 1
    if (uline ~ /#(\$)?58/ || uline ~ /#88/) has_58 = 1
    if (index(uline, "ESQ_COPPERLISTBANNERA") > 0 || index(uline, "ESQ_COPPERLISTBANNER") > 0) has_banner_a = 1
    if (index(uline, "ESQ_COPPERLISTBANNERB") > 0 || index(uline, "ESQ_COPPERLISTBANNER") > 0) has_banner_b = 1
    if (index(uline, "ESQPARS2_BANNERCOPYTAILOFFSET") > 0 || index(uline, "BANNERCOPYTAILOFF") > 0) has_tail_write = 1
    if (index(uline, "ESQPARS2_BANNERCOPYSOURCEOFFSET") > 0 || index(uline, "BANNERCOPYSOURCEOFF") > 0) has_source_write = 1
    if (index(uline, "ESQSHARED4_COPYINTERLEAVEDROWWORDSFROMOFFSET") > 0 || index(uline, "COPYINTERLEAVEDROWWOR") > 0) has_call_interleaved = 1
    if (index(uline, "ESQSHARED_BANNERROWSCRATCHRASTERBASE0") > 0 || index(uline, "ESQSHARED_BANNERROWSCRATCHRASTERBASE1") > 0 || index(uline, "ESQSHARED_BANNERROWSCRATCHRASTERBASE2") > 0 || index(uline, "ESQSHARED_BANNERROWSCRATCHRASTER") > 0 || index(uline, "BANNERROWSCRATCHRASTERBASE") > 0) has_scratch_base = 1
    if (index(uline, "ESQSHARED4_COPYBANNERROWSWITHBYTEOFFSET") > 0 || index(uline, "COPYBANNERROWSWITHBYT") > 0) has_call_copy_rows = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SPAN=" has_span
    print "HAS_STRIDE=" has_stride
    print "HAS_ACTIVE_FLAG=" has_active_flag
    print "HAS_58_CONST=" has_58
    print "HAS_BANNER_A=" has_banner_a
    print "HAS_BANNER_B=" has_banner_b
    print "HAS_TAIL_WRITE=" has_tail_write
    print "HAS_SOURCE_WRITE=" has_source_write
    print "HAS_CALL_INTERLEAVED=" has_call_interleaved
    print "HAS_SCRATCH_BASE=" has_scratch_base
    print "HAS_CALL_COPY_ROWS=" has_call_copy_rows
    print "HAS_RTS=" has_rts
}
