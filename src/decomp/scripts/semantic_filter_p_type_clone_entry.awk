BEGIN {
    IGNORECASE=1
    label=0; freec=0; allocc=0; len=0; payload=0; typeb=0; zero=0; rts=0
}

/^P_TYPE_CloneEntry:$/ { label=1 }
/P_TYPE_FreeEntry/ { freec=1 }
/P_TYPE_AllocateEntry/ { allocc=1 }
/2\(A2\)|\(2,[Aa][0-7]\)|len/ { len=1 }
/6\(A2\)|\(6,[Aa][0-7]\)|payload/ { payload=1 }
/\([Aa]2\)|\([Aa]0\)|type_byte/ { typeb=1 }
/#0([^0-9]|$)|\bCLR\.B|\bMOVEQ #0/ { zero=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (freec) print "HAS_FREE_CALL"
    if (allocc) print "HAS_ALLOC_CALL"
    if (len) print "HAS_LEN_ACCESS"
    if (payload) print "HAS_PAYLOAD_ACCESS"
    if (typeb) print "HAS_TYPE_ACCESS"
    if (zero) print "HAS_ZERO_TERM"
    if (rts) print "HAS_RTS"
}
