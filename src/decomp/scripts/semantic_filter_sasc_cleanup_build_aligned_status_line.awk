BEGIN {
    has_label = 0
    has_get_entry_ptr = 0
    has_test_flag = 0
    has_get_anim_ptr = 0
    has_sprintf = 0
    has_append = 0
    has_set_gate = 0
    has_clear_gate = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_BUILDALIGNEDSTATUSLINE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /GROUP_AE_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE/ || u ~ /GROUP_AE_JMPTBL_ESQDISP_GETENTRYPOINTER/ || u ~ /GROUP_AE_JMPTBL_ESQDISP_GETENTRY/) has_get_entry_ptr = 1
    if (u ~ /CLEANUP_TESTENTRYFLAGYANDBIT1/) has_test_flag = 1
    if (u ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_anim_ptr = 1
    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || u ~ /GROUP_AE_JMPTBL_WDISP_SPRIN/) has_sprintf = 1
    if (u ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/ || u ~ /GROUP_AI_JMPTBL_STRING_APPENDAT/) has_append = 1
    if (u ~ /CLOCK_ALIGNEDINSETRENDERGATEFLAG/ && (u ~ /#\$1/ || u ~ /MOVE.B #1/)) has_set_gate = 1
    if (u ~ /CLR.B CLOCK_ALIGNEDINSETRENDERGATEFLAG/ || u ~ /SCC CLOCK_ALIGNEDINSETRENDERGATEFLAG/) has_clear_gate = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GET_ENTRY_PTR=" has_get_entry_ptr
    print "HAS_TEST_FLAG=" has_test_flag
    print "HAS_GET_ANIM_PTR=" has_get_anim_ptr
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_APPEND=" has_append
    print "HAS_SET_GATE=" has_set_gate
    print "HAS_CLEAR_GATE=" has_clear_gate
    print "HAS_RETURN=" has_return
}
