BEGIN {
    IGNORECASE=1
    label=0; primary=0; len=0; payload=0; one=0; zero=0; rts=0
}

/^P_TYPE_ConsumePrimaryTypeIfPresent:$/ { label=1 }
/P_TYPE_PrimaryGroupListPtr/ { primary=1 }
/2\(A[0-7]\)|\(2,[Aa][0-7]\)|len/ { len=1 }
/6\(A[0-7]\)|\(6,[Aa][0-7]\)|payload/ { payload=1 }
/#1([^0-9]|$)|\bMOVEQ #1/ { one=1 }
/#0([^0-9]|$)|\bCLR\.B|\bMOVEQ #0/ { zero=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (primary) print "HAS_PRIMARY_ACCESS"
    if (len) print "HAS_LEN_ACCESS"
    if (payload) print "HAS_PAYLOAD_ACCESS"
    if (one) print "HAS_CONST_1"
    if (zero) print "HAS_CONST_0_CLEAR"
    if (rts) print "HAS_RTS"
}
