BEGIN {
    label=0; alloc=0; c394=0; loop=0; rts=0
}

/^SCRIPT_AllocateBufferArray:$/ { label=1 }
/SCRIPT_JMPTBL_MEMORY_AllocateMemory/ { alloc=1 }
/#394([^0-9]|$)|#\$18a|394\.[Ww]/ { c394=1 }
/CMP\.W|DBRA|ADDQ\.W #1/ { loop=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (alloc) print "HAS_ALLOC_CALL"
    if (c394) print "HAS_CONST_394"
    if (loop) print "HAS_LOOP"
    if (rts) print "HAS_RTS"
}
