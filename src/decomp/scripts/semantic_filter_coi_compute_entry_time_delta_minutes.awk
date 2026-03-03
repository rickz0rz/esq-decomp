BEGIN {
    has_label = 0
    has_save = 0
    has_load_a3 = 0
    has_load_d7 = 0
    has_macro_a3 = 0
    has_macro_d7 = 0
    has_early_return1 = 0
    has_early_return2 = 0
    has_scan = 0
    has_wildcard_call = 0
    has_aux_call = 0
    has_offset_call = 0
    has_clock_path = 0
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

    if (uline ~ /^COI_COMPUTEENTRYTIMEDELTAMINUTES:/) has_label = 1
    if (index(uline, "MOVEM.L D5-D7/A3,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVEA.L 20(A7),A3") > 0) has_load_a3 = 1
    if (index(uline, "MOVE.W 26(A7),D7") > 0) has_load_d7 = 1
    if (index(uline, "USESTACKLONG MOVEA.L,1,A3") > 0) has_macro_a3 = 1
    if (index(uline, "USESTACKWORD MOVE.W,5,D7") > 0) has_macro_d7 = 1
    if (index(uline, "BLE.W COI_COMPUTEENTRYTIMEDELTAMINUTES_RETURN") > 0) has_early_return1 = 1
    if (index(uline, "BGE.W COI_COMPUTEENTRYTIMEDELTAMINUTES_RETURN") > 0) has_early_return2 = 1
    if (uline ~ /^\.LAB_0365:/) has_scan = 1
    if (index(uline, "GROUP_AE_JMPTBL_TLIBA_FINDFIRSTWILDCARDMATCHINDEX") > 0) has_wildcard_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_ESQDISP_GETENTRYAUXPOINTERBYMODE") > 0) has_aux_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_TEXTDISP_COMPUTETIMEOFFSET") > 0) has_offset_call = 1
    if (index(uline, "MOVE.W CLOCK_HALFHOURSLOTINDEX,D0") > 0) has_clock_path = 1
    if (index(uline, "COI_COMPUTEENTRYTIMEDELTAMINUTES_RETURN") > 0) has_return_branch = 1
}

END {
    eff_load_a3 = has_load_a3 || has_macro_a3
    eff_load_d7 = has_load_d7 || has_macro_d7

    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_LOAD_A3=" eff_load_a3
    print "HAS_LOAD_D7=" eff_load_d7
    print "HAS_EARLY_RETURN1=" has_early_return1
    print "HAS_EARLY_RETURN2=" has_early_return2
    print "HAS_SCAN=" has_scan
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_AUX_CALL=" has_aux_call
    print "HAS_OFFSET_CALL=" has_offset_call
    print "HAS_CLOCK_PATH=" has_clock_path
    print "HAS_RETURN_BRANCH=" has_return_branch
}
