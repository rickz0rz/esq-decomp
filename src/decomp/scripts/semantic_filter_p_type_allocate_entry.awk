BEGIN {
    IGNORECASE=1
    label=0; alloc=0; dealloc=0; cpy=0; typew=0; lenw=0; payloadw=0;
    c47=0; c58=0; c77=0; c10=0; c99=0; c100=0; c0=0; rts=0
}

/^P_TYPE_AllocateEntry:$/ { label=1 }
/SCRIPT_JMPTBL_MEMORY_AllocateMemory/ { alloc=1 }
/SCRIPT_JMPTBL_MEMORY_DeallocateMemory/ { dealloc=1 }
/\(A3,D5\.L\)|\(0,A0,D1\.L\)|payload|MOVE\.B .*0\(A0/ { cpy=1 }
/\(A0\)|\(A3\)|type_byte|MOVE\.B .*\(A3\)|MOVE\.B .*0\(A3/ { typew=1 }
/2\(A0\)|2\(A3\)|len/ { lenw=1 }
/6\(A0\)|6\(A3\)|payload/ { payloadw=1 }
/#47([^0-9]|$)|#\$2f|47\.[Ww]/ { c47=1 }
/#58([^0-9]|$)|#\$3a|58\.[Ww]/ { c58=1 }
/#77([^0-9]|$)|#\$4d|77\.[Ww]/ { c77=1 }
/#10([^0-9]|$)|#\$0a|10\.[Ww]/ { c10=1 }
/#99([^0-9]|$)|#\$63|99\.[Ww]/ { c99=1 }
/#100([^0-9]|$)|#\$64|100\.[Ww]/ { c100=1 }
/#0([^0-9]|$)|#\$00|\bCLR\./ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (alloc) print "HAS_ALLOC_CALL"
    if (dealloc) print "HAS_DEALLOC_CALL"
    if (c47) print "HAS_CONST_47"
    if (c58) print "HAS_CONST_58"
    if (c77) print "HAS_CONST_77"
    if (c10) print "HAS_CONST_10"
    if (c99) print "HAS_CONST_99"
    if (c100) print "HAS_CONST_100"
    if (c0) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}
