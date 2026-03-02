BEGIN {
    IGNORECASE=1
    label=0; call=0; primary=0; secondary=0; c0=0; rts=0
}

/^P_TYPE_ResetListsAndLoadPromoIds:$/ { label=1 }
/P_TYPE_LoadPromoIdDataFile/ { call=1 }
/P_TYPE_PrimaryGroupListPtr/ { primary=1 }
/P_TYPE_SecondaryGroupListPtr/ { secondary=1 }
/#0([^0-9]|$)|#\$00|\bCLR\./ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_LOAD_CALL"
    if (primary) print "HAS_PRIMARY_WRITE"
    if (secondary) print "HAS_SECONDARY_WRITE"
    if (c0) print "HAS_ZERO_WRITE"
    if (rts) print "HAS_RTS"
}
