BEGIN {
    label=0; null_guard=0; ptr0=0; ptr4=0; free_calls=0; c22=0; c18=0; tags=0; rts=0
}

/^DST_FreeBannerStruct:$/ { label=1 }
/^MOVE\.L[[:space:]]+[aA][0-7],[dD][0-7]$|^TST\.L[[:space:]]+[dD][0-7]$/ { null_guard=1 }
/\([aA][0-7]\)|\(0,[aA][0-7]\)/ { ptr0=1 }
/4\([aA][0-7]\)|\(4,[aA][0-7]\)/ { ptr4=1 }
/GROUP_AG_JMPTBL_MEMORY_DeallocateMemory/ { free_calls++ }
/#22|22\.[wW]/ { c22=1 }
/#18|18\.[wW]/ { c18=1 }
/Global_STR_DST_C_1|Global_STR_DST_C_2|Global_STR_DST_C_3/ { tags=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (null_guard) print "HAS_NULL_GUARD"
    if (ptr0) print "HAS_SLOT0_CHECK"
    if (ptr4) print "HAS_SLOT1_CHECK"
    if (free_calls >= 2) print "HAS_DEALLOC_CALLS"
    if (c22) print "HAS_SIZE_22"
    if (c18) print "HAS_SIZE_18"
    if (tags) print "HAS_DST_TAG_STRINGS"
    if (rts) print "HAS_RTS"
}
