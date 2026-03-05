BEGIN {
    has_entry = 0
    has_index_guard = 0
    has_span_guard = 0
    has_table_ref = 0
    has_mulu_call = 0
    has_div_call = 0
    has_result_store = 0
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

    if (u ~ /^GCOMMAND_COMPUTEPRESETINCREMENT:/) has_entry = 1
    if (u ~ /^TST\.[LW] D[0-7]$/ || u ~ /^BMI\.[A-Z]+ / || u ~ /^MOVEQ(\.L)? #\$10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #16,D[0-7]$/) has_index_guard = 1
    if (u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #4,D[0-7]$/ || u ~ /^BLE\.[A-Z]+ /) has_span_guard = 1
    if (index(u, "GCOMMAND_DEFAULTPRESETTABLE") > 0) has_table_ref = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || index(u, "MULU32") > 0) has_mulu_call = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_DIVS32") > 0 || index(u, "DIVS32") > 0) has_div_call = 1
    if (u ~ /^MOVE\.L D[0-7],-[0-9]+\((A5)\)$/ || u ~ /^MOVE\.L D[0-7],D[0-7]$/) has_result_store = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_GUARD=" has_index_guard
    print "HAS_SPAN_GUARD=" has_span_guard
    print "HAS_TABLE_REF=" has_table_ref
    print "HAS_MULU_CALL=" has_mulu_call
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_RESULT_STORE=" has_result_store
    print "HAS_RETURN=" has_return
}
