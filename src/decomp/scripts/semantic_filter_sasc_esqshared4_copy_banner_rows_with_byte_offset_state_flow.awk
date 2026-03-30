BEGIN {
    has_entry = 0
    has_src_offset = 0
    has_row_delta_b0 = 0
    has_row_copy = 0
    has_row_iteration_shape = 0
    has_row_stride_both = 0
    has_tail_offset_sum = 0
    has_tail_rebase = 0
    has_tail_copy = 0
    has_rts = 0

    word_copy_count = 0
    long_copy_count = 0
    add_a1_count = 0
    add_a2_count = 0
    explicit_loop_bound_16 = 0
    copy_helper_seen = 0
    tail_sum_started = 0
    tail_rebase_pending = 0
    tail_rebase_seen = 0
    tail_copy_pending = 0
    prev = ""
    prev2 = ""
    prev3 = ""
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") {
        next
    }

    if (l ~ /^ESQSHARED4_COPYBANNERROWSWITHBYTEOFFSET:/ || l ~ /^ESQSHARED4_COPYBANNERROWSWITHBYT[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (l ~ /ESQPARS2_BANNERCOPYSOURCEOFFSET/ || l ~ /BANNERCOPYSOURCEOFF/) {
        has_src_offset = 1
    }
    if (l ~ /#\$?B0/ || l ~ /\$B0\(A[0-7]\)/ || l ~ /#176/) {
        has_row_delta_b0 = 1
    }

    if (l ~ /^MOVE\.W \(A[0-7]\)\+,\(A[0-7]\)\+$/) {
        word_copy_count++
        has_row_copy = 1
        if (tail_copy_pending) {
            has_tail_copy = 1
        }
    }
    if (l ~ /^MOVE\.L \(A[0-7]\)\+,\(A[0-7]\)\+$/) {
        long_copy_count++
        has_row_copy = 1
        if (tail_copy_pending) {
            has_tail_copy = 1
        }
    }

    if (l ~ /COPY_ROW_CHUNK/) {
        copy_helper_seen = 1
        has_row_copy = 1
        if (tail_copy_pending) {
            has_tail_copy = 1
        }
    }

    if (l ~ /MOVEQ(\.L)? #\$?10,D[0-7]/ || l ~ /MOVE\.L #\$?10,D[0-7]/ || l ~ /CMP\.L #\$?10,D[0-7]/ || l ~ /CMPI\.L #\$?10,D[0-7]/ || l ~ /CMP\.W #\$?10,D[0-7]/ || l ~ /CMPI\.W #\$?10,D[0-7]/ || l ~ /#16/) {
        explicit_loop_bound_16 = 1
    }

    if (l ~ /^ADDA?\.L ESQSHARED_BLITADDRESSOFFSET,A1$/ || l ~ /^ADD\.L D[0-7],A3$/) {
        add_a1_count++
    }
    if (l ~ /^ADDA?\.L ESQSHARED_BLITADDRESSOFFSET,A2$/ || l ~ /^ADD\.L D[0-7],A2$/) {
        add_a2_count++
    }

    if (l ~ /GCOMMAND_BANNERROWBYTEOFFSETCURRENT/ || l ~ /GCOMMAND_BANNERROWBYTEOFFSETCURR/) {
        tail_sum_started = 1
    }
    if (tail_sum_started && (l ~ /ESQPARS2_BANNERCOPYTAILOFFSET/ || l ~ /BANNERCOPYTAILOFF/)) {
        has_tail_offset_sum = 1
        tail_rebase_pending = 1
    }

    if (tail_rebase_pending &&
        (l ~ /^MOVEA?\.L A0,A2$/ || l ~ /^MOVE\.L A[0-7],A2$/ || l ~ /^ADDA?\.L D[0-7],A2$/ || l ~ /^ADD\.L D[0-7],A2$/)) {
        tail_rebase_seen = 1
    }
    if (tail_rebase_seen && (word_copy_count > 0 || copy_helper_seen)) {
        has_tail_rebase = 1
        tail_copy_pending = 1
    }

    if (l == "RTS") {
        has_rts = 1
    }

    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    if (word_copy_count >= 17 && long_copy_count >= 17) {
        has_row_iteration_shape = 1
    }
    if (copy_helper_seen && explicit_loop_bound_16) {
        has_row_iteration_shape = 1
    }

    if ((add_a1_count >= 15 && add_a2_count >= 15) || (copy_helper_seen && explicit_loop_bound_16 && add_a1_count >= 1 && add_a2_count >= 1)) {
        has_row_stride_both = 1
    }

    if (has_tail_offset_sum && tail_rebase_seen) {
        has_tail_rebase = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_SRC_OFFSET=" has_src_offset
    print "HAS_ROW_DELTA_B0=" has_row_delta_b0
    print "HAS_ROW_COPY=" has_row_copy
    print "HAS_ROW_ITERATION_SHAPE=" has_row_iteration_shape
    print "HAS_ROW_STRIDE_BOTH=" has_row_stride_both
    print "HAS_TAIL_OFFSET_SUM=" has_tail_offset_sum
    print "HAS_TAIL_REBASE=" has_tail_rebase
    print "HAS_TAIL_COPY=" has_tail_copy
    print "HAS_RTS=" has_rts
}
