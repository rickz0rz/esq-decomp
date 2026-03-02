BEGIN {
    IGNORECASE=1
    label=0; call=0; primary=0; secondary=0; c0=0; rts=0
}

/^P_TYPE_PromoteSecondaryList:$/ { label=1 }
/P_TYPE_FreeEntry/ { call=1 }
/P_TYPE_PrimaryGroupListPtr/ { primary=1 }
/P_TYPE_SecondaryGroupListPtr/ { secondary=1 }
/#0([^0-9]|$)|#\$00|\bCLR\./ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_FREE_CALL"
    if (primary) print "HAS_PRIMARY_ACCESS"
    if (secondary) print "HAS_SECONDARY_ACCESS"
    if (c0) print "HAS_ZERO_CLEAR"
    if (rts) print "HAS_RTS"
}
