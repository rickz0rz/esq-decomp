function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    seen[tag] = 1
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)
    norm = uline
    gsub(/[^A-Z0-9]/, "", norm)

    if (uline ~ /^NEWGRID_SHOULDOPENEDITOR:/ || uline ~ /^NEWGRID_SHOULDOPENEDITO[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (uline ~ /^MOVEQ(\.L)? #\$?0,D[07]$/ || uline ~ /^CLR\.L D[07]$/) {
        mark("INIT_ZERO")
    }

    if ((uline ~ /^TST\.L D[037]$/ || uline ~ /^MOVE\.L .*ENTRYVIEW/ || uline ~ /^CMP\.L #0,.*ENTRYVIEW/) && !("ENTRY_NULL_GUARD" in seen)) {
        mark("ENTRY_NULL_GUARD")
    }

    if (norm ~ /STRSKIPCLASS3CHARS/ && !("PRIMARY_SKIPCLASS3" in seen)) {
        mark("PRIMARY_SKIPCLASS3")
    } else if (norm ~ /STRSKIPCLASS3CHARS/ && !("SECONDARY_SKIPCLASS3" in seen)) {
        mark("SECONDARY_SKIPCLASS3")
    }

    if ((uline ~ /^TST\.L .*PRIMARYSCAN/ || uline ~ /^TST\.L -12\(A5\)$/ || uline ~ /^MOVE\.L A2,D1$/) &&
        !("PRIMARY_PTR_TEST" in seen)) {
        mark("PRIMARY_PTR_TEST")
    }

    if ((uline ~ /^TST\.B \(A0\)$/ || uline ~ /^TST\.B .*PRIMARYSCAN/ || uline ~ /^\*PRIMARYSCAN == 0$/) &&
        ("PRIMARY_PTR_TEST" in seen) && !("PRIMARY_CHAR_TEST" in seen)) {
        mark("PRIMARY_CHAR_TEST")
    }

    if ((uline ~ /^TST\.L D0$/ || uline ~ /^TST\.L .*SECONDARYSCAN/ || uline ~ /^CMP\.L #0,.*SECONDARYSCAN/) &&
        !("SECONDARY_PTR_TEST" in seen)) {
        mark("SECONDARY_PTR_TEST")
    }

    if ((uline ~ /^TST\.B \(A0\)$/ || uline ~ /^TST\.B .*SECONDARYSCAN/ || uline ~ /^\*SECONDARYSCAN == 0$/) &&
        ("SECONDARY_PTR_TEST" in seen) && !("SECONDARY_CHAR_TEST" in seen)) {
        mark("SECONDARY_CHAR_TEST")
    }

    if (uline ~ /^BTST #\$?5,27\(A3\)$/ || uline ~ /^BTST #\$?5,\$1B\(A3\)$/ || uline ~ /FLAGS27/ || uline ~ /0X20/) {
        mark("FLAGS27_BIT5_GATE")
    }

    if ((uline ~ /^MOVEQ(\.L)? #\$?1,D[07]$/ || uline ~ /SHOULDOPEN = 1/) &&
        !("SET_TRUE" in seen)) {
        mark("SET_TRUE")
    }

    if (("INIT_ZERO" in seen) || uline ~ /SHOULDOPEN = 0/) {
        mark("REJECT_FALSE")
    }

    if (uline ~ /^MOVE\.L D0,D7$/ || uline ~ /^MOVE\.L D7,D0$/ || uline ~ /^MOVE\.L .*SHOULDOPEN/ || uline ~ /^RETURN SHOULDOPEN;$/) {
        mark("STORE_RESULT")
    }

    if (uline == "RTS") {
        mark("RTS")
    }
}

END {
    order[1] = "ENTRY"
    order[2] = "INIT_ZERO"
    order[3] = "ENTRY_NULL_GUARD"
    order[4] = "PRIMARY_SKIPCLASS3"
    order[5] = "SECONDARY_SKIPCLASS3"
    order[6] = "PRIMARY_PTR_TEST"
    order[7] = "PRIMARY_CHAR_TEST"
    order[8] = "SECONDARY_PTR_TEST"
    order[9] = "SECONDARY_CHAR_TEST"
    order[10] = "FLAGS27_BIT5_GATE"
    order[11] = "SET_TRUE"
    order[12] = "REJECT_FALSE"
    order[13] = "STORE_RESULT"
    order[14] = "RTS"

    for (i = 1; i <= 14; ++i) {
        tag = order[i]
        print tag "=" ((tag in seen) ? 1 : 0)
    }
}
