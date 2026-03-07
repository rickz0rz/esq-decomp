BEGIN {
    has_entry=0
    has_scan_loop=0
    has_tst=0
    has_btst7=0
    has_compare_84=0
    has_compare_a3=0
    has_return_ptr=0
    has_inc=0
    has_null_return=0
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

    if (u ~ /^TEXTDISP_FINDCONTROLTOKEN:/ || u ~ /^TEXTDISP_FINDCONTROLTOKE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /SCANLOOP/ || n ~ /BRA[BSWL]*TEXTDISPFINDCONTROLTOKEN2/) has_scan_loop=1
    if (n ~ /^TSTB[A0-7]/ || n ~ /TSTB[A0-7][0-9]/ || n ~ /TSTB0A[0-7]/ || u ~ /MOVE\.B \(A[0-7]\),D0/ || n ~ /MOVEB0A[0-7]D0/) has_tst=1
    if (n ~ /BTST7/) has_btst7=1
    if (u ~ /#\$84/ || u ~ /#132([^0-9]|$)/ || index(u, "MOVEQ.L #$42,D1") > 0 || index(u, "MOVEQ #$42,D1") > 0) has_compare_84=1
    if (u ~ /#\$A3/ || u ~ /#163([^0-9]|$)/) has_compare_a3=1
    if (n ~ /MOVELA[0-7]D0/ || n ~ /MOVEAA[0-7]D0/) has_return_ptr=1
    if (n ~ /ADDQL1A[0-7]/ || n ~ /ADDAQL1A[0-7]/) has_inc=1
    if (u ~ /MOVEQ(\.L)? #\$0,D0/ || u ~ /MOVEQ(\.L)? #0,D0/) has_null_return=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SCAN_LOOP_LABEL="has_scan_loop
    print "HAS_TST_BYTE="has_tst
    print "HAS_BTST_BIT7="has_btst7
    print "HAS_COMPARE_0X84="has_compare_84
    print "HAS_COMPARE_0XA3="has_compare_a3
    print "HAS_RETURN_POINTER="has_return_ptr
    print "HAS_INCREMENT_PTR="has_inc
    print "HAS_NULL_RETURN="has_null_return
    print "HAS_RTS="has_rts
}
