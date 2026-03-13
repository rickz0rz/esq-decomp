BEGIN {
    l=0; fin=0; open=0; dflt=0; plus=0; init=0; out=0; rts=0
}

/^HANDLE_OpenFromModeString:$/ { l=1 }
/UNKNOWN36_FinalizeRequest/ { fin=1 }
/HANDLE_OpenEntryWithFlags/ { open=1 }
/Global_DefaultHandleFlags/ { dflt=1 }
/#43|\+|SEQ|NEG|EXT/ { plus=1 }
/BufferBase|BufferCursor|ReadRemaining|WriteRemaining|BufferCapacity|HandleIndex|OpenFlags/ { init=1 }
/\(24,a2\)|\(20,a2\)|\(16,a2\)|\(12,a2\)|\(8,a2\)|\(4,a2\)|\$(18|14|10|c|8|4)\(A2\)/ { init=1 }
/#\$4000|#16384|#0x4000|#\$8000|#32768|#0x8000/ { out=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (fin) print "HAS_FINALIZE_CALL"
    if (open) print "HAS_OPEN_CALL"
    if (dflt) print "HAS_DEFAULT_FLAGS"
    if (plus) print "HAS_PLUS_CHECK"
    if (init) print "HAS_NODE_INIT"
    if (out) print "HAS_OPENFLAG_BUILD"
    if (rts) print "HAS_RTS"
}
