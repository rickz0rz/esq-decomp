BEGIN {
    has_entry = 0
    has_src_offset = 0
    has_tail_offset = 0
    has_current_offset = 0
    has_blit_offset = 0
    has_b0 = 0
    has_word_copy = 0
    has_long_copy = 0
    has_copy_helper = 0
    has_loop = 0
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

    if (uline ~ /^ESQSHARED4_COPYBANNERROWSWITHBYTEOFFSET:/ || uline ~ /^ESQSHARED4_COPYBANNERROWSWITHBYT[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQPARS2_BANNERCOPYSOURCEOFFSET") > 0 || index(uline, "BANNERCOPYSOURCEOFF") > 0) has_src_offset = 1
    if (index(uline, "ESQPARS2_BANNERCOPYTAILOFFSET") > 0 || index(uline, "BANNERCOPYTAILOFF") > 0) has_tail_offset = 1
    if (index(uline, "GCOMMAND_BANNERROWBYTEOFFSETCURRENT") > 0 || index(uline, "GCOMMAND_BANNERROWBYTEOFFSETCURR") > 0 || index(uline, "BANNERROWBYTEOFFSETCURR") > 0) has_current_offset = 1
    if (index(uline, "ESQSHARED_BLITADDRESSOFFSET") > 0 || index(uline, "BLITADDRESSOFFSET") > 0) has_blit_offset = 1
    if (uline ~ /#(\$)?B0/ || uline ~ /\$B0\(A[0-7]\)/ || uline ~ /#176/) has_b0 = 1
    if (uline ~ /^MOVE\.W / || uline ~ /\(A[0-7]\)\+,\(A[0-7]\)\+/) has_word_copy = 1
    if (uline ~ /^MOVE\.L / || uline ~ /\(A[0-7]\)\+,\(A[0-7]\)\+/) has_long_copy = 1
    if (index(uline, "COPY_ROW_CHUNK") > 0) has_copy_helper = 1
    if (uline ~ /^DBF / || uline ~ /^DBRA / || uline ~ /^BNE(\.[BWL])? / || uline ~ /^BHI(\.[BWL])? / || uline ~ /^BGE(\.[BWL])? / || uline ~ /^BRA(\.[BWL])? / || uline ~ /^ADDQ\.[WL] #(\$)?1,D[0-7]/ || uline ~ /^CMPI\.[WL] / || uline ~ /^CMP\.[WL] /) has_loop = 1
    if (uline == "RTS") has_rts = 1
}

END {
    if (has_copy_helper) {
        has_word_copy = 1
        has_long_copy = 1
    }
    if (has_word_copy && has_long_copy) {
        has_loop = 1
    }
    print "HAS_ENTRY=" has_entry
    print "HAS_SRC_OFFSET=" has_src_offset
    print "HAS_TAIL_OFFSET=" has_tail_offset
    print "HAS_CURRENT_OFFSET=" has_current_offset
    print "HAS_BLIT_OFFSET=" has_blit_offset
    print "HAS_B0_CONST=" has_b0
    print "HAS_WORD_COPY=" has_word_copy
    print "HAS_LONG_COPY=" has_long_copy
    print "HAS_LOOP=" has_loop
    print "HAS_RTS=" has_rts
}
