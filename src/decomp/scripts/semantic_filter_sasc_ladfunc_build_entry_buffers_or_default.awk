BEGIN {
    has_entry = 0
    has_ptr_index = 0
    has_default_branch = 0
    has_mul40 = 0
    has_fill_text = 0
    has_compose_call = 0
    has_fill_attr = 0
    has_copy_text = 0
    has_copy_attr = 0
    has_reflow_call = 0
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

    if (u ~ /^LADFUNC_BUILDENTRYBUFFERSORDEFAULT:/ || u ~ /^LADFUNC_BUILDENTRYBUFFERSORD[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0 || u ~ /^ASL\.L #2,D[0-7]$/ || u ~ /^ASL\.L #\$2,D[0-7]$/) has_ptr_index = 1

    if (u ~ /^TST\.L 6\(A[0-7]\)$/ || u ~ /^BEQ\.[SWB] /) has_default_branch = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || u ~ /^MOVEQ(\.L)? #40,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$28,D[0-7]$/) has_mul40 = 1

    if ((u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^MOVE\.B #\$20,\$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.B #32,\$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVEQ(\.L)? #32,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/) && !has_fill_text) has_fill_text = 1
    if (index(u, "LADFUNC_COMPOSEPACKEDPENBYTE") > 0) has_compose_call = 1
    if ((u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^MOVE\.B D[0-7],\$0\(A[0-7],D[0-7]\.L\)$/) && has_compose_call) has_fill_attr = 1

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^BNE\.[SWB] .*COPY_TEXT/) has_copy_text = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^SUBQ\.L #1,D[0-7]$/) has_copy_attr = 1

    if (index(u, "LADFUNC_REFLOWENTRYBUFFERS") > 0) has_reflow_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_DEFAULT_BRANCH=" has_default_branch
    print "HAS_MUL40=" has_mul40
    print "HAS_FILL_TEXT=" has_fill_text
    print "HAS_COMPOSE_CALL=" has_compose_call
    print "HAS_FILL_ATTR=" has_fill_attr
    print "HAS_COPY_TEXT=" has_copy_text
    print "HAS_COPY_ATTR=" has_copy_attr
    print "HAS_REFLOW_CALL=" has_reflow_call
    print "HAS_RETURN=" has_return
}
