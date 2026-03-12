BEGIN {
    has_entry = 0
    has_set_countdown = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQIFF_RUNCOPPERRISETRANSITION:/) has_entry = 1
    if (index(uline, "MOVE.W #15,COPPER_ANIMATIONLANE3_COUNTDOWN") == 1 ||
        index(uline, "MOVE.W #$F,COPPER_ANIMATIONLANE3_COUNTDOWN") == 1) has_set_countdown = 1
    if (index(uline, "BSR.W ESQIFF_RUNPENDINGCOPPERANIMATION") == 1) has_call = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SET_COUNTDOWN=" has_set_countdown
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}
