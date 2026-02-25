BEGIN {
    has_port_link_test = 0
    has_remport_call = 0
    has_field8_ff = 0
    has_field20_neg1 = 0
    has_signalnum_load = 0
    has_freesignal_call = 0
    has_size_34 = 0
    has_freemem_call = 0
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

    if (u ~ /^TST\.L [0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^TST\.L \([0-9]+,A[0-7]\)$/ || u ~ /^CMP\.L #0,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^CMP\.L #0,\([0-9]+,A[0-7]\)$/) has_port_link_test = 1
    if (u ~ /JSR .*LVOREMPORT/) has_remport_call = 1

    if (u ~ /^MOVE\.B #\$?FF,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^MOVE\.B #-1,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^ST \([0-9]+,A[0-7]\)$/) has_field8_ff = 1
    if (u ~ /^MOVE\.L #\$?FFFFFFFF,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^MOVE\.L #-1,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^MOVE\.L D[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],[0-9]+\((A[0-7]|D[0-7])\)$/) has_field20_neg1 = 1

    if (u ~ /^MOVE\.B [0-9]+\((A[0-7]|D[0-7])\),D0$/ || u ~ /^MOVE\.B \([0-9]+,A[0-7]\),D0$/ || u ~ /^AND\.L #255,D0$/) has_signalnum_load = 1
    if (u ~ /JSR .*LVOFREESIGNAL/) has_freesignal_call = 1

    if (u ~ /^MOVEQ #34,D0$/ || u ~ /^MOVE\.L #34,D0$/) has_size_34 = 1
    if (u ~ /JSR .*LVOFREEMEM/) has_freemem_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_PORT_LINK_TEST=" has_port_link_test
    print "HAS_REMPORT_CALL=" has_remport_call
    print "HAS_FIELD8_FF=" has_field8_ff
    print "HAS_FIELD20_NEG1=" has_field20_neg1
    print "HAS_SIGNALNUM_LOAD=" has_signalnum_load
    print "HAS_FREESIGNAL_CALL=" has_freesignal_call
    print "HAS_SIZE_34=" has_size_34
    print "HAS_FREEMEM_CALL=" has_freemem_call
    print "HAS_RTS=" has_rts
}
