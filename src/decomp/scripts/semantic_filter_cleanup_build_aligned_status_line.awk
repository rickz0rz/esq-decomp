BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_get_entry_ptr = 0
    has_test_flag = 0
    has_get_anim_ptr = 0
    has_sprintf = 0
    has_append = 0
    has_format_tokens = 0
    has_set_gate = 0
    has_clear_gate = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_BUILDALIGNEDSTATUSLINE:/) has_label = 1
    if (uline ~ /LINK.W A5,#-32/) has_link = 1
    if (uline ~ /MOVEM.L D5-D7\/A3,-\(A7\)/) has_save = 1
    if (uline ~ /GROUP_AE_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE/) has_get_entry_ptr = 1
    if (uline ~ /CLEANUP_TESTENTRYFLAGYANDBIT1/) has_test_flag = 1
    if (uline ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_anim_ptr = 1
    if (uline ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/) has_sprintf = 1
    if (uline ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/) has_append = 1
    if (uline ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/) has_format_tokens = 1
    if (uline ~ /CLOCK_ALIGNEDINSETRENDERGATEFLAG/ && uline ~ /#\$1/) has_set_gate = 1
    if (uline ~ /CLR.B CLOCK_ALIGNEDINSETRENDERGATEFLAG/) has_clear_gate = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7\/A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_GET_ENTRY_PTR=" has_get_entry_ptr
    print "HAS_TEST_FLAG=" has_test_flag
    print "HAS_GET_ANIM_PTR=" has_get_anim_ptr
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_APPEND=" has_append
    print "HAS_FORMAT_TOKENS=" has_format_tokens
    print "HAS_SET_GATE=" has_set_gate
    print "HAS_CLEAR_GATE=" has_clear_gate
    print "HAS_RESTORE=" has_restore
}
