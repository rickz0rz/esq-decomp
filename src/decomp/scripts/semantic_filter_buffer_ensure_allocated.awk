BEGIN {
    l=0; alloc=0; cap=0; err=0; clr=0; rem=0; rts=0
}

/^BUFFER_EnsureAllocated:$/ { l=1 }
/ALLOC_AllocFromFreeList/ { alloc=1 }
/Global_StreamBufferAllocSize/ { cap=1 }
/Global_AppErrorCode/ { err=1 }
/(AND\.L|ANDI\.L).*(#-13|#0xfffffff3|#\$fffffff3)/ { clr=1 }
/WriteRemaining|ReadRemaining|\(12,[Aa][0-7]\)|\(8,[Aa][0-7]\)/ { rem=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (alloc) print "HAS_ALLOC_CALL"
    if (cap) print "HAS_CAPACITY_GLOBAL"
    if (err) print "HAS_ERROR_GLOBAL"
    if (clr) print "HAS_OPENFLAGS_CLEAR"
    if (rem) print "HAS_REMAINING_ZERO"
    if (rts) print "HAS_RTS"
}
