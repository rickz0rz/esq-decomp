BEGIN {
    h_entry = 0
    h_setup = 0
    h_clear = 0
    h_set_ptr = 0
    h_call = 0
    h_putc_ref = 0
    h_write_nul = 0
    h_ret_count = 0
    h_rts = 0
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

    if (u ~ /^WDISP_SPRINTF:$/) h_entry = 1
    if (u ~ /^LINK\.W A5,#\$?0$/ || u ~ /^MOVE\.L A5,-\(A7\)$/ || u ~ /^MOVEM\.L A2-A3,-\(A7\)$/ || u ~ /^MOVEM\.L A2\/A3,-\(A7\)$/) h_setup = 1
    if (u ~ /^CLR\.L GLOBAL_PRINTFBYTECOUNT\(A4\)$/) h_clear = 1
    if (u ~ /^MOVE\.L A[035],GLOBAL_PRINTFBUFFERPTR\(A4\)$/ || u ~ /^MOVE\.L D[0-7],GLOBAL_PRINTFBUFFERPTR\(A4\)$/) h_set_ptr = 1
    if (u ~ /UNKNOWN10_PRINTFPUTCTOBUFFER/) h_putc_ref = 1
    if (u ~ /WDISP_FORMATWITHCALLBACK/) h_call = 1
    if (u ~ /^CLR\.B \(A0\)$/ || u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #\$?0,\(A[0-7]\)$/) h_write_nul = 1
    if (u ~ /^MOVE\.L GLOBAL_PRINTFBYTECOUNT\(A4\),D0$/) h_ret_count = 1
    if (u ~ /^RTS$/) h_rts = 1
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_SETUP=" h_setup
    print "HAS_COUNTER_CLEAR=" h_clear
    print "HAS_PTR_SET=" h_set_ptr
    print "HAS_FORMAT_CALL=" h_call
    print "HAS_PUTC_REF=" h_putc_ref
    print "HAS_WRITE_NUL=" h_write_nul
    print "HAS_RET_COUNT=" h_ret_count
    print "HAS_RTS=" h_rts
}
