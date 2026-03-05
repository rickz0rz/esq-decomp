BEGIN {
    has_entry = 0
    has_set_minus_one = 0
    has_loop_bound_98 = 0
    has_buffer_ref = 0
    has_clear_store = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_CLEARBANNERQUEUE:/) has_entry = 1
    if ((index(u, "ESQPARS2_BANNERQUEUEATTENTIONCOUNTDOWN") > 0 || index(u, "ESQPARS2_BANNERQUEUEATTENTIONCOU") > 0) && (u ~ /^MOVE\.W / || u ~ /^MOVEQ(\.L)? #\-1,D[0-7]$/ || u ~ /^MOVE\.W #\$FFFFFFFF,/)) has_set_minus_one = 1
    if (u ~ /^MOVEQ(\.L)? #\$62,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #98,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_loop_bound_98 = 1
    if (index(u, "ESQPARS2_BANNERQUEUEBUFFER") > 0) has_buffer_ref = 1
    if (u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^CLR\.B \$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$0,\(A[0-7]\)$/) has_clear_store = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SET_MINUS_ONE=" has_set_minus_one
    print "HAS_LOOP_BOUND_98=" has_loop_bound_98
    print "HAS_BUFFER_REF=" has_buffer_ref
    print "HAS_CLEAR_STORE=" has_clear_store
    print "HAS_RETURN=" has_return
}
