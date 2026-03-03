BEGIN { label=0; gate=0; read5=0; tick=0; reset=0; c24=0; rts=0 }
/^SCRIPT_PollHandshakeAndApplyTimeout:$/ { label=1 }
/SCRIPT_CtrlInterfaceEnabledFlag/ { gate=1 }
/SCRIPT_ReadHandshakeBit5Mask/ { read5=1 }
/SCRIPT_CtrlLineAssertedTicks/ { tick=1 }
/ESQIFF_ExternalAssetFlags/ { reset=1 }
/#\$24|#36([^0-9]|$)/ { c24=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (gate) print "HAS_ENABLE_GATE"
    if (read5) print "HAS_READ5_CALL"
    if (tick) print "HAS_TICK_COUNTER"
    if (reset) print "HAS_RESET_FLAGS"
    if (c24) print "HAS_CONST_24"
    if (rts) print "HAS_RTS"
}
