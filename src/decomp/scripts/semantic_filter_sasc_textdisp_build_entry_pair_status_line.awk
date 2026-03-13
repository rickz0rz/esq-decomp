BEGIN {
    has_entry = 0
    has_get_aux = 0
    has_get_entry = 0
    has_window_test = 0
    has_get_anim = 0
    has_append = 0
    has_build_aligned = 0
    has_highlight = 0
    has_return = 0
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
    u = toupper(line)

    if (u ~ /^TEXTDISP_BUILDENTRYPAIRSTATUSLINE:/ || u ~ /^TEXTDISP_BUILDENTRYPAIRSTATUSLI[A-Z0-9_]*:/ || u ~ /^TEXTDISP_BUILDENTRYPAIRSTATUSLIN[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAUXPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAUXP") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAU") > 0) has_get_aux = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOI") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPO") > 0) has_get_entry = 1
    if (index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHINTIMEWINDOW") > 0 || index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHIN") > 0 || index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHI") > 0) has_window_test = 1
    if (index(u, "TLIBA1_JMPTBL_COI_GETANIMFIELDPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_COI_GETANIMFIELDPOI") > 0 || index(u, "TLIBA1_JMPTBL_COI_GETANIMFIELDPO") > 0) has_get_anim = 1
    if (index(u, "STRING_APPENDATNULL") > 0) has_append = 1
    if (index(u, "TEXTDISP_JMPTBL_CLEANUP_BUILDALIGNEDSTATUSLINE") > 0 || index(u, "TEXTDISP_JMPTBL_CLEANUP_BUILDALIG") > 0 || index(u, "TEXTDISP_JMPTBL_CLEANUP_BUILDALI") > 0 || index(u, "CLEANUP_BUILDALIGNEDSTATUSLINE") > 0) has_build_aligned = 1
    if (index(u, "SCRIPT_SETUPHIGHLIGHTEFFECT") > 0 || index(u, "SCRIPT_SETUPHIGHLIGHTEF") > 0) has_highlight = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET_AUX=" has_get_aux
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_WINDOW_TEST=" has_window_test
    print "HAS_GET_ANIM=" has_get_anim
    print "HAS_APPEND=" has_append
    print "HAS_BUILD_ALIGNED=" has_build_aligned
    print "HAS_HIGHLIGHT=" has_highlight
    print "HAS_RETURN=" has_return
}
