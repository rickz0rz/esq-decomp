BEGIN {
    has_entry = 0
    has_arg_load = 0
    has_null_guard = 0
    has_byte_load = 0
    has_emit_call = 0
    has_loop_back = 0
    has_return = 0
    emit_calls = 0
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

    if (u ~ /^LADFUNC2_EMITESCAPEDSTRINGTOSCRATCH:/ || u ~ /^LADFUNC2_EMITESCAPEDSTRINGTOSC[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEA?\.L [0-9]+\(A7\),A[0-7]$/ || u ~ /^MOVE\.L A[0-7],D[0-7]$/) has_arg_load = 1
    if (u ~ /^TST\.B \(A[0-7]\)$/ || u ~ /^BEQ\.[SWB] /) has_null_guard = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/ || u ~ /^MOVE\.B D[0-7],D[0-7]$/) has_byte_load = 1

    if (index(u, "LADFUNC2_EMITESCAPEDCHARTOSCRATCH") > 0 || index(u, "LADFUNC2_EMITESCAPEDCHAR") > 0) {
        has_emit_call = 1
        emit_calls += 1
    }

    if (u ~ /^BRA\.[SWB] LADFUNC2_EMITESCAPEDSTRINGTOSCRATCH$/ || u ~ /^BRA\.[SWB] \.LAB_/ || u ~ /^BRA\.[SWB] ___LADFUNC2_EMITESCAPEDSTRINGTOSC/) has_loop_back = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ARG_LOAD=" has_arg_load
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_BYTE_LOAD=" has_byte_load
    print "HAS_EMIT_CALL=" has_emit_call
    print "HAS_EMIT_CALLS_GE1=" (emit_calls >= 1 ? 1 : 0)
    print "HAS_LOOP_BACK=" has_loop_back
    print "HAS_RETURN=" has_return
}
