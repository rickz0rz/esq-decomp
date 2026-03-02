BEGIN {
    label=0; gen=0; drmd=0; row=0; setpen=0; rect=0; bevel=0; txtlen=0; move=0; text=0;
    colstart=0; colw=0; c7=0; c3=0; c33=0; c35=0; c36=0; c695=0; c17=0; rts=0
}

/^NEWGRID_DrawDateBanner:$/ { label=1 }
/NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING/ { gen=1 }
/LVOSetDrMd|_LVOSetDrMd/ { drmd=1 }
/NEWGRID_SetRowColor/ { row=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVORectFill|_LVORectFill/ { rect=1 }
/NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight/ { bevel=1 }
/LVOTextLength|_LVOTextLength/ { txtlen=1 }
/LVOMove|_LVOMove/ { move=1 }
/LVOText|_LVOText/ { text=1 }
/NEWGRID_ColumnStartXPx/ { colstart=1 }
/NEWGRID_ColumnWidthPx/ { colw=1 }
/#7([^0-9]|$)|#\$07|7\.[Ww]/ { c7=1 }
/#3([^0-9]|$)|#\$03|3\.[Ww]/ { c3=1 }
/#33([^0-9]|$)|#\$21|33\.[Ww]/ { c33=1 }
/#35([^0-9]|$)|#\$23|35\.[Ww]/ { c35=1 }
/#36([^0-9]|$)|#\$24|36\.[Ww]|\(36,/ { c36=1 }
/#695|#\$2b7|695\.[Ww]/ { c695=1 }
/#17([^0-9]|$)|#\$11|17\.[Ww]/ { c17=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (gen) print "HAS_GENERATE_DATE_CALL"
    if (drmd) print "HAS_SETDRMD_CALL"
    if (row) print "HAS_SETROWCOLOR_CALL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (rect) print "HAS_RECTFILL_CALL"
    if (bevel) print "HAS_BEVEL_CALL"
    if (txtlen) print "HAS_TEXTLENGTH_CALL"
    if (move) print "HAS_MOVE_CALL"
    if (text) print "HAS_TEXT_CALL"
    if (colstart) print "HAS_COLUMN_START"
    if (colw) print "HAS_COLUMN_WIDTH"
    if (c7) print "HAS_CONST_7"
    if (c3) print "HAS_CONST_3"
    if (c33) print "HAS_CONST_33"
    if (c35) print "HAS_CONST_35"
    if (c36) print "HAS_CONST_36"
    if (c695) print "HAS_CONST_695"
    if (c17) print "HAS_CONST_17"
    if (rts) print "HAS_RTS"
}
