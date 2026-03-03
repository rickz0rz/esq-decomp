BEGIN {
    has_null_check = 0
    has_star_check = 0
    has_qmark_check = 0
    has_sc_end_check = 0
    has_pc_end_check = 0
    has_match_ret0 = 0
    has_mismatch_ret1 = 0
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

    if (u ~ /CMPA\.L #0,A[0-7]/ || u ~ /^TST\.L A[0-7]/ || u ~ /^CMPI\.L #0,A[0-7]/ || u ~ /^MOVE\.L A[0-7],D0$/) has_null_check = 1
    if (u ~ /#'\*'/ || u ~ /#42/) has_star_check = 1
    if (u ~ /#'\?'/ || u ~ /#63/) has_qmark_check = 1
    if (u ~ /TST\.B D[0-7]/ || u ~ /CMP\.B #0,D[0-7]/ || u ~ /CMPI\.B #0,D[0-7]/) has_sc_end_check = 1
    if (u ~ /TST\.B D[0-7]/ || u ~ /CMP\.B #0,D[0-7]/ || u ~ /CMPI\.B #0,D[0-7]/) has_pc_end_check = 1
    if (u ~ /MOVE\.B #0,D0/ || u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0/ || u ~ /^CLR\.B D0/ || u ~ /^SNE D0$/ || u ~ /^NEG\.L D0$/) has_match_ret0 = 1
    if (u ~ /MOVE\.B #\$?1,D0/ || u ~ /MOVEQ #1,D0/) has_mismatch_ret1 = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_NULL_CHECK=" has_null_check
    print "HAS_STAR_CHECK=" has_star_check
    print "HAS_QMARK_CHECK=" has_qmark_check
    print "HAS_SC_END_CHECK=" has_sc_end_check
    print "HAS_PC_END_CHECK=" has_pc_end_check
    print "HAS_MATCH_RET0=" has_match_ret0
    print "HAS_MISMATCH_RET1=" has_mismatch_ret1
    print "HAS_RTS=" has_rts
}
