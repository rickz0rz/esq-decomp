BEGIN { label=0; flag=0; or20=0; callw=0; rts=0 }
/^SCRIPT_AssertCtrlLine:$/ { label=1 }
/SCRIPT_CtrlLineAssertedFlag/ { flag=1 }
/ORI\.W #32|#32|#\$20/ { or20=1 }
/SCRIPT_WriteCtrlShadowToSerdat/ { callw=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (flag) print "HAS_FLAG_WRITE"
    if (or20) print "HAS_OR_20"
    if (callw) print "HAS_WRITECALL"
    if (rts) print "HAS_RTS"
}
