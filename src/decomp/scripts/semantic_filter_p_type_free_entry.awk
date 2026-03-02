BEGIN {
    IGNORECASE=1
    label=0; dealloc=0; c92=0; c95=0; c10=0; rts=0
}

/^P_TYPE_FreeEntry:$/ { label=1 }
/SCRIPT_JMPTBL_MEMORY_DeallocateMemory/ { dealloc=1 }
/#92([^0-9]|$)|#\$5c|92\.[Ww]/ { c92=1 }
/#95([^0-9]|$)|#\$5f|95\.[Ww]/ { c95=1 }
/#10([^0-9]|$)|#\$0a|10\.[Ww]/ { c10=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (dealloc) print "HAS_DEALLOC_CALL"
    if (c92) print "HAS_CONST_92"
    if (c95) print "HAS_CONST_95"
    if (c10) print "HAS_CONST_10"
    if (rts) print "HAS_RTS"
}
