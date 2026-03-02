BEGIN {
    l=0; wr=0; close_call=0; next_traversal=0; state=0; base=0; rts=0
}

/^BUFFER_FlushAllAndCloseWithCode:$/ { l=1 }
/DOS_WriteByIndex/ { wr=1 }
/HANDLE_CloseAllAndReturnWithCode/ { close_call=1 }
/Struct_PreallocHandleNode__Next|\(32,[Aa][0-7]\)/ { next_traversal=1 }
/StateFlags|BTST[[:space:]]+#2|BTST[[:space:]]+#1|AND\.B[[:space:]]+#6|CMP\.B[[:space:]]+#2/ { state=1 }
/BufferCursor|BufferBase|HandleIndex|\(4,[Aa][0-7]\)|\(20,[Aa][0-7]\)/ { base=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (wr) print "HAS_WRITE_CALL"
    if (close_call) print "HAS_CLOSE_ALL_CALL"
    if (next_traversal) print "HAS_NEXT_TRAVERSAL"
    if (state) print "HAS_STATE_GATES"
    if (base) print "HAS_PENDING_CALC"
    if (rts) print "HAS_RTS"
}
