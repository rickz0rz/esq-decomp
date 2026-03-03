BEGIN {
    has_row_count_read = 0
    has_copy_span_write = 0
    has_row_width_read = 0
    has_lsr_3 = 0
    has_stride_write = 0
    has_blt_offset_write = 0
    has_block_span_read = 0
    has_lsr_5 = 0
    has_sub_1 = 0
    has_copy_word_count_write = 0
    has_word_limit_write = 0
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

    if (u ~ /ESQPARS2_BANNERROWCOUNT/ && u ~ /,D[0-7]$/) has_row_count_read = 1
    if (u ~ /ESQPARS2_BANNERROWCOPYSPANBYTES/) has_copy_span_write = 1

    if (u ~ /ESQPARS2_BANNERROWWIDTHBYTES/ && u ~ /,D[0-7]$/) has_row_width_read = 1
    if (u ~ /^LSR\.[WL] #3,D[0-7]$/) has_lsr_3 = 1
    if (u ~ /ESQPARS2_BANNERROWCOPYSTRIDEBYTES/) has_stride_write = 1

    if (u ~ /ESQSHARED_BLITADDRESSOFFSET/) has_blt_offset_write = 1

    if (u ~ /ESQPARS2_BANNERCOPYBLOCKSPANBYTES/ && u ~ /,D[0-7]$/) has_block_span_read = 1
    if (u ~ /^LSR\.[WL] #5,D[0-7]$/) has_lsr_5 = 1
    if (u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^SUBI?\.[WL] #1,D[0-7]$/) has_sub_1 = 1
    if (u ~ /ESQPARS2_BANNERROWCOPYWORDCOUNT/) has_copy_word_count_write = 1

    if (u ~ /ESQPARS2_BANNERCOPYBLOCKWORDLIMIT/) has_word_limit_write = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ROW_COUNT_READ=" has_row_count_read
    print "HAS_COPY_SPAN_WRITE=" has_copy_span_write
    print "HAS_ROW_WIDTH_READ=" has_row_width_read
    print "HAS_LSR_3=" has_lsr_3
    print "HAS_STRIDE_WRITE=" has_stride_write
    print "HAS_BLT_OFFSET_WRITE=" has_blt_offset_write
    print "HAS_BLOCK_SPAN_READ=" has_block_span_read
    print "HAS_LSR_5=" has_lsr_5
    print "HAS_SUB_1=" has_sub_1
    print "HAS_COPY_WORD_COUNT_WRITE=" has_copy_word_count_write
    print "HAS_WORD_LIMIT_WRITE=" has_word_limit_write
    print "HAS_RTS=" has_rts
}
