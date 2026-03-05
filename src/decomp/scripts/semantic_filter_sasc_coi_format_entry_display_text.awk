BEGIN {
    has_label = 0
    has_time_window_call = 0
    has_get_field_call = 0
    has_flag_call = 0
    has_sprintf_call = 0
    has_update_flags_call = 0
    has_append_call = 0
    has_loop = 0
    has_return_branch = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_FORMATENTRYDISPLAYTEXT[A-Z0-9_]*:/) has_label = 1
    if (u ~ /COI_TESTENTRYWITHINTIMEWINDOW/) has_time_window_call = 1
    if (u ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_field_call = 1
    if (u ~ /CLEANUP_TESTENTRYFLAGYANDBIT1/) has_flag_call = 1
    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || u ~ /GROUP_AE_JMPTBL_WDISP_SPRIN/) has_sprintf_call = 1
    if (u ~ /CLEANUP_UPDATEENTRYFLAGBYTES/) has_update_flags_call = 1
    if (u ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/ || u ~ /GROUP_AI_JMPTBL_STRING_APPENDAT/) has_append_call = 1
    if (u ~ /CMP.L D0,D5/ || u ~ /ADDQ.L #1,D5/ || u ~ /__COI_FORMATENTRYDISPLAYTEXT__/) has_loop = 1
    if (u ~ /COI_FORMATENTRYDISPLAYTEXT_RETURN/ || u ~ /RTS/) has_return_branch = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_TIME_WINDOW_CALL=" has_time_window_call
    print "HAS_GET_FIELD_CALL=" has_get_field_call
    print "HAS_FLAG_CALL=" has_flag_call
    print "HAS_SPRINTF_CALL=" has_sprintf_call
    print "HAS_UPDATE_FLAGS_CALL=" has_update_flags_call
    print "HAS_APPEND_CALL=" has_append_call
    print "HAS_LOOP=" has_loop
    print "HAS_RETURN_BRANCH=" has_return_branch
}
