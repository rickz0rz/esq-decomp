BEGIN {
    has_entry = 0
    has_lock_test = 0
    has_target_check = 0
    has_text_length = 0
    has_build_line = 0
    has_append_at_null = 0
    has_commit_line = 0
    has_append_buffer = 0
    has_build_ptr_table = 0
    has_width_adjust = 0
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
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/ && l ~ /DISPTEXT_TARGETLINEINDEX/) has_target_check = 1
    if (l ~ /LVOTEXTLENGTH/) has_text_length = 1
    if (l ~ /DISPTEXT_BUILDLINEWITHWIDTH/ || l ~ /DISPTEXT_BUILDLINEWITHWID/) has_build_line = 1
    if (l ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/ || l ~ /GROUP_AI_JMPTBL_STRING_APPENDATN/) has_append_at_null = 1
    if (l ~ /DISPLIB_COMMITCURRENTLINEPENANDADVANCE/ || l ~ /DISPLIB_COMMITCURRENTLINEPENANDA/) has_commit_line = 1
    if (l ~ /DISPTEXT_APPENDTOBUFFER/ || l ~ /DISPTEXT_APPENDTOBUFF/) has_append_buffer = 1
    if (l ~ /DISPTEXT_BUILDLINEPOINTERTABLE/ || l ~ /DISPTEXT_BUILDLINEPOINTERTA/) has_build_ptr_table = 1
    if (l ~ /DISPTEXT_LINEWIDTHPX/ || l ~ /DISPTEXT_CONTROLMARKERWIDTHPX/) has_width_adjust = 1

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
    print "HAS_TARGET_CHECK=" has_target_check
    print "HAS_TEXT_LENGTH=" has_text_length
    print "HAS_BUILD_LINE=" has_build_line
    print "HAS_APPEND_AT_NULL=" has_append_at_null
    print "HAS_COMMIT_LINE=" has_commit_line
    print "HAS_APPEND_BUFFER=" has_append_buffer
    print "HAS_BUILD_PTR_TABLE=" has_build_ptr_table
    print "HAS_WIDTH_ADJUST=" has_width_adjust
    print "HAS_STATUS=" has_status
    print "HAS_RETURN=" has_return
}
