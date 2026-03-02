BEGIN {
    label=0; fill=0; c1=0; c6=0; ret=0
}

/^NEWGRID_DrawGridTopBars:$/ { label=1 }
/NEWGRID_FillGridRects/ { fill=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/#\$06|#6([^0-9]|$)|6\.[Ww]/ { c6=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (fill) print "HAS_FILL_CALL"
    if (c1) print "HAS_CONST_1"
    if (c6) print "HAS_CONST_6"
    if (ret) print "HAS_RTS"
}
