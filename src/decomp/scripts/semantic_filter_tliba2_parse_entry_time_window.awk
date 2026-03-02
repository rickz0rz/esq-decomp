BEGIN {
    label=0; find=0; parse=0; c40=0; c58=0; c41=0; c34=0; c32=0; write0=0; write1=0; ok=0; ret=0
}

/^TLIBA2_ParseEntryTimeWindow:$/ { label=1 }
/STR_FindCharPtr/ { find=1 }
/PARSE_ReadSignedLongSkipClass3_Alt/ { parse=1 }
/#\$28|#40|40\.[Ww]/ { c40=1 }
/#\$3a|#58|58\.[Ww]/ { c58=1 }
/#\$29|#41|41\.[Ww]/ { c41=1 }
/#\$22|#34|34\.[Ww]/ { c34=1 }
/#\$20|#32|32\.[Ww]/ { c32=1 }
/\(A2\)|0\(A2\)|\([aA][0-7]\)|\(0,[aA][0-7]\)/ { write0=1 }
/4\(A2\)|\(4,[aA][0-7]\)/ { write1=1 }
/MOVEQ[[:space:]]+#1,[dD][0-7]/ { ok=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (find) print "HAS_FIND_CHAR_CALLS"
    if (parse) print "HAS_PARSE_LONG_CALLS"
    if (c40) print "HAS_CONST_40"
    if (c58) print "HAS_CONST_58"
    if (c41) print "HAS_CONST_41"
    if (c34) print "HAS_CONST_34"
    if (c32) print "HAS_CONST_32"
    if (write0) print "HAS_OUT0_WRITE"
    if (write1) print "HAS_OUT1_WRITE"
    if (ok) print "HAS_SUCCESS_FLAG"
    if (ret) print "HAS_RTS"
}
