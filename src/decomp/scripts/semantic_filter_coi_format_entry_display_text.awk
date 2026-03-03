BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_time_window_call = 0
    has_get_field_call = 0
    has_flag_call = 0
    has_sprintf_call = 0
    has_update_flags_call = 0
    has_append_call = 0
    has_loop = 0
    has_return_branch = 0
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

    if (uline ~ /^COI_FORMATENTRYDISPLAYTEXT:/) has_label = 1
    if (index(uline, "LINK.W A5,#-44") > 0) has_link = 1
    if (index(uline, "MOVEM.L D2/D5-D7/A2-A3,-(A7)") > 0) has_save = 1
    if (index(uline, "BSR.W COI_TESTENTRYWITHINTIMEWINDOW") > 0) has_time_window_call = 1
    if (index(uline, "BSR.W COI_GETANIMFIELDPOINTERBYMODE") > 0) has_get_field_call = 1
    if (index(uline, "BSR.W CLEANUP_TESTENTRYFLAGYANDBIT1") > 0) has_flag_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_WDISP_SPRINTF") > 0) has_sprintf_call = 1
    if (index(uline, "BSR.W CLEANUP_UPDATEENTRYFLAGBYTES") > 0) has_update_flags_call = 1
    if (index(uline, "GROUP_AI_JMPTBL_STRING_APPENDATNULL") > 0) has_append_call = 1
    if (uline ~ /^\.LAB_0361:/) has_loop = 1
    if (index(uline, "COI_FORMATENTRYDISPLAYTEXT_RETURN") > 0) has_return_branch = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_TIME_WINDOW_CALL=" has_time_window_call
    print "HAS_GET_FIELD_CALL=" has_get_field_call
    print "HAS_FLAG_CALL=" has_flag_call
    print "HAS_SPRINTF_CALL=" has_sprintf_call
    print "HAS_UPDATE_FLAGS_CALL=" has_update_flags_call
    print "HAS_APPEND_CALL=" has_append_call
    print "HAS_LOOP=" has_loop
    print "HAS_RETURN_BRANCH=" has_return_branch
}
