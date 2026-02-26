BEGIN {
    has_setsignal_call = 0
    has_3000_mask = 0
    has_callback_test = 0
    has_callback_call = 0
    has_callback_clear = 0
    has_closeall_call = 0
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

    if (u ~ /JSR .*LVOSETSIGNAL/) has_setsignal_call = 1
    if (u ~ /#\$3000/ || u ~ /#12288/ || u ~ /#0X3000/) has_3000_mask = 1
    if (u ~ /GLOBAL_SIGNALCALLBACKPTR/) has_callback_test = 1
    if (u ~ /JSR \(A[0-7]\)/) has_callback_call = 1
    if (u ~ /^CLR\.L GLOBAL_SIGNALCALLBACKPTR/ || u ~ /^MOVE\.L #0,GLOBAL_SIGNALCALLBACKPTR/) has_callback_clear = 1
    if (u ~ /JSR .*HANDLE_CLOSEALLANDRETURNWITHCODE/) has_closeall_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SETSIGNAL_CALL=" has_setsignal_call
    print "HAS_3000_MASK=" has_3000_mask
    print "HAS_CALLBACK_TEST=" has_callback_test
    print "HAS_CALLBACK_CALL=" has_callback_call
    print "HAS_CALLBACK_CLEAR=" has_callback_clear
    print "HAS_CLOSEALL_CALL=" has_closeall_call
    print "HAS_RTS=" has_rts
}
