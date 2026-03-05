BEGIN {
    has_entry = 0
    has_nul_test = 0
    has_cursor_inc = 0
    has_limit_cmp = 0
    has_emit_call = 0
    has_loop_back = 0
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

    if (u ~ /^LADFUNC2_EMITESCAPEDSTRINGWITHLIMIT:/ || u ~ /^LADFUNC2_EMITESCAPEDSTRINGWITHLI[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^TST\.B \(A[0-7]\)$/ || u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^TST\.B \$0\(A[0-7]\)$/) has_nul_test = 1
    if (u ~ /^ADDQ\.[LW] #\$1,D[0-7]$/ || u ~ /^ADDQ\.[LW] #1,D[0-7]$/ || u ~ /^ADDQ\.[LW] #\$1,\(A[0-7]\)$/ || u ~ /^ADDQ\.[LW] #1,\(A[0-7]\)$/) has_cursor_inc = 1
    if (u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^CMP\.[LW] \(A[0-7]\),D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_limit_cmp = 1
    if (index(u, "EMITESCAPEDCHARTOSCRATCH") > 0 || index(u, "EMITESCAPEDCHAR") > 0) has_emit_call = 1
    if (u ~ /^BRA\.[SWB] LADFUNC2_EMITESCAPEDSTRINGWITHLIMIT$/ || u ~ /^BRA\.[SWB] ___LADFUNC2_EMITESCAPEDSTRINGWITHLI/) has_loop_back = 1
    if (u ~ /^BRA\.[SWB] LADFUNC2_EMITESCAPEDSTRINGWITHLIMIT_RETURN$/ || u ~ /^BGE\.[SWB] LADFUNC2_EMITESCAPEDSTRINGWITHLIMIT_RETURN$/ || u ~ /^BEQ\.[SWB] LADFUNC2_EMITESCAPEDSTRINGWITHLIMIT_RETURN$/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NUL_TEST=" has_nul_test
    print "HAS_CURSOR_INC=" has_cursor_inc
    print "HAS_LIMIT_CMP=" has_limit_cmp
    print "HAS_EMIT_CALL=" has_emit_call
    print "HAS_LOOP_BACK=" has_loop_back
    print "HAS_RETURN=" has_return
}
