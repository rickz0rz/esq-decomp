BEGIN {
    in_func = 0
    has_entry = 0
    has_prefix_fmt = 0
    has_mask_fmt = 0
    fmt_call_count = 0
    byte_load_count = 0
    stack_arg_store_count = 0
    has_sum_reset = 0
    has_index_reset = 0
    has_accumulate_handoff = 0
    entry_stage = 0
    prefix_fmt_stage = 0
    load_stage = 0
    mask_fmt_stage = 0
    sum_reset_stage = 0
    index_reset_stage = 0
    accumulate_stage = 0

    saw_d5_reset = 0
    saw_d6_reset = 0
    saw_prefix_fmt_ref = 0
    saw_mask_fmt_ref = 0
    saw_prefix_fmt_call = 0
    saw_mask_fmt_call = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function emit(marker) {
    print marker
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    if (line ~ /^DISKIO1_FORMATTIMESLOTMASKFLAGS[A-Z0-9_]*:/) {
        in_func = 1
        has_entry = 1
        if (!entry_stage) {
            emit("ENTRY")
            entry_stage = 1
        }
        next
    }

    if (!in_func) {
        next
    }

    if (line ~ /^DISKIO1_FORMATBLACKOUTMASKFLAGS[A-Z0-9_]*:/ ||
        line ~ /^__CONST:$/ ||
        line ~ /^__STRINGS:$/ ||
        line ~ /^XREF / ||
        line ~ /^XDEF / ||
        line ~ /^SECTION / ||
        line ~ /^END$/) {
        exit
    }

    if (line ~ /DISKIO_STR_ATTRFLAGSCLOSEPARENNEWLINE_A/ ||
        line ~ /DISKIO_STR_ATTRFLAGSCLOSEPARENNE/) {
        has_prefix_fmt = 1
        saw_prefix_fmt_ref = 1
    }

    if (line ~ /DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX/ ||
        line ~ /DISKIO_FMT_TSLT_MASK_PCT_02LX_PC/) {
        has_mask_fmt = 1
        saw_mask_fmt_ref = 1
    }

    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRAT/ ||
        line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) {
        fmt_call_count++
        if (saw_prefix_fmt_ref && !saw_prefix_fmt_call) {
            emit("CALL_PREFIX_FMT")
            saw_prefix_fmt_call = 1
            prefix_fmt_stage = 1
            saw_prefix_fmt_ref = 0
        } else if (saw_mask_fmt_ref && !saw_mask_fmt_call) {
            emit("CALL_MASK_FMT")
            saw_mask_fmt_call = 1
            mask_fmt_stage = 1
            saw_mask_fmt_ref = 0
        }
    }

    if (line ~ /^MOVE\.B (28|29|30|31|32|33)\(A3/ ||
        line ~ /^MOVE\.B __MERGEDBSS(\+\$[0-9A-F]+)?\(A4\),D[0-5]$/) {
        byte_load_count++
        emit("LOAD_MASK_BYTE_" byte_load_count)
        load_stage = 1
    }

    if (line ~ /^MOVE\.L D[0-5],[-(]/ ||
        line ~ /^MOVE\.L 48\(A7\),-\(A7\)$/ ||
        line ~ /^MOVE\.L D5,\(A7\)$/ ||
        line ~ /^MOVE\.L D[0-5],\(A7\)$/) {
        stack_arg_store_count++
        emit("STACK_ARG_STORE_" stack_arg_store_count)
    }

    if ((mask_fmt_stage && line ~ /^MOVEQ(\.L)? #\$?0,D5$/) ||
        line ~ /^CLR\.L __MERGEDBSS\+\$C\(A4\)$/) {
        has_sum_reset = 1
        saw_d5_reset = 1
        if (!sum_reset_stage) {
            emit("RESET_MASK_SUM")
            sum_reset_stage = 1
        }
    }

    if ((mask_fmt_stage && line ~ /^MOVEQ(\.L)? #\$?0,D6$/) ||
        line ~ /^CLR\.L __MERGEDBSS\+\$10\(A4\)$/) {
        has_index_reset = 1
        saw_d6_reset = 1
        if (!index_reset_stage) {
            emit("RESET_MASK_INDEX")
            index_reset_stage = 1
        }
    }

    if (line ~ /^DISKIO1_ACCUMULATETIMESLOTMASKSUM[A-Z0-9_]*:$/ ||
        line ~ /DISKIO1_ACCUMULATETIMESLOTMASKSU/ ||
        line ~ /GROUP_[A-Z0-9_]*DISKIO1_ACCUMULATETIMESLOTMASKSU/) {
        if (saw_d5_reset && saw_d6_reset) {
            has_accumulate_handoff = 1
            if (!accumulate_stage) {
                emit("HANDOFF_ACCUMULATE_SUM")
                accumulate_stage = 1
            }
            exit
        }
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PREFIX_FMT=" has_prefix_fmt
    print "HAS_MASK_FMT=" has_mask_fmt
    print "FMT_CALL_COUNT=" fmt_call_count
    print "BYTE_LOAD_COUNT=" byte_load_count
    print "STACK_ARG_STORE_COUNT=" stack_arg_store_count
    print "HAS_SUM_RESET=" has_sum_reset
    print "HAS_INDEX_RESET=" has_index_reset
    print "HAS_ACCUMULATE_HANDOFF=" has_accumulate_handoff
    print "ORDER_ENTRY_PREFIX_FMT=" (entry_stage && prefix_fmt_stage)
    print "ORDER_PREFIX_BEFORE_LOADS=" (prefix_fmt_stage && load_stage)
    print "ORDER_LOADS_BEFORE_MASK_FMT=" (load_stage && mask_fmt_stage)
    print "ORDER_MASK_FMT_BEFORE_SUM_RESET=" (mask_fmt_stage && sum_reset_stage)
    print "ORDER_SUM_RESET_BEFORE_INDEX_RESET=" (sum_reset_stage && index_reset_stage)
    print "ORDER_INDEX_RESET_BEFORE_HANDOFF=" (index_reset_stage && accumulate_stage)
}
