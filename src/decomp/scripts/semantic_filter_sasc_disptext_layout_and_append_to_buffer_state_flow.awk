BEGIN {
    has_entry = 0
    has_lock_gate = 0
    has_target_gate = 0
    has_existing_line_measure = 0
    has_control_width_adjust = 0
    has_scratch_clear = 0
    has_prefix_measure = 0
    has_prefix_copy = 0
    has_prefix_overflow_commit = 0
    has_loop_guards = 0
    has_build_append_sequence = 0
    has_length_update = 0
    has_width_reset = 0
    has_loop_commit = 0
    has_flush_sequence = 0
    has_status_return = 0

    target_refs = 0
    loop_guard_refs = 0
    build_stage = 0
    flush_stage = 0

    saw_build_call = 0
    saw_prefix_measure = 0
    saw_flush_probe = 0
    saw_status_ff = 0
    saw_status_zero = 0
    saw_seq = 0
    saw_sne = 0
    saw_neg = 0
    saw_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    if (line ~ /^DISPTEXT_LAYOUTANDAPPENDTOB[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (line ~ /DISPTEXT_LINETABLELOCKFLAG/) {
        has_lock_gate = 1
    }

    if (line ~ /DISPTEXT_TARGETLINEINDEX/) {
        target_refs++
    }
    if (line ~ /DISPTEXT_CURRENTLINEINDEX/ && line ~ /DISPTEXT_TARGETLINEINDEX/) {
        has_target_gate = 1
    }
    if (target_refs >= 2) {
        has_target_gate = 1
    }

    if (line ~ /DISPTEXT_LINEPTRTABLE/ || line ~ /DISPTEXT_LINELENGTHTABLE/) {
        if (line ~ /DISPTEXT_LINELENGTHTABLE/) {
            has_existing_line_measure = 1
        }
    }
    if (line ~ /LVOTEXTLENGTH/ && has_existing_line_measure) {
        has_existing_line_measure = 1
        if (saw_prefix_measure) {
            has_prefix_measure = 1
        }
    }

    if (line ~ /DISPTEXT_LINEWIDTHPX/ || line ~ /DISPTEXT_CONTROLMARKERWIDTHPX/) {
        has_control_width_adjust = 1
    }

    if ((line ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_2/ ||
         line ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) &&
        line ~ /CLR\.B/) {
        has_scratch_clear = 1
    }
    if (line ~ /^CLR\.B \(A[0-7]\)$/) {
        has_scratch_clear = 1
    }

    if (line ~ /DISPTEXT_STR_SINGLE_SPACE_PREFIX_2/ ||
        line ~ /DISPTEXT_STR_SINGLE_SPACE_PREFIX/) {
        saw_prefix_measure = 1
    }
    if (saw_prefix_measure && line ~ /LVOTEXTLENGTH/) {
        has_prefix_measure = 1
    }

    if (line ~ /DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX/ ||
        line ~ /DISPTEXT_STR_SINGLE_SPACE_COPY_P/) {
        has_prefix_copy = 1
    }
    if (has_prefix_copy &&
        ((line ~ /DISPTEXT_LINELENGTHTABLE/ && line ~ /ADDQ\.W #1/) ||
         line ~ /ADDQ\.W #\$?1,D0/)) {
        has_prefix_copy = 1
    }

    if (has_prefix_measure && !saw_build_call &&
        line ~ /DISPLIB_COMMITCURRENTLINEPENANDADVANCE|DISPLIB_COMMITCURRENTLINEPENANDA/) {
        has_prefix_overflow_commit = 1
    }

    if (line ~ /MOVE\.L A2,D0|MOVE\.L A2,D1|MOVE\.L A3,D0|MOVE\.L A3,D1|TST\.B \(A2\)|TST\.B \(A3\)|DISPTEXT_TARGETLINEINDEX/) {
        loop_guard_refs++
    }
    if (loop_guard_refs >= 4) {
        has_loop_guards = 1
    }

    if (line ~ /DISPTEXT_BUILDLINEWITHWIDTH|DISPTEXT_BUILDLINEWITHWID/) {
        saw_build_call = 1
        build_stage = 1
    } else if (build_stage == 1 &&
               line ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL|GROUP_AI_JMPTBL_STRING_APPENDATN/) {
        build_stage = 2
    } else if (build_stage == 2 &&
               line ~ /DISPTEXT_LINELENGTHTABLE|ADD\.L D5,D1|MOVE\.W D1,\(A0\)/) {
        build_stage = 3
    }
    if (build_stage >= 3) {
        has_build_append_sequence = 1
    }

    if ((build_stage >= 2 &&
         (line ~ /ADD\.L D5,D1/ || line ~ /ADD\.W \$28\(A7\),D0/ ||
          line ~ /MOVE\.W D1,\(A0\)/ || line ~ /MOVE\.W D0,\$0\(A0,D1\.L\)/)) ||
        (line ~ /DISPTEXT_LINELENGTHTABLE/ &&
         (line ~ /ADD\.L D5,D1/ || line ~ /MOVE\.W D1,\(A0\)/))) {
        has_length_update = 1
    }

    if (saw_build_call &&
        (line ~ /DISPTEXT_LINEWIDTHPX/ || line ~ /DISPTEXT_CONTROLMARKERWIDTHPX/)) {
        has_width_reset = 1
    }

    if (saw_build_call &&
        line ~ /DISPLIB_COMMITCURRENTLINEPENANDADVANCE|DISPLIB_COMMITCURRENTLINEPENANDA/) {
        has_loop_commit = 1
    }

    if (line ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_2/ ||
        line ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) {
        saw_flush_probe = 1
    }
    if ((saw_flush_probe && line ~ /TST\.B/) || line ~ /^TST\.B \(A[0-7]\)$/) {
        flush_stage = 1
    } else if (flush_stage == 1 &&
               line ~ /DISPTEXT_APPENDTOBUFFER|DISPTEXT_APPENDTOBUFF/) {
        flush_stage = 2
    } else if (flush_stage == 2 &&
               line ~ /DISPTEXT_BUILDLINEPOINTERTABLE|DISPTEXT_BUILDLINEPOINTERTA/) {
        flush_stage = 3
    }
    if (flush_stage >= 3) {
        has_flush_sequence = 1
    }

    if (line ~ /SEQ D0|SNE D0/) {
        if (line ~ /SEQ D0/) saw_seq = 1
        if (line ~ /SNE D0/) saw_sne = 1
    }
    if (line ~ /NEG\.B D0/) {
        saw_neg = 1
    }
    if (line ~ /MOVEQ(\.L)? #\$?FF,D0|MOVEQ(\.L)? #\-1,D0/) {
        saw_status_ff = 1
    }
    if (line ~ /MOVEQ(\.L)? #\$?0,D0/) {
        saw_status_zero = 1
    }
    if (line ~ /^RTS$/) {
        saw_rts = 1
    }
    if (((saw_seq || saw_sne) && saw_neg && saw_rts) ||
        (saw_status_ff && saw_status_zero && saw_rts)) {
        has_status_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK_GATE=" has_lock_gate
    print "HAS_TARGET_GATE=" has_target_gate
    print "HAS_EXISTING_LINE_MEASURE=" has_existing_line_measure
    print "HAS_CONTROL_WIDTH_ADJUST=" has_control_width_adjust
    print "HAS_SCRATCH_CLEAR=" has_scratch_clear
    print "HAS_PREFIX_MEASURE=" has_prefix_measure
    print "HAS_PREFIX_COPY=" has_prefix_copy
    print "HAS_PREFIX_OVERFLOW_COMMIT=" has_prefix_overflow_commit
    print "HAS_LOOP_GUARDS=" has_loop_guards
    print "HAS_BUILD_APPEND_SEQUENCE=" has_build_append_sequence
    print "HAS_LENGTH_UPDATE=" has_length_update
    print "HAS_WIDTH_RESET=" has_width_reset
    print "HAS_LOOP_COMMIT=" has_loop_commit
    print "HAS_FLUSH_SEQUENCE=" has_flush_sequence
    print "HAS_STATUS_RETURN=" has_status_return
}
