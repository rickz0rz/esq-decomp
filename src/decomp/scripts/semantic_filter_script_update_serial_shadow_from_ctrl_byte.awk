BEGIN { label=0; latch=0; shadow=0; callw=0; rts=0 }
/^SCRIPT_UpdateSerialShadowFromCtrlByte:$/ { label=1 }
/SCRIPT_SerialInputLatch/ { latch=1 }
/SCRIPT_SerialShadowWord/ { shadow=1 }
/SCRIPT_WriteCtrlShadowToSerdat/ { callw=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (latch) print "HAS_LATCH_WRITE"
    if (shadow) print "HAS_SHADOW_WRITE"
    if (callw) print "HAS_WRITECALL"
    if (rts) print "HAS_RTS"
}
