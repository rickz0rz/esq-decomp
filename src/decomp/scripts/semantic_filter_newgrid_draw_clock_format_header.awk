BEGIN {
    label=0; drmd=0; row=0; setpen=0; rect=0; bevel=0; fmt=0; mul=0; txtlen=0; move=0; text=0; valid=0;
    colstart=0; colw=0; c3=0; c17=0; c33=0; c35=0; c36=0; c48=0; c64=0; c695=0; rts=0
}

/^NEWGRID_DrawClockFormatHeader:$/ { label=1 }
/LVOSetDrMd|_LVOSetDrMd/ { drmd=1 }
/NEWGRID_SetRowColor/ { row=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVORectFill|_LVORectFill/ { rect=1 }
/NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight/ { bevel=1 }
/NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry/ { fmt=1 }
/NEWGRID_JMPTBL_MATH_Mulu32/ { mul=1 }
/LVOTextLength|_LVOTextLength/ { txtlen=1 }
/LVOMove|_LVOMove/ { move=1 }
/LVOText|_LVOText/ { text=1 }
/NEWGRID_ValidateSelectionCode/ { valid=1 }
/NEWGRID_ColumnStartXPx/ { colstart=1 }
/NEWGRID_ColumnWidthPx/ { colw=1 }
/#3([^0-9]|$)|#\$03|3\.[Ww]/ { c3=1 }
/#17([^0-9]|$)|#\$11|17\.[Ww]/ { c17=1 }
/#33([^0-9]|$)|#\$21|33\.[Ww]/ { c33=1 }
/#35([^0-9]|$)|#\$23|35\.[Ww]|\(35,/ { c35=1 }
/#36([^0-9]|$)|#\$24|36\.[Ww]|\(36,/ { c36=1 }
/#48([^0-9]|$)|#\$30|48\.[Ww]/ { c48=1 }
/#64([^0-9]|$)|#\$40|64\.[Ww]/ { c64=1 }
/#695|#\$2b7|695\.[Ww]/ { c695=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (drmd) print "HAS_SETDRMD_CALL"
    if (row) print "HAS_SETROWCOLOR_CALL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (rect) print "HAS_RECTFILL_CALL"
    if (bevel) print "HAS_BEVEL_CALL"
    if (fmt) print "HAS_FORMATENTRY_CALL"
    if (mul) print "HAS_MUL_CALL"
    if (txtlen) print "HAS_TEXTLENGTH_CALL"
    if (move) print "HAS_MOVE_CALL"
    if (text) print "HAS_TEXT_CALL"
    if (valid) print "HAS_VALIDATE_CALL"
    if (colstart) print "HAS_COLUMN_START"
    if (colw) print "HAS_COLUMN_WIDTH"
    if (c3) print "HAS_CONST_3"
    if (c17) print "HAS_CONST_17"
    if (c33) print "HAS_CONST_33"
    if (c35) print "HAS_CONST_35"
    if (c36) print "HAS_CONST_36"
    if (c48) print "HAS_CONST_48"
    if (c64) print "HAS_CONST_64"
    if (c695) print "HAS_CONST_695"
    if (rts) print "HAS_RTS"
}
