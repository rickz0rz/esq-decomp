BEGIN {
    label=0; avail=0; fast=0; c600k=0; flag=0; ret=0
}

/^ESQ_CheckAvailableFastMemory:$/ { label=1 }
/_LVOAvailMem|AvailMem/ { avail=1 }
/#\$2|#2|2\.[Ww]/ { fast=1 }
/#600000|#\$927c0|600000\.[Ww]|600000\.[Ll]/ { c600k=1 }
/HAS_REQUESTED_FAST_MEMORY/ { flag=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (avail) print "HAS_AVAILMEM_CALL"
    if (fast) print "HAS_FASTMEM_FLAG_2"
    if (c600k) print "HAS_CONST_600000"
    if (flag) print "HAS_FASTMEM_GUARD_FLAG_REF"
    if (ret) print "HAS_RTS"
}
