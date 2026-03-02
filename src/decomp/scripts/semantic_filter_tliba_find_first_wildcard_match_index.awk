BEGIN {
    label=0; wildcard=0; count=0; table=0; neg1=0; loop=0; ret=0
}

/^TLIBA_FindFirstWildcardMatchIndex:$/ { label=1 }
/UNKNOWN_JMPTBL_ESQ_WildcardMatch/ { wildcard=1 }
/TEXTDISP_SecondaryGroupEntryCount/ { count=1 }
/TEXTDISP_SecondaryTitlePtrTable/ { table=1 }
/#-1|#\$ffffffff|MOVEQ[[:space:]]+#-1/ { neg1=1 }
/ADDQ\.L[[:space:]]+#1|ASL\.L[[:space:]]+#2|CMP\.L/ { loop=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (wildcard) print "HAS_WILDCARD_CALL"
    if (count) print "HAS_ENTRY_COUNT_REF"
    if (table) print "HAS_TITLE_TABLE_REF"
    if (neg1) print "HAS_DEFAULT_NEG1"
    if (loop) print "HAS_INDEX_LOOP"
    if (ret) print "HAS_RTS"
}
