BEGIN {
    label=0; call=0; mplex=0; c60=0; c30=0; c29=0; c48=0; c1=0; rts=0
}

/^NEWGRID_ComputeDaySlotFromClockWithOffset:$/ { label=1 }
/NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex/ { call=1 }
/GCOMMAND_MplexClockOffsetMinutes/ { mplex=1 }
/#\$3c|#60([^0-9]|$)|60\.[Ww]/ { c60=1 }
/#\$1e|#30([^0-9]|$)|30\.[Ww]/ { c30=1 }
/#\$1d|#29([^0-9]|$)|29\.[Ww]/ { c29=1 }
/#\$30|#48([^0-9]|$)|48\.[Ww]/ { c48=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_HALFHOUR_CALL"
    if (mplex) print "HAS_MPLEX_OFFSET_GLOBAL"
    if (c60) print "HAS_CONST_60"
    if (c30) print "HAS_CONST_30"
    if (c29) print "HAS_CONST_29"
    if (c48) print "HAS_CONST_48"
    if (c1) print "HAS_CONST_1"
    if (rts) print "HAS_RTS"
}
