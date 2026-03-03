BEGIN {
    has_const_one = 0
    has_rts = 0
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

    if (uline ~ /#1, ?D0/) has_const_one = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_CONST_ONE=" has_const_one
    print "HAS_RTS=" has_rts
}
