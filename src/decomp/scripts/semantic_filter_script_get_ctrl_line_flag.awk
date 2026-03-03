BEGIN { label=0; readf=0; rts=0 }
/^SCRIPT_GetCtrlLineFlag:$/ { label=1 }
/SCRIPT_CtrlLineAssertedFlag/ { readf=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (readf) print "HAS_FLAG_READ"
    if (rts) print "HAS_RTS"
}
