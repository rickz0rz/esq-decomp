BEGIN {
    label=0; dealloc=0; freebuf=0; dispfree=0; reset=0; c100=0; c148=0; ret=0
}

/^NEWGRID_ShutdownGridResources:$/ { label=1 }
/NEWGRID_JMPTBL_MEMORY_DeallocateMemory/ { dealloc=1 }
/NEWGRID2_FreeBuffersIfAllocated/ { freebuf=1 }
/NEWGRID_JMPTBL_DISPTEXT_FreeBuffers/ { dispfree=1 }
/NEWGRID_ResetShowtimeBuckets/ { reset=1 }
/#\$64|#100|100\.[Ww]/ { c100=1 }
/#148|148\.[Ww]/ { c148=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (dealloc) print "HAS_DEALLOC_CALL"
    if (freebuf) print "HAS_FREEBUFFERS_CALL"
    if (dispfree) print "HAS_DISPTEXT_FREE_CALL"
    if (reset) print "HAS_RESET_BUCKETS_CALL"
    if (c100) print "HAS_CONST_100"
    if (c148) print "HAS_CONST_148"
    if (ret) print "HAS_RTS"
}
