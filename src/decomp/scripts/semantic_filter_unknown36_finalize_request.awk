BEGIN {
    has_label = 0
    has_stream = 0
    has_alloc = 0
    has_close = 0
    has_flag_mask = 0
    has_neg1 = 0
    has_rts = 0
}

/^UNKNOWN36_FinalizeRequest:$/ { has_label = 1 }
/STREAM_BufferedPutcOrFlush/ { has_stream = 1 }
/ALLOC_InsertFreeBlock/ { has_alloc = 1 }
/HANDLE_CloseByIndex/ { has_close = 1 }
/(AND\.L|ANDI\.L).*(#12|#0xc)/ { has_flag_mask = 1 }
/(MOVEQ|PEA).*(#-1|-1\.W)/ { has_neg1 = 1 }
/^RTS$/ { has_rts = 1 }

END {
    if (has_label) print "HAS_LABEL"
    if (has_stream) print "HAS_STREAM_CALL"
    if (has_alloc) print "HAS_ALLOC_CALL"
    if (has_close) print "HAS_CLOSE_CALL"
    if (has_flag_mask) print "HAS_FLAG_MASK_12"
    if (has_neg1) print "HAS_NEG1_PATH"
    if (has_rts) print "HAS_RTS"
}
