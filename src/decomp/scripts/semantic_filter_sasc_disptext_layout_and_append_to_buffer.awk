BEGIN {
    has_entry = 0
    has_lock_test = 0
    has_lock_status = 0
    has_target_check = 0
    has_target_status = 0
    has_text_length = 0
    has_build_line = 0
    has_append_at_null = 0
    has_commit_line = 0
    has_append_buffer = 0
    has_build_ptr_table = 0
    has_width_adjust = 0
    has_prefix_copy = 0
    has_prefix_line_bump = 0
    has_source_null_guard = 0
    has_source_empty_guard = 0
    has_length_scan = 0
    has_line_length_accumulate = 0
    has_flush_guard = 0
    has_status = 0
    has_return = 0
    saw_seq = 0
    saw_sne = 0
    saw_neg = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /DISPTEXT_LINETABLELOCKFLAG/) has_lock_test = 1
    if (has_lock_test && l ~ /MOVE\.L A[23],D[01]/) has_lock_status = 1
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/ || l ~ /DISPTEXT_TARGETLINEINDEX/) has_target_check = 1
    if (has_target_check && l ~ /MOVE\.L A[23],D[01]/) has_target_status = 1
    if (l ~ /LVOTEXTLENGTH/) has_text_length = 1
    if (l ~ /DISPTEXT_BUILDLINEWITHWIDTH/ || l ~ /DISPTEXT_BUILDLINEWITHWID/) has_build_line = 1
    if (l ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/ || l ~ /GROUP_AI_JMPTBL_STRING_APPENDATN/) has_append_at_null = 1
    if (l ~ /DISPLIB_COMMITCURRENTLINEPENANDADVANCE/ || l ~ /DISPLIB_COMMITCURRENTLINEPENANDA/) has_commit_line = 1
    if (l ~ /DISPTEXT_APPENDTOBUFFER/ || l ~ /DISPTEXT_APPENDTOBUFF/) has_append_buffer = 1
    if (l ~ /DISPTEXT_BUILDLINEPOINTERTABLE/ || l ~ /DISPTEXT_BUILDLINEPOINTERTA/) has_build_ptr_table = 1
    if (l ~ /DISPTEXT_LINEWIDTHPX/ || l ~ /DISPTEXT_CONTROLMARKERWIDTHPX/) has_width_adjust = 1
    if (l ~ /DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX/ || l ~ /DISPTEXT_STR_SINGLE_SPACE_COPY_P/) has_prefix_copy = 1
    if (l ~ /ADDQ\.W #1,\(A0\)/ || l ~ /ADDQ\.W #\$1,D0/) has_prefix_line_bump = 1
    if (l ~ /MOVE\.L A[23],D0/ || l ~ /MOVE\.L A[23],D1/) has_source_null_guard = 1
    if (l ~ /TST\.B \(A[23]\)/) has_source_empty_guard = 1
    if (l ~ /TST\.B \(A1\)\+/ || l ~ /MOVE\.B \(A0\)\+,D0/ || l ~ /MOVE\.B \(A1\)\+,D0/) has_length_scan = 1
    if (l ~ /MOVE\.W D1,\(A0\)/ || l ~ /ADD\.W \$28\(A7\),D0/ || l ~ /ADD\.L D5,D1/) has_line_length_accumulate = 1
    if (l ~ /MOVEA?\.L GLOBAL_REF_1000_BYTES_ALLOCATED_/ || l ~ /MOVE\.B GLOBAL_REF_1000_BYTES_ALLOCATED_\(A4\),D0/) has_flush_guard = 1

    if (l ~ /SEQ D0/) saw_seq = 1
    if (l ~ /SNE D0/) saw_sne = 1
    if (l ~ /NEG\.B D0/) saw_neg = 1
    if (l ~ /MOVEQ(\.L)? #\$?FF,D0/ || l ~ /MOVEQ(\.L)? #\-1,D0/ || l ~ /MOVEQ(\.L)? #\$?FFFFFFFF,D0/) has_status = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    if ((saw_sne && saw_neg) || (saw_seq && saw_neg)) has_status = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK_TEST=" has_lock_test
    print "HAS_LOCK_STATUS=" has_lock_status
    print "HAS_TARGET_CHECK=" has_target_check
    print "HAS_TARGET_STATUS=" has_target_status
    print "HAS_TEXT_LENGTH=" has_text_length
    print "HAS_BUILD_LINE=" has_build_line
    print "HAS_APPEND_AT_NULL=" has_append_at_null
    print "HAS_COMMIT_LINE=" has_commit_line
    print "HAS_APPEND_BUFFER=" has_append_buffer
    print "HAS_BUILD_PTR_TABLE=" has_build_ptr_table
    print "HAS_WIDTH_ADJUST=" has_width_adjust
    print "HAS_PREFIX_COPY=" has_prefix_copy
    print "HAS_PREFIX_LINE_BUMP=" has_prefix_line_bump
    print "HAS_SOURCE_NULL_GUARD=" has_source_null_guard
    print "HAS_SOURCE_EMPTY_GUARD=" has_source_empty_guard
    print "HAS_LENGTH_SCAN=" has_length_scan
    print "HAS_LINE_LENGTH_ACCUMULATE=" has_line_length_accumulate
    print "HAS_FLUSH_GUARD=" has_flush_guard
    print "HAS_STATUS=" has_status
    print "HAS_RETURN=" has_return
}
