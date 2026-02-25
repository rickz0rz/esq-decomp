BEGIN {
    has_prologue = 0
    has_limit_guard = 0
    has_stream_count_decrement = 0
    has_refill_call = 0
    has_readptr_byte_load = 0
    has_eof_check = 0
    has_dst_store = 0
    has_newline_check = 0
    has_nul_terminate = 0
    has_zero_return_path = 0
    has_ptr_return_path = 0
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

    if (u ~ /^(LINK\.W|MOVEM\.L|MOVE\.L [DA][0-7],-\((A7|SP)\)$)/) has_prologue = 1

    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMP\.L D[0-7],D[0-7]$/ || u ~ /^CMPI?\.L #0,D[0-7]$/) has_limit_guard = 1
    if (u ~ /^SUBQ\.L #1,[0-9]+\(A[0-7]\)$/ || u ~ /^SUBI?\.L #1,[0-9]+\(A[0-7]\)$/ || u ~ /^MOVE\.L \([0-9]+,A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L D[0-7],\([0-9]+,A[0-7]\)$/) has_stream_count_decrement = 1
    if (u ~ /JSR .*STREAM_BUFFEREDGETC/ || u ~ /^JSR \(A[0-7]\)$/ || u ~ /^JSR \(A[0-7]\)\+$/) has_refill_call = 1
    if (u ~ /^MOVE\.B \(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_readptr_byte_load = 1

    if (u ~ /^MOVEQ #-1,D[0-7]$/ || u ~ /^CMPI?\.L #-1,D[0-7]$/ || u ~ /^CMP\.L D[0-7],D[0-7]$/) has_eof_check = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^MOVE\.B D[0-7],0?\(A[0-7](,D[0-7]\.L)?\)$/) has_dst_store = 1
    if (u ~ /^MOVEQ #10,D[0-7]$/ || u ~ /^CMPI?\.B #10,D[0-7]$/ || u ~ /^CMPI?\.L #10,D[0-7]$/) has_newline_check = 1
    if (u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^CLR\.B 0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) has_nul_terminate = 1

    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_zero_return_path = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVEA?\.L A[0-7],A0$/) has_ptr_return_path = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_LIMIT_GUARD=" has_limit_guard
    print "HAS_STREAM_COUNT_DECREMENT=" has_stream_count_decrement
    print "HAS_REFILL_CALL=" has_refill_call
    print "HAS_READPTR_BYTE_LOAD=" has_readptr_byte_load
    print "HAS_EOF_CHECK=" has_eof_check
    print "HAS_DST_STORE=" has_dst_store
    print "HAS_NEWLINE_CHECK=" has_newline_check
    print "HAS_NUL_TERMINATE=" has_nul_terminate
    print "HAS_ZERO_RETURN_PATH=" has_zero_return_path
    print "HAS_PTR_RETURN_PATH=" has_ptr_return_path
    print "HAS_RTS=" has_rts
}
