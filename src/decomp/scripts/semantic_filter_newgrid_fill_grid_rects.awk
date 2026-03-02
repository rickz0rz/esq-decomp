BEGIN {
    label=0
    setpen=0
    rectfill=0
    xpx=0
    c35=0
    c36=0
    c695=0
    rts=0
}

/^NEWGRID_FillGridRects:$/ { label=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVORectFill|_LVORectFill/ { rectfill=1 }
/NEWGRID_ColumnStartXPx/ { xpx=1 }
/#\$23|#35([^0-9]|$)|35\.[Ww]|\(35,/ { c35=1 }
/#\$24|#36([^0-9]|$)|36\.[Ww]|\(36,/ { c36=1 }
/#695|#\$2b7|695\.[Ww]/ { c695=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (rectfill) print "HAS_RECTFILL_CALL"
    if (xpx) print "HAS_COLUMN_START_X"
    if (c35) print "HAS_CONST_35"
    if (c36) print "HAS_CONST_36"
    if (c695) print "HAS_CONST_695"
    if (rts) print "HAS_RTS"
}
