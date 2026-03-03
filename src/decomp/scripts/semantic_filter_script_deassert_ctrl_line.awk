BEGIN { label=0; flag=0; callw=0; rts=0 }
/^SCRIPT_DeassertCtrlLine:$/ { label=1 }
/SCRIPT_CtrlLineAssertedFlag|CLR\.W/ { flag=1 }
/SCRIPT_WriteCtrlShadowToSerdat/ { callw=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (flag) print "HAS_FLAG_CLEAR"
    if (callw) print "HAS_WRITECALL"
    if (rts) print "HAS_RTS"
}
