BEGIN {
    has_entry = 0
    has_loop_bound = 0
    has_ptr_index = 0
    has_entry_zero_fields = 0
    has_global_zeroes = 0
    has_scroll_limit_calc = 0
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

    if (u ~ /^LADFUNC_CLEARBANNERRECTENTRIES:/ || u ~ /^LADFUNC_CLEARBANNERRECTENTR[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[WL] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_loop_bound = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0 || u ~ /^ASL\.L #2,D[0-7]$/ || u ~ /^ASL\.L #\$2,D[0-7]$/) has_ptr_index = 1

    if (u ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],2\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],4\(A[0-7]\)$/ || u ~ /^MOVE\.L A[0-7],6\(A[0-7]\)$/ || u ~ /^MOVE\.L A[0-7],10\(A[0-7]\)$/ || u ~ /^CLR\.W [0-9]*\(A[0-7]\)$/ || u ~ /^CLR\.L [0-9]*\(A[0-7]\)$/) has_entry_zero_fields = 1

    if (index(u, "LADFUNC_HIGHLIGHTCYCLECOUNTDOWN") > 0 || index(u, "LADFUNC_ENTRYCOUNT") > 0 || index(u, "LADFUNC_PARSEDENTRYCOUNT") > 0 || index(u, "WDISP_HIGHLIGHTACTIVE") > 0 || index(u, "WDISP_HIGHLIGHTINDEX") > 0) has_global_zeroes = 1

    if ((index(u, "ED_DIAGSCROLLSPEEDCHAR") > 0 || index(u, "ED_TEXTLIMIT") > 0) && (u ~ /^MOVEQ(\.L)? #48,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$30,D[0-7]$/ || u ~ /^SUB\.L D[0-7],D[0-7]$/)) has_scroll_limit_calc = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_ENTRY_ZERO_FIELDS=" has_entry_zero_fields
    print "HAS_GLOBAL_ZEROES=" has_global_zeroes
    print "HAS_SCROLL_LIMIT_CALC=" has_scroll_limit_calc
    print "HAS_RETURN=" has_return
}
