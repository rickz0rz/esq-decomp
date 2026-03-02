BEGIN {
    label=0; free_call=0; alloc_calls=0; c798=0; c803=0; c807=0; c18=0; c22=0; cflags=0
    slot0=0; slot1=0; clear16=0; ret=0
}

/^DST_AllocateBannerStruct:$/ { label=1 }
/DST_FreeBannerStruct/ { free_call=1 }
/GROUP_AG_JMPTBL_MEMORY_AllocateMemory/ { alloc_calls++ }
/#\$31e|#798|798\.[Ww]/ { c798=1 }
/#\$323|#803|803\.[Ww]/ { c803=1 }
/#\$327|#807|807\.[Ww]/ { c807=1 }
/#\$12|#18|18\.[Ww]/ { c18=1 }
/#\$16|#22|22\.[Ww]/ { c22=1 }
/#\$10001|#65537|65537\.[Ww]|65537\.[Ll]|MEMF_PUBLIC|MEMF_CLEAR/ { cflags=1 }
/^MOVE\.L[[:space:]]+[dD][0-7],\([aA][0-7]\)$/ { slot0=1 }
/^MOVE\.L[[:space:]]+[dD][0-7],4\([aA][0-7]\)$|^MOVE\.L[[:space:]]+[dD][0-7],\(4,[aA][0-7]\)$/ { slot1=1 }
/^CLR\.W[[:space:]]+16\([aA][0-7]\)$|^CLR\.W[[:space:]]+\(16,[aA][0-7]\)$|^MOVE\.W[[:space:]]+#0,16\([aA][0-7]\)$|^MOVE\.W[[:space:]]+#0,\(16,[aA][0-7]\)$/ { clear16=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (free_call) print "HAS_FREE_CALL"
    if (alloc_calls >= 3) print "HAS_THREE_ALLOC_CALLS"
    if (c798) print "HAS_LINE_798"
    if (c803) print "HAS_LINE_803"
    if (c807) print "HAS_LINE_807"
    if (c18) print "HAS_SIZE_18"
    if (c22) print "HAS_SIZE_22"
    if (cflags) print "HAS_FLAGS_10001"
    if (slot0) print "HAS_SLOT0_STORE"
    if (slot1) print "HAS_SLOT1_STORE"
    if (clear16) print "HAS_STATE_WORD_CLEAR"
    if (ret) print "HAS_RTS"
}
