BEGIN { label=0; calla=0; rts=0 }
/^SCRIPT_AssertCtrlLineNow:$/ { label=1 }
/SCRIPT_AssertCtrlLine/ { calla=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (calla) print "HAS_ASSERT_CALL"
    if (rts) print "HAS_RTS"
}
