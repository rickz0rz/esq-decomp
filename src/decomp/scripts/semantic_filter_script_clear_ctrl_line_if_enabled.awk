BEGIN { label=0; gate=0; callc=0; rts=0 }
/^SCRIPT_ClearCtrlLineIfEnabled:$/ { label=1 }
/SCRIPT_CtrlInterfaceEnabledFlag/ { gate=1 }
/SCRIPT_DeassertCtrlLine/ { callc=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (gate) print "HAS_ENABLE_GATE"
    if (callc) print "HAS_DEASSERT_CALL"
    if (rts) print "HAS_RTS"
}
