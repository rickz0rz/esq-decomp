BEGIN {
    label=0; setpen=0; rect=0; c7=0; c695=0; c1=0; ret=0
}

/^NEWGRID_DrawTopBorderLine:$/ { label=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVORectFill|_LVORectFill/ { rect=1 }
/#\$07|#7([^0-9]|$)|7\.[Ww]/ { c7=1 }
/#695|#\$2b7|695\.[Ww]/ { c695=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (rect) print "HAS_RECTFILL_CALL"
    if (c7) print "HAS_CONST_7"
    if (c695) print "HAS_CONST_695"
    if (c1) print "HAS_CONST_1"
    if (ret) print "HAS_RTS"
}
