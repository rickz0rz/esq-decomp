BEGIN {
    has_call = 0
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

    if (line ~ /JSR GCOMMAND_ProcessCtrlCommand/ || line ~ /CALL GCOMMAND_ProcessCtrlCommand/) has_call = 1
    if (toupper(line) == "RTS") has_rts = 1
}

END {
    print "HAS_GCOMMAND_CALL=" has_call
    print "HAS_RTS=" has_rts
}

