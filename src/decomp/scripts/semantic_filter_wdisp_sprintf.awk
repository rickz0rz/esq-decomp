BEGIN {
    has_count_clear = 0
    has_buf_ptr_set = 0
    has_writer_ref = 0
    has_format_call = 0
    has_nul_term = 0
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

    if (u ~ /GLOBAL_PRINTFBYTECOUNT/ && (u ~ /^CLR\.L / || u ~ /^MOVEQ #0,/ || u ~ /^MOVE\.L #0,/)) has_count_clear = 1
    if (u ~ /GLOBAL_PRINTFBUFFERPTR/ && u ~ /^MOVE\.L .*?,/) has_buf_ptr_set = 1
    if (u ~ /UNKNOWN10_PRINTFPUTCTOBUFFER/) has_writer_ref = 1
    if (u ~ /WDISP_FORMATWITHCALLBACK/) has_format_call = 1
    if ((u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) && u !~ /GLOBAL_/) has_nul_term = 1
    if (u ~ /GLOBAL_PRINTFBYTECOUNT/ && u ~ /,D0$/) has_return_count = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_COUNT_CLEAR=" has_count_clear
    print "HAS_BUF_PTR_SET=" has_buf_ptr_set
    print "HAS_WRITER_REF=" has_writer_ref
    print "HAS_FORMAT_CALL=" has_format_call
    print "HAS_NUL_TERM=" has_nul_term
    print "HAS_RETURN_COUNT=" has_return_count
    print "HAS_RTS=" has_rts
}
