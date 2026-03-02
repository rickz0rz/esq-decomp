BEGIN {
    label=0; frame=0; setpen=0; txtlen=0; wrap=0; bevel=0; msg=0; rowh=0; c624=0; c612=0; c695=0; c36=0; c7=0; c4=0; c1=0; rts=0
}

/^NEWGRID_DrawAwaitingListingsMessage:$/ { label=1 }
/NEWGRID_DrawGridFrame/ { frame=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVOTextLength|_LVOTextLength/ { txtlen=1 }
/NEWGRID_DrawWrappedText/ { wrap=1 }
/NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight/ { bevel=1 }
/Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION/ { msg=1 }
/NEWGRID_RowHeightPx/ { rowh=1 }
/#624|#\$270|624\.[Ww]/ { c624=1 }
/#612|#\$264|612\.[Ww]/ { c612=1 }
/#695|#\$2b7|695\.[Ww]/ { c695=1 }
/#36|#\$24|36\.[Ww]/ { c36=1 }
/#7([^0-9]|$)|#\$07|7\.[Ww]/ { c7=1 }
/#4([^0-9]|$)|#\$04|4\.[Ww]/ { c4=1 }
/#1([^0-9]|$)|#\$01|1\.[Ww]/ { c1=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (frame) print "HAS_DRAWGRIDFRAME_CALL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (txtlen) print "HAS_TEXTLENGTH_CALL"
    if (wrap) print "HAS_DRAWWRAPPEDTEXT_CALL"
    if (bevel) print "HAS_BEVEL_CALL"
    if (msg) print "HAS_AWAITING_MSG_GLOBAL"
    if (rowh) print "HAS_ROWHEIGHT_GLOBAL"
    if (c624) print "HAS_CONST_624"
    if (c612) print "HAS_CONST_612"
    if (c695) print "HAS_CONST_695"
    if (c36) print "HAS_CONST_36"
    if (c7) print "HAS_CONST_7"
    if (c4) print "HAS_CONST_4"
    if (c1) print "HAS_CONST_1"
    if (rts) print "HAS_RTS"
}
