BEGIN {
    has_entry = 0
    has_clear_state = 0
    has_diag_guard = 0
    has_loop_bound = 0
    has_ptr_index = 0
    has_range_checks = 0
    has_textptr_check = 0
    has_set_highlight = 0
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

    if (u ~ /^LADFUNC_UPDATEHIGHLIGHTSTATE:/ || u ~ /^LADFUNC_UPDATEHIGHLIGHTSTATE[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "WDISP_HIGHLIGHTACTIVE") > 0 || index(u, "WDISP_HIGHLIGHTINDEX") > 0 || u ~ /^CLR\.W /) has_clear_state = 1
    if (index(u, "ED_DIAGTEXTMODECHAR") > 0 || u ~ /^MOVEQ(\.L)? #78,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$4E,D[0-7]$/ || u ~ /^CMP\.B /) has_diag_guard = 1
    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_loop_bound = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0 || u ~ /^ASL\.L #2,D[0-7]$/ || u ~ /^ASL\.L #\$2,D[0-7]$/) has_ptr_index = 1
    if ((index(u, "CLOCK_HALFHOURSLOTINDEX") > 0 || u ~ /^CMP\.W D[0-7],D[0-7]$/) && (u ~ /^BGT\.[SWB] / || u ~ /^BLT\.[SWB] / || u ~ /^CMP\.W /)) has_range_checks = 1
    if (u ~ /^TST\.L [0-9]+\([A0-7]\)$/ || u ~ /^BEQ\.[SWB] /) has_textptr_check = 1
    if (u ~ /^MOVEQ(\.L)? #1,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$1,D[0-7]$/ || index(u, "WDISP_HIGHLIGHTACTIVE") > 0) has_set_highlight = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLEAR_STATE=" has_clear_state
    print "HAS_DIAG_GUARD=" has_diag_guard
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_RANGE_CHECKS=" has_range_checks
    print "HAS_TEXTPTR_CHECK=" has_textptr_check
    print "HAS_SET_HIGHLIGHT=" has_set_highlight
    print "HAS_RETURN=" has_return
}
