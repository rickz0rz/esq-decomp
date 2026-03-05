BEGIN {
    has_entry = 0
    has_scan_len = 0
    has_alloc_text = 0
    has_alloc_attr = 0
    has_copy_text = 0
    has_copy_attr = 0
    has_row_limit = 0
    has_div_call = 0
    has_emit_spaces = 0
    has_emit_chars = 0
    has_terminate = 0
    has_free_text = 0
    has_free_attr = 0
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

    if (u ~ /^LADFUNC_REFLOWENTRYBUFFERS:/ || u ~ /^LADFUNC_REFLOWENTRYBUFFERS[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^TST\.B \(A[0-7]\)\+?$/ || u ~ /^BNE\.[SWB] / || u ~ /^SUBA?\.L A[0-7],A[0-7]$/) has_scan_len = 1

    if (index(u, "GLOBAL_STR_LADFUNC_C_20") > 0 || u ~ /1025/ || u ~ /\$401/) has_alloc_text = 1
    if (index(u, "GLOBAL_STR_LADFUNC_C_21") > 0 || u ~ /1026/ || u ~ /\$402/) has_alloc_attr = 1

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.L\),\$0\(A[0-7],D[0-7]\.L\)$/) {
        has_copy_text = 1
        has_copy_attr = 1
    }

    if (index(u, "ED_TEXTLIMIT") > 0 || (u ~ /^CMP\.L / && index(u, "ED_TEXTLIMIT") > 0)) has_row_limit = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_DIVS32") > 0 || index(u, "NEWGRID_JMPTBL_MATH_DIVS") > 0) has_div_call = 1

    if (u ~ /^MOVE\.B #\$20,/ || u ~ /^MOVE\.B #32,/) has_emit_spaces = 1
    if (u ~ /^MOVE\.B -[0-9]+\(A5,D[0-7]\.L\),0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.B \$[0-9A-F]+\(A7,D[0-7]\.L\),\$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.B D[0-7],0\(A[0-7],D[0-7]\.L\)$/) has_emit_chars = 1

    if (u ~ /^CLR\.B 0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^CLR\.B \$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^CLR\.B \(A[0-7]\)$/) has_terminate = 1

    if (index(u, "GLOBAL_STR_LADFUNC_C_22") > 0 || u ~ /1146/ || u ~ /\$47A/) has_free_text = 1
    if (index(u, "GLOBAL_STR_LADFUNC_C_23") > 0 || u ~ /1148/ || u ~ /\$47C/) has_free_attr = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SCAN_LEN=" has_scan_len
    print "HAS_ALLOC_TEXT=" has_alloc_text
    print "HAS_ALLOC_ATTR=" has_alloc_attr
    print "HAS_COPY_TEXT=" has_copy_text
    print "HAS_COPY_ATTR=" has_copy_attr
    print "HAS_ROW_LIMIT=" has_row_limit
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_EMIT_SPACES=" has_emit_spaces
    print "HAS_EMIT_CHARS=" has_emit_chars
    print "HAS_TERMINATE=" has_terminate
    print "HAS_FREE_TEXT=" has_free_text
    print "HAS_FREE_ATTR=" has_free_attr
    print "HAS_RETURN=" has_return
}
