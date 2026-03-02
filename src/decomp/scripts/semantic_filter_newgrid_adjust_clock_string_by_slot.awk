BEGIN {
    label=0; norm=0; div=0; mul=0; sec2=0; slot=0; c21=0; c30=0; c60=0; rts=0
}

/^NEWGRID_AdjustClockStringBySlot:$/ { label=1 }
/NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds/ { norm=1 }
/NEWGRID_JMPTBL_MATH_DivS32/ { div=1 }
/NEWGRID_JMPTBL_MATH_Mulu32/ { mul=1 }
/NEWGRID_JMPTBL_DATETIME_SecondsToStruct/ { sec2=1 }
/NEWGRID_ComputeDaySlotFromClock/ { slot=1 }
/#\$15|#21([^0-9]|$)|21\.[Ww]/ { c21=1 }
/#\$1e|#30([^0-9]|$)|30\.[Ww]/ { c30=1 }
/#\$3c|#60([^0-9]|$)|60\.[Ww]/ { c60=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (norm) print "HAS_NORMALIZE_CALL"
    if (div) print "HAS_DIV_CALL"
    if (mul) print "HAS_MUL_CALL"
    if (sec2) print "HAS_SECONDS_TO_STRUCT_CALL"
    if (slot) print "HAS_SLOT_CALL"
    if (c21) print "HAS_CONST_21"
    if (c30) print "HAS_CONST_30"
    if (c60) print "HAS_CONST_60"
    if (rts) print "HAS_RTS"
}
