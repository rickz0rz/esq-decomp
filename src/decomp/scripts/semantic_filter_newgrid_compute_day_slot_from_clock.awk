BEGIN {
    label=0; call=0; c50=0; c20=0; c29=0; c48=0; c1=0; rts=0
}

/^NEWGRID_ComputeDaySlotFromClock:$/ { label=1 }
/NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex/ { call=1 }
/#\$32|#50([^0-9]|$)|50\.[Ww]|#49([^0-9]|$)|#\$31/ { c50=1 }
/#\$14|#20([^0-9]|$)|20\.[Ww]|#-20([^0-9]|$)|#\$ffec/ { c20=1 }
/#\$1d|#29([^0-9]|$)|29\.[Ww]|#9([^0-9]|$)|#\$09/ { c29=1 }
/#\$30|#48([^0-9]|$)|48\.[Ww]/ { c48=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_HALFHOUR_CALL"
    if (c50) print "HAS_CONST_50"
    if (c20) print "HAS_CONST_20"
    if (c29) print "HAS_CONST_29"
    if (c48) print "HAS_CONST_48"
    if (c1) print "HAS_CONST_1"
    if (rts) print "HAS_RTS"
}
