BEGIN {
    has_label = 0
    has_link = 0
    has_wait_spin = 0
    has_save_result = 0
    has_forbid = 0
    has_done_flag = 0
    has_dealloc = 0
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

    if (uline ~ /^CTASKS_IFFTASKCLEANUP:/) has_label = 1
    if (index(uline, "LINK.W A5,#-4") > 0) has_link = 1
    if (uline ~ /^\.WAIT_FOR_BRUSH:/) has_wait_spin = 1
    if (index(uline, "GROUP_AF_JMPTBL_GCOMMAND_SAVEBRUSHRESULT") > 0) has_save_result = 1
    if (index(uline, "_LVOFORBID(A6)") > 0) has_forbid = 1
    if (index(uline, "MOVE.W #1,CTASKS_IFFTASKDONEFLAG") > 0) has_done_flag = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0) has_dealloc = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_WAIT_SPIN=" has_wait_spin
    print "HAS_SAVE_RESULT=" has_save_result
    print "HAS_FORBID=" has_forbid
    print "HAS_DONE_FLAG=" has_done_flag
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RETURN=" has_return
}
