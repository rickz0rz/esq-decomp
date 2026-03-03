BEGIN { label=0; calld=0; rts=0 }
/^SCRIPT_DeassertCtrlLineNow:$/ { label=1 }
/SCRIPT_DeassertCtrlLine/ { calld=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (calld) print "HAS_DEASSERT_CALL"
    if (rts) print "HAS_RTS"
}
