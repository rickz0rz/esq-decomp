BEGIN {
    step_count = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!(tag in seen)) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ESQ_WRITEDECFIXEDWIDTH[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (uline ~ /^ADDA?\.[LW] D[0-7],A[0-7]$/) {
        mark("ADVANCE_TO_END")
    }

    if (uline ~ /^CLR\.B \(A[0-7]\)$/ || uline ~ /^MOVE\.B #\$?0,\(A[0-7]\)$/) {
        mark("WRITE_NULL_TERMINATOR")
    }

    if (uline ~ /^SUBQ\.[BW] #\$?1,D[0-7]$/ || uline ~ /^SUBQ\.[LW] #\$?1,D[0-7]$/) {
        mark("INIT_OR_UPDATE_COUNTER")
    }

    if (uline ~ /^DIVS(\.W)? /) {
        mark("DIVIDE_BY_TEN")
    }

    if (uline ~ /^SWAP D[0-7]$/ || uline ~ /^MOVE\.W D[0-7],\$[0-9A-F]+\((A|D)[0-7]\)$/) {
        mark("CAPTURE_REMAINDER")
    }

    if (uline ~ /^MOVE\.B D[0-7],-\(A[0-7]\)$/ || uline ~ /^SUBQ\.[LW] #\$?1,A[0-7]$/) {
        mark("STEP_BACK_OUTPUT")
    }

    if (uline ~ /#\$?30/ || uline ~ /#'0'/) {
        mark("ADD_ASCII_ZERO")
    }

    if (uline ~ /^DBF D[0-7],/ || uline ~ /^TST\.[BW] D[0-7]$/ || uline ~ /^BNE\./ || uline ~ /^BNE /) {
        mark("LOOP_CONTROL")
    }

    if (uline == "RTS") {
        mark("RETURN")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
