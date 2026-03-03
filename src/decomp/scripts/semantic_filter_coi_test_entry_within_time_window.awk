BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_init = 0
    has_guard = 0
    has_offset_call = 0
    has_mulu_call = 0
    has_flag_branch = 0
    has_delta_call = 0
    has_compare_block = 0
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

    if (uline ~ /^COI_TESTENTRYWITHINTIMEWINDOW:/) has_label = 1
    if (index(uline, "LINK.W A5,#-24") > 0) has_link = 1
    if (index(uline, "MOVEM.L D5-D7/A2-A3,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVE.L D0,-4(A5)") > 0) has_init = 1
    if (uline ~ /^\.LAB_0378:/) has_guard = 1
    if (index(uline, "GROUP_AE_JMPTBL_TEXTDISP_COMPUTETIMEOFFSET") > 0) has_offset_call = 1
    if (index(uline, "GROUP_AG_JMPTBL_MATH_MULU32") > 0) has_mulu_call = 1
    if (index(uline, "BTST #4,27(A3)") > 0) has_flag_branch = 1
    if (index(uline, "BSR.W COI_COMPUTEENTRYTIMEDELTAMINUTES") > 0) has_delta_call = 1
    if (uline ~ /^\.LAB_0376:/) has_compare_block = 1
    if (index(uline, "COI_TESTENTRYWITHINTIMEWINDOW_RETURN") > 0) has_return_branch = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_INIT=" has_init
    print "HAS_GUARD=" has_guard
    print "HAS_OFFSET_CALL=" has_offset_call
    print "HAS_MULU_CALL=" has_mulu_call
    print "HAS_FLAG_BRANCH=" has_flag_branch
    print "HAS_DELTA_CALL=" has_delta_call
    print "HAS_COMPARE_BLOCK=" has_compare_block
    print "HAS_RETURN_BRANCH=" has_return_branch
}
