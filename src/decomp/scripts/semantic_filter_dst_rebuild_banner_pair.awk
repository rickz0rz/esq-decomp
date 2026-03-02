BEGIN {
    label=0; free_calls=0; alloc_calls=0; slot0=0; slot1=0; ok_set=0; ret=0
}

/^DST_RebuildBannerPair:$/ { label=1 }
/DST_FreeBannerPair/ { free_calls++ }
/DST_AllocateBannerStruct/ { alloc_calls++ }
/\([aA][0-7]\)|\(0,[aA][0-7]\)/ { slot0=1 }
/4\([aA][0-7]\)|\(4,[aA][0-7]\)|\([aA][0-7]\)\+/ { slot1=1 }
/^MOVEQ[[:space:]]+#1,[dD][0-7]$|^MOVE\.Q[[:space:]]+#1,[dD][0-7]$|^MOVE\.L[[:space:]]+#1,[dD][0-7]$|^SNE[[:space:]]+[dD][0-7]$|^SEQ[[:space:]]+[dD][0-7]$/ { ok_set=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (free_calls >= 2) print "HAS_TWO_FREE_CALLS"
    if (alloc_calls >= 2) print "HAS_TWO_ALLOC_CALLS"
    if (slot0) print "HAS_SLOT0_ACCESS"
    if (slot1) print "HAS_SLOT1_ACCESS"
    if (ok_set) print "HAS_OK_SET"
    if (ret) print "HAS_RTS"
}
