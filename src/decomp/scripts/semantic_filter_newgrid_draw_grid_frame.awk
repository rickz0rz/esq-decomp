BEGIN {
    label=0
    setrow=0
    fill=0
    cneg1=0
    coff60=0
    czero=0
    rts=0
}

/^NEWGRID_DrawGridFrame:$/ { label=1 }
/NEWGRID_SetRowColor/ { setrow=1 }
/NEWGRID_FillGridRects/ { fill=1 }
/#\$ffffffff|#-1([^0-9]|$)|-1\.[Ww]/ { cneg1=1 }
/#\$3c|\(60,|60\(A3\)|60\(A[0-7]\)/ { coff60=1 }
/#\$00|#0([^0-9]|$)|\bCLR\./ { czero=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (setrow) print "HAS_SETROWCOLOR_CALL"
    if (fill) print "HAS_FILLGRIDRECTS_CALL"
    if (cneg1) print "HAS_CONST_NEG1"
    if (coff60) print "HAS_OFFSET_60"
    if (czero) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}
