BEGIN {
    has_label = 0
    has_finalize = 0
    has_clear = 0
    has_read = 0
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

    if (uline ~ /^DISPTEXT_GETTOTALLINECOUNT:/) has_label = 1
    if (index(uline, "BSR.W DISPTEXT_FINALIZELINETABLE") > 0) has_finalize = 1
    if (index(uline, "MOVEQ #0,D0") > 0) has_clear = 1
    if (index(uline, "MOVE.W DISPTEXT_TARGETLINEINDEX,D0") > 0) has_read = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_FINALIZE=" has_finalize
    print "HAS_CLEAR=" has_clear
    print "HAS_READ=" has_read
    print "HAS_RETURN=" has_return
}
