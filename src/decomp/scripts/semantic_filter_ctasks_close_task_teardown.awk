BEGIN {
    has_label = 0
    has_save = 0
    has_close_call = 0
    has_forbid_call = 0
    has_dealloc_call = 0
    has_done_flag = 0
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

    if (uline ~ /^CTASKS_CLOSETASKTEARDOWN:/) has_label = 1
    if (index(uline, "MOVE.L A4,-(A7)") > 0) has_save = 1
    if (index(uline, "_LVOCLOSE(A6)") > 0) has_close_call = 1
    if (index(uline, "_LVOFORBID(A6)") > 0) has_forbid_call = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0) has_dealloc_call = 1
    if (index(uline, "MOVE.W #1,CTASKS_CLOSETASKCOMPLETIONFLAG") > 0) has_done_flag = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_FORBID_CALL=" has_forbid_call
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_DONE_FLAG=" has_done_flag
    print "HAS_RETURN=" has_return
}
