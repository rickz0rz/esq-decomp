BEGIN {
    label=0; dis=0; ena=0; reset=0; setpen=0; rect=0; c7=0; c68=0; c695=0; c267=0; ret=0
}

/^NEWGRID_ClearHighlightArea:$/ { label=1 }
/LVODisable|_LVODisable/ { dis=1 }
/LVOEnable|_LVOEnable/ { ena=1 }
/GCOMMAND_ResetHighlightMessages/ { reset=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVORectFill|_LVORectFill/ { rect=1 }
/#\$07|#7([^0-9]|$)|7\.[Ww]/ { c7=1 }
/#\$44|#68([^0-9]|$)|68\.[Ww]/ { c68=1 }
/#695|#\$2b7|695\.[Ww]/ { c695=1 }
/#267|#\$10b|267\.[Ww]/ { c267=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (dis) print "HAS_DISABLE_CALL"
    if (ena) print "HAS_ENABLE_CALL"
    if (reset) print "HAS_RESET_HILITE_CALL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (rect) print "HAS_RECTFILL_CALL"
    if (c7) print "HAS_CONST_7"
    if (c68) print "HAS_CONST_68"
    if (c695) print "HAS_CONST_695"
    if (c267) print "HAS_CONST_267"
    if (ret) print "HAS_RTS"
}
