BEGIN {
    has_prologue = 0
    has_input_guard = 0
    has_charset_guard = 0
    has_compare = 0
    has_match_return_ptr = 0
    has_charset_advance = 0
    has_input_advance = 0
    has_not_found_zero = 0
    has_rts = 0
    postinc_loads = 0
    jeq_count = 0
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

    if (u ~ /^(LINK\.W|MOVEM\.L)/ || u ~ /^MOVE\.L D[0-7],-\((A7|SP)\)$/) has_prologue = 1
    if (u ~ /^TST\.B \(A[0-7]\)$/) {
        if (!has_input_guard) {
            has_input_guard = 1
        } else {
            has_charset_guard = 1
        }
    }
    if (u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) {
        postinc_loads++
        has_charset_advance = 1
        has_input_advance = 1
    }
    if (u ~ /^(BEQ|BEQ\.S|JEQ|JEQ\.S) /) jeq_count++
    if (u ~ /^CMP\.B \(A[0-7]\),D[0-7]$/ || u ~ /^CMP\.B D[0-7],\(A[0-7]\)$/ || u ~ /^CMP\.B \(A[0-7]\),\(A[0-7]\)$/ || u ~ /^CMP\.B D[0-7],D[0-7]$/) has_compare = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/) has_match_return_ptr = 1
    if (u ~ /^ADDQ\.L #1,-?[0-9]*\(A5\)$/ || u ~ /^ADDQ\.L #1,A[0-7]$/) {
        has_charset_advance = 1
    }
    if (u ~ /^ADDQ\.L #1,A[0-7]$/) has_input_advance = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_not_found_zero = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (postinc_loads >= 2 && jeq_count >= 2) {
        has_input_guard = 1
        has_charset_guard = 1
    }
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_INPUT_GUARD=" has_input_guard
    print "HAS_CHARSET_GUARD=" has_charset_guard
    print "HAS_COMPARE=" has_compare
    print "HAS_MATCH_RETURN_PTR=" has_match_return_ptr
    print "HAS_CHARSET_ADVANCE=" has_charset_advance
    print "HAS_INPUT_ADVANCE=" has_input_advance
    print "HAS_NOT_FOUND_ZERO=" has_not_found_zero
    print "HAS_RTS=" has_rts
}
