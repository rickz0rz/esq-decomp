BEGIN {
    has_entry=0
    has_check_mode=0
    has_check_arg_entry=0
    has_check_arg_aux=0
    has_bit7_gate=0
    has_bit2_gate=0
    has_mode1_call=0
    has_const0=0
    has_const1=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_TESTENTRYSELECTABLE:/ || u ~ /^NEWGRID_TESTENTRYSELECTA[A-Z0-9_]*:/) has_entry=1
    if (u ~ /TST\.L D7/ || u ~ /CMP\.L .*D7/ || u ~ /CMP\.L D0,D7/) has_check_mode=1
    if (u ~ /MOVE\.L A3,D0/ || u ~ /MOVE\.L A5,D0/ || u ~ /TST\.L A3/ || u ~ /TST\.L A5/) has_check_arg_entry=1
    if (u ~ /MOVE\.L A2,D0/ || u ~ /MOVE\.L A3,D0/ || u ~ /TST\.L A2/) has_check_arg_aux=1
    if (u ~ /BTST #7,40\(A3\)/ || u ~ /BTST #\$7,\$28\(A5\)/ || (n ~ /40A3/ && n ~ /BTST7/) || (n ~ /28A5/ && n ~ /BTST7/)) has_bit7_gate=1
    if (u ~ /BTST #2,27\(A3\)/ || u ~ /BTST #\$2,\$1B\(A5\)/ || (n ~ /27A3/ && n ~ /BTST2/) || (n ~ /1BA5/ && n ~ /BTST2/)) has_bit2_gate=1
    if (n ~ /NEWGRID2JMPTBLESQDISPTESTENTRYBITS0AND2/ || n ~ /NEWGRID2JMPTBLESQDISPTESTENTR/) has_mode1_call=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || u ~ /0\.[Ww]/ || u ~ /\(\$0\)/ || u ~ /CLR\./) has_const0=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MODE_CHECK="has_check_mode
    print "HAS_ENTRY_ARG_CHECK="has_check_arg_entry
    print "HAS_AUX_ARG_CHECK="has_check_arg_aux
    print "HAS_BIT7_GATE="has_bit7_gate
    print "HAS_BIT2_GATE="has_bit2_gate
    print "HAS_MODE1_HELPER_CALL="has_mode1_call
    print "HAS_CONST_0="has_const0
    print "HAS_CONST_1="has_const1
    print "HAS_RTS="has_rts
}
