BEGIN {
    has_entry = 0
    has_save_d7 = 0
    has_cmp_neg1 = 0
    has_btst4 = 0
    has_btst5 = 0
    has_btst8 = 0
    has_btst0 = 0
    has_btst2 = 0
    has_btst1 = 0
    has_setcolor_call = 0
    has_return = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_APPLYSTATUSMASKTOINDICATORS:/) has_entry = 1
    if (uline ~ /MOVE\.L D7,-\(A7\)/) has_save_d7 = 1
    if (uline ~ /MOVEQ #-1,D0/ && uline ~ /CMP\.L D0,D7/) has_cmp_neg1 = 1
    if (uline ~ /BTST #4,D7/) has_btst4 = 1
    if (uline ~ /BTST #5,D7/) has_btst5 = 1
    if (uline ~ /BTST #8,D7/) has_btst8 = 1
    if (uline ~ /BTST #0,D7/) has_btst0 = 1
    if (uline ~ /BTST #2,D7/) has_btst2 = 1
    if (uline ~ /BTST #1,D7/) has_btst1 = 1
    if (uline ~ /ESQDISP_SETSTATUSINDICATORCOLORSLOT/) has_setcolor_call = 1
    if (uline ~ /MOVE\.L \(A7\)\+,D7/ && uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE_D7=" has_save_d7
    print "HAS_CMP_NEG1=" has_cmp_neg1
    print "HAS_BTST4=" has_btst4
    print "HAS_BTST5=" has_btst5
    print "HAS_BTST8=" has_btst8
    print "HAS_BTST0=" has_btst0
    print "HAS_BTST2=" has_btst2
    print "HAS_BTST1=" has_btst1
    print "HAS_SETCOLOR_CALL=" has_setcolor_call
    print "HAS_RETURN=" has_return
}
