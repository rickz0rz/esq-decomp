BEGIN {
    has_strlen_scan = 0
    has_len_subtract = 0
    has_char_load = 0
    has_write_remaining_ref = 0
    has_buffer_cursor_ref = 0
    has_stream_putc_call = 0
    has_flush_minus_one = 0
    has_prealloc_node_ref = 0
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

    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^CMP\.B #0,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_strlen_scan = 1
    if (u ~ /^SUBA?\.L A[0-7],A[0-7]$/ || u ~ /^SUBA?\.L A[0-7],D[0-7]$/) has_len_subtract = 1

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)$/) has_char_load = 1

    if (u ~ /GLOBAL_PREALLOCHANDLENODE1_WRITEREMAINING/) has_write_remaining_ref = 1
    if (u ~ /GLOBAL_PREALLOCHANDLENODE1_BUFFERCURSOR/) has_buffer_cursor_ref = 1
    if (u ~ /GLOBAL_PREALLOCHANDLENODE1([^A-Z0-9_]|$)/) has_prealloc_node_ref = 1

    if (u ~ /STREAM_BUFFEREDPUTCORFLUSH/) has_stream_putc_call = 1
    if (u ~ /PEA -1\.W/ || u ~ /MOVEQ #-1,D[0-7]/ || u ~ /#-1/) has_flush_minus_one = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_STRLEN_SCAN=" has_strlen_scan
    print "HAS_LEN_SUBTRACT=" has_len_subtract
    print "HAS_CHAR_LOAD=" has_char_load
    print "HAS_WRITE_REMAINING_REF=" has_write_remaining_ref
    print "HAS_BUFFER_CURSOR_REF=" has_buffer_cursor_ref
    print "HAS_STREAM_PUTC_CALL=" has_stream_putc_call
    print "HAS_FLUSH_MINUS_ONE=" has_flush_minus_one
    print "HAS_PREALLOC_NODE_REF=" has_prealloc_node_ref
    print "HAS_RTS=" has_rts
}
