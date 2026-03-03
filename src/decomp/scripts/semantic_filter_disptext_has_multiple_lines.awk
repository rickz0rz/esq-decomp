BEGIN {
    has_label = 0
    has_finalize = 0
    has_current_read = 0
    has_current_guard = 0
    has_target_read = 0
    has_compare = 0
    has_target_guard = 0
    has_true_set = 0
    has_false_set = 0
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

    if (uline ~ /^DISPTEXT_HASMULTIPLELINES:/) has_label = 1
    if (index(uline, "BSR.W DISPTEXT_FINALIZELINETABLE") > 0) has_finalize = 1
    if (index(uline, "MOVE.W DISPTEXT_CURRENTLINEINDEX,D0") > 0) has_current_read = 1
    if (index(uline, "BNE.S") > 0 && index(uline, "RETURN_FALSE") > 0) has_current_guard = 1
    if (index(uline, "MOVE.W DISPTEXT_TARGETLINEINDEX,D0") > 0) has_target_read = 1
    if (index(uline, "CMP.W D1,D0") > 0) has_compare = 1
    if (index(uline, "BLS.S") > 0 && index(uline, "RETURN_FALSE") > 0) has_target_guard = 1
    if (index(uline, "MOVEQ #1,D0") > 0) has_true_set = 1
    if (index(uline, "MOVEQ #0,D0") > 0) has_false_set = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_FINALIZE=" has_finalize
    print "HAS_CURRENT_READ=" has_current_read
    print "HAS_CURRENT_GUARD=" has_current_guard
    print "HAS_TARGET_READ=" has_target_read
    print "HAS_COMPARE=" has_compare
    print "HAS_TARGET_GUARD=" has_target_guard
    print "HAS_TRUE_SET=" has_true_set
    print "HAS_FALSE_SET=" has_false_set
    print "HAS_RETURN=" has_return
}
