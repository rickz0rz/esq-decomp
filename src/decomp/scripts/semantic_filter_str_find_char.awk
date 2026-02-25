BEGIN {
    has_prologue = 0
    has_ptr_load = 0
    has_target_load = 0
    has_byte_read = 0
    has_compare = 0
    has_match_return_ptr = 0
    has_advance = 0
    has_nul_test = 0
    has_not_found_zero = 0
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

    if (u ~ /^(MOVEM\.L|LINK\.W)/ || u ~ /^MOVE\.L D[0-7],-\((A7|SP)\)$/) has_prologue = 1
    if (u ~ /^MOVEA?\.L [0-9]+\((A7|SP)\),A[0-7]$/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),A[0-7]$/) has_ptr_load = 1
    if (u ~ /^MOVE\.L [0-9]+\((A7|SP)\),(D|A)[0-7]$/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),(D|A)[0-7]$/) has_target_load = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+?,D[0-7]$/ || u ~ /^MOVEQ #0,D[0-7]$/) has_byte_read = 1
    if (u ~ /^CMP\.(L|B) (D|A)[0-7],(D|A)[0-7]$/ || u ~ /^CMP\.(L|B) D[0-7],\(A[0-7]\)$/ || u ~ /^CMPI\.B #0,D[0-7]$/) has_compare = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/) has_match_return_ptr = 1
    if (u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_advance = 1
    if (u ~ /^TST\.B D[0-7]$/ || u ~ /^TST\.B \(A[0-7]\)$/) has_nul_test = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_not_found_zero = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_PTR_LOAD=" has_ptr_load
    print "HAS_TARGET_LOAD=" has_target_load
    print "HAS_BYTE_READ=" has_byte_read
    print "HAS_COMPARE=" has_compare
    print "HAS_MATCH_RETURN_PTR=" has_match_return_ptr
    print "HAS_ADVANCE=" has_advance
    print "HAS_NUL_TEST=" has_nul_test
    print "HAS_NOT_FOUND_ZERO=" has_not_found_zero
    print "HAS_RTS=" has_rts
}
