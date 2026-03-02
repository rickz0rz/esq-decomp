BEGIN {
    label=0; call_count=0; slot0=0; slot1=0; clear0=0; clear1=0; rts=0
}

/^DST_FreeBannerPair:$/ { label=1 }
/(DST_FreeBannerStruct|JSR[[:space:]]+\([aA][0-7]\))/ { call_count++ }
/\([aA][0-7]\)|\(0,[aA][0-7]\)/ { slot0=1 }
/4\(A3\)|\(4,[aA][0-7]\)|\([aA][0-7]\)\+/ { slot1=1 }
/^CLR\.L[[:space:]]+\([aA][0-7]\)$|^MOVE\.L[[:space:]]+#0,\([aA][0-7]\)$/ { clear0=1 }
/^CLR\.L[[:space:]]+4\([aA][0-7]\)$|^MOVE\.L[[:space:]]+#0,4\([aA][0-7]\)$|^CLR\.L[[:space:]]+\([aA][0-7]\)\+$/ { clear1=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (call_count >= 2) print "HAS_TWO_FREE_CALLS"
    if (slot0) print "HAS_SLOT0_ACCESS"
    if (slot1) print "HAS_SLOT1_ACCESS"
    if (clear0) print "HAS_SLOT0_CLEAR"
    if (clear1) print "HAS_SLOT1_CLEAR"
    if (rts) print "HAS_RTS"
}
