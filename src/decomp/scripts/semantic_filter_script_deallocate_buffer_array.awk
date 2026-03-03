BEGIN {
    label=0; dealloc=0; c405=0; clear=0; loop=0; rts=0
}

/^SCRIPT_DeallocateBufferArray:$/ { label=1 }
/SCRIPT_JMPTBL_MEMORY_DeallocateMemory/ { dealloc=1 }
/#405([^0-9]|$)|#\$195|405\.[Ww]/ { c405=1 }
/CLR\.L/ { clear=1 }
/CMP\.W|DBRA|ADDQ\.W #1/ { loop=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (dealloc) print "HAS_DEALLOC_CALL"
    if (c405) print "HAS_CONST_405"
    if (clear) print "HAS_SLOT_CLEAR"
    if (loop) print "HAS_LOOP"
    if (rts) print "HAS_RTS"
}
