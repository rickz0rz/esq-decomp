BEGIN {
    has_signal_test = 0
    has_signal_call = 0
    has_close_call = 0
    has_zero_return = 0
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

    if (u ~ /GLOBAL_SIGNALCALLBACKPTR/) has_signal_test = 1
    if (u ~ /JSR .*SIGNAL_POLLANDDISPATCH/) has_signal_call = 1
    if (u ~ /JSR .*DOS_CLOSE/ || u ~ /JSR .*LVOCLOSE/) has_close_call = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_zero_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGNAL_TEST=" has_signal_test
    print "HAS_SIGNAL_CALL=" has_signal_call
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RTS=" has_rts
}
