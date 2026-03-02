BEGIN {
    IGNORECASE=1
    label=0; c20=0; c0=0; rts=0
}

/^P_TYPE_GetSubtypeIfType20:$/ { label=1 }
/#20([^0-9]|$)|#\$14/ { c20=1 }
/#0([^0-9]|$)|#\$00|MOVEQ #0/ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (c20) print "HAS_CONST_20"
    if (c0) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}
