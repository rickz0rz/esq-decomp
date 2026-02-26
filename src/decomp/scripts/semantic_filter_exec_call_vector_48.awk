BEGIN {
    has_inputdev_base = 0
    has_a0_flow = 0
    has_a1_flow = 0
    has_d1_flow = 0
    has_a2_flow = 0
    has_call = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (u ~ /INPUTDEVICE_LIBRARYBASEFROMCONSOLEIO/ || u ~ /^MOVEA\.L .*A6$/) has_inputdev_base = 1
    if (u ~ /A0/) has_a0_flow = 1
    if (u ~ /A1/) has_a1_flow = 1
    if (u ~ /D1/) has_d1_flow = 1
    if (u ~ /A2/) has_a2_flow = 1
    if (u ~ /JSR .*LVOEXECPRIVATE3/) has_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_INPUTDEV_BASE=" has_inputdev_base
    print "HAS_A0_FLOW=" has_a0_flow
    print "HAS_A1_FLOW=" has_a1_flow
    print "HAS_D1_FLOW=" has_d1_flow
    print "HAS_A2_FLOW=" has_a2_flow
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}
