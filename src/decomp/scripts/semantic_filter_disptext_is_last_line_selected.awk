BEGIN {
    has_label = 0
    has_save = 0
    has_finalize = 0
    has_target_read = 0
    has_sub1 = 0
    has_current_read = 0
    has_compare = 0
    has_boolize_seq = 0
    has_boolize_neg = 0
    has_boolize_extw = 0
    has_boolize_extl = 0
    has_result_move = 0
    has_restore = 0
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

    if (uline ~ /^DISPTEXT_ISLASTLINESELECTED:/) has_label = 1
    if (index(uline, "MOVE.L D2,-(A7)") > 0) has_save = 1
    if (index(uline, "BSR.W DISPTEXT_FINALIZELINETABLE") > 0) has_finalize = 1
    if (index(uline, "MOVE.W DISPTEXT_TARGETLINEINDEX,D0") > 0) has_target_read = 1
    if (index(uline, "SUBQ.L #1,D0") > 0) has_sub1 = 1
    if (index(uline, "MOVE.W DISPTEXT_CURRENTLINEINDEX,D1") > 0) has_current_read = 1
    if (index(uline, "CMP.L D0,D1") > 0) has_compare = 1
    if (index(uline, "SEQ D2") > 0) has_boolize_seq = 1
    if (index(uline, "NEG.B D2") > 0) has_boolize_neg = 1
    if (index(uline, "EXT.W D2") > 0) has_boolize_extw = 1
    if (index(uline, "EXT.L D2") > 0) has_boolize_extl = 1
    if (index(uline, "MOVE.L D2,D0") > 0) has_result_move = 1
    if (index(uline, "MOVE.L (A7)+,D2") > 0) has_restore = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_FINALIZE=" has_finalize
    print "HAS_TARGET_READ=" has_target_read
    print "HAS_SUB1=" has_sub1
    print "HAS_CURRENT_READ=" has_current_read
    print "HAS_COMPARE=" has_compare
    print "HAS_BOOLIZE_SEQ=" has_boolize_seq
    print "HAS_BOOLIZE_NEG=" has_boolize_neg
    print "HAS_BOOLIZE_EXTW=" has_boolize_extw
    print "HAS_BOOLIZE_EXTL=" has_boolize_extl
    print "HAS_RESULT_MOVE=" has_result_move
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
