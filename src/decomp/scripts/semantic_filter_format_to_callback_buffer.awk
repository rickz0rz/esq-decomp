BEGIN {
    has_counter_clear = 0
    has_buffer_ptr_set = 0
    has_format_call = 0
    has_writer_ref = 0
    has_flush_call = 0
    has_minus_one = 0
    has_return_count = 0
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

    if (u ~ /GLOBAL_FORMATCALLBACKBYTECOUNT/ && (u ~ /^CLR\.L / || u ~ /^MOVEQ #0,/ || u ~ /^MOVE\.L #0,/)) has_counter_clear = 1
    if (u ~ /GLOBAL_FORMATCALLBACKBUFFERPTR/ && (u ~ /^MOVE\.L A[0-7],/ || u ~ /^MOVE\.L D[0-7],/ || u ~ /^MOVEA?\.L /)) has_buffer_ptr_set = 1

    if (u ~ /FORMAT_CALLBACKWRITECHAR/) has_writer_ref = 1
    if (u ~ /WDISP_FORMATWITHCALLBACK/) has_format_call = 1
    if (u ~ /STREAM_BUFFEREDPUTCORFLUSH/) has_flush_call = 1
    if (u ~ /PEA -1\.W/ || u ~ /^MOVEQ #-1,D[0-7]$/ || u ~ /^MOVE\.L #-1,/ ) has_minus_one = 1

    if (u ~ /GLOBAL_FORMATCALLBACKBYTECOUNT/ && u ~ /,D0$/) has_return_count = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_COUNTER_CLEAR=" has_counter_clear
    print "HAS_BUFFER_PTR_SET=" has_buffer_ptr_set
    print "HAS_FORMAT_CALL=" has_format_call
    print "HAS_WRITER_REF=" has_writer_ref
    print "HAS_FLUSH_CALL=" has_flush_call
    print "HAS_MINUS_ONE=" has_minus_one
    print "HAS_RETURN_COUNT=" has_return_count
    print "HAS_RTS=" has_rts
}
