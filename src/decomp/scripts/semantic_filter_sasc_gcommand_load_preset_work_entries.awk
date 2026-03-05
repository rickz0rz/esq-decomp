BEGIN {
    has_entry = 0
    has_loop_bound = 0
    has_mul_call = 0
    has_index_load = 0
    has_span_or_base_load = 0
    has_init_call = 0
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

    if (u ~ /^GCOMMAND_LOADPRESETWORKENTRIES:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #4,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_loop_bound = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || index(u, "MULU32") > 0) has_mul_call = 1
    if (u ~ /^MOVE\.B [0-9]+\((A[0-7]),D[0-7]\.L\),D[0-7]$/ || u ~ /^MOVE\.B \$[0-9A-F]+\((A[0-7]),D[0-7]\.L\),D[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_index_load = 1
    if (u ~ /^MOVE\.L [0-9]+\((A[0-7])\),-\(A7\)$/ || u ~ /^MOVE\.L \$[0-9A-F]+\((A[0-7])\),D[0-7]$/ || u ~ /^MOVE\.L [0-9]+\((A[0-7]),D[0-7]\.L\),-\(A7\)$/ || u ~ /^MOVE\.L \$[0-9A-F]+\((A[0-7]),D[0-7]\.L\),D[0-7]$/) has_span_or_base_load = 1
    if (index(u, "GCOMMAND_INITPRESETWORKENTRY") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_init_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_MUL_CALL=" has_mul_call
    print "HAS_INDEX_LOAD=" has_index_load
    print "HAS_SPAN_OR_BASE_LOAD=" has_span_or_base_load
    print "HAS_INIT_CALL=" has_init_call
    print "HAS_RETURN=" has_return
}
