BEGIN {
    has_label = 0
    has_save = 0
    has_arg = 0
    has_guard = 0
    has_zero_head = 0
    has_replace_call = 0
    has_write_tail = 0
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

    if (uline ~ /^COI_CLEARANIMOBJECTSTRINGS:/) has_label = 1
    if (index(uline, "MOVEM.L A2-A3,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVEA.L 12(A7),A3") > 0) has_arg = 1
    if (index(uline, "COI_CLEARANIMOBJECTSTRINGS_RETURN") > 0) has_guard = 1
    if (index(uline, "MOVE.B D0,(A2)") > 0) has_zero_head = 1
    if (index(uline, "GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_call = 1
    if (index(uline, "CLR.L 32(A2)") > 0) has_write_tail = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_ARG=" has_arg
    print "HAS_GUARD=" has_guard
    print "HAS_ZERO_HEAD=" has_zero_head
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_WRITE_TAIL=" has_write_tail
}
