BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_finalize = 0
    has_mul = 0
    has_asr = 0
    has_control_test = 0
    has_findchar = 0
    has_add_bonus = 0
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
    uline = toupper(line)

    if (uline ~ /^DISPTEXT_COMPUTEVISIBLELINECOUNT:/) has_label = 1
    if (index(uline, "LINK.W A5,#-12") > 0) has_link = 1
    if (index(uline, "MOVEM.L D5-D7,-(A7)") > 0) has_save = 1
    if (index(uline, "BSR.W DISPTEXT_FINALIZELINETABLE") > 0) has_finalize = 1
    if (index(uline, "GROUP_AG_JMPTBL_MATH_MULU32") > 0) has_mul = 1
    if (index(uline, "ASR.L #2,D0") > 0) has_asr = 1
    if (index(uline, "TST.W DISPTEXT_CONTROLMARKERSENABLEDFLAG") > 0) has_control_test = 1
    if (index(uline, "GROUP_AI_JMPTBL_STR_FINDCHARPTR") > 0) has_findchar = 1
    if (index(uline, "ADDQ.L #2,D5") > 0) has_add_bonus = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_FINALIZE=" has_finalize
    print "HAS_MUL=" has_mul
    print "HAS_ASR=" has_asr
    print "HAS_CONTROL_TEST=" has_control_test
    print "HAS_FINDCHAR=" has_findchar
    print "HAS_ADD_BONUS=" has_add_bonus
    print "HAS_RETURN=" has_return
}
