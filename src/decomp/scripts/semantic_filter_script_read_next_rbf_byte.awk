BEGIN { label=0; callj=0; rts=0 }
/^SCRIPT_ReadNextRbfByte:$/ { label=1 }
/SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte/ { callj=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (callj) print "HAS_CALL"
    if (rts) print "HAS_RTS"
}
