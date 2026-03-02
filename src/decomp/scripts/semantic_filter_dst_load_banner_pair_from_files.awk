BEGIN {
    label=0; rebuild=0; load=0; find_count=0; parse_count=0; copy_count=0; free_call=0; update=0
    g2=0; g3=0; c4=0; c19=0; c889=0; zero_ret=0; one_ret=0; ret=0
}

/^DST_LoadBannerPairFromFiles:$/ { label=1 }
/DST_RebuildBannerPair/ { rebuild=1 }
/DISKIO_LoadFileToWorkBuffer/ { load=1 }
/GROUP_AJ_JMPTBL_STRING_FindSubstring/ { find_count++ }
/DATETIME_ParseString/ { parse_count++ }
/DATETIME_CopyPairAndRecalc/ { copy_count++ }
/GROUP_AG_JMPTBL_MEMORY_DeallocateMemory/ { free_call=1 }
/DST_UpdateBannerQueue/ { update=1 }
/Global_STR_G2/ { g2=1 }
/Global_STR_G3/ { g3=1 }
/#\$4|#4|4\.[Ww]/ { c4=1 }
/#\$13|#19|19\.[Ww]/ { c19=1 }
/#\$379|#889|889\.[Ww]/ { c889=1 }
/^MOVEQ[[:space:]]+#0,[dD][0-7]$/ { zero_ret=1 }
/^MOVEQ[[:space:]]+#1,[dD][0-7]$/ { one_ret=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (rebuild) print "HAS_REBUILD_CALL"
    if (load) print "HAS_LOAD_CALL"
    if (find_count >= 2) print "HAS_TWO_FIND_CALLS"
    if (parse_count >= 2) print "HAS_PARSE_PATHS"
    if (copy_count >= 2) print "HAS_TWO_COPY_CALLS"
    if (free_call) print "HAS_DEALLOCATE_CALL"
    if (update) print "HAS_UPDATE_QUEUE_CALL"
    if (g2) print "HAS_G2_TOKEN"
    if (g3) print "HAS_G3_TOKEN"
    if (c4) print "HAS_CONST_4"
    if (c19) print "HAS_CONST_19"
    if (c889) print "HAS_CONST_889"
    if (zero_ret) print "HAS_ZERO_RETURN_PATH"
    if (one_ret) print "HAS_ONE_RETURN_PATH"
    if (ret) print "HAS_RTS"
}
