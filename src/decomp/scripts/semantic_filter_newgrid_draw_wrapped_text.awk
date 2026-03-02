BEGIN {
    label=0; skip=0; copy=0; txtlen=0; move=0; text=0; single=0; wsp=0; wrsp=0;
    c50=0; c1=0; c0=0; rts=0
}

/^NEWGRID_DrawWrappedText:$/ { label=1 }
/NEWGRID2_JMPTBL_STR_SkipClass3Chars/ { skip=1 }
/NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN/ { copy=1 }
/LVOTextLength|_LVOTextLength/ { txtlen=1 }
/LVOMove|_LVOMove/ { move=1 }
/LVOText|_LVOText/ { text=1 }
/Global_STR_SINGLE_SPACE/ { single=1 }
/NEWGRID_WrapWordSpacer/ { wsp=1 }
/NEWGRID_WrapReturnSpacer/ { wrsp=1 }
/#50([^0-9]|$)|#\$32|50\.[Ww]/ { c50=1 }
/#1([^0-9]|$)|#\$01|1\.[Ww]/ { c1=1 }
/#0([^0-9]|$)|#\$00|\bCLR\./ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (skip) print "HAS_SKIPCLASS3_CALL"
    if (copy) print "HAS_COPYUNTIL_CALL"
    if (txtlen) print "HAS_TEXTLENGTH_CALL"
    if (move) print "HAS_MOVE_CALL"
    if (text) print "HAS_TEXT_CALL"
    if (single) print "HAS_SINGLE_SPACE_GLOBAL"
    if (wsp) print "HAS_WORD_SPACER"
    if (wrsp) print "HAS_RETURN_SPACER"
    if (c50) print "HAS_CONST_50"
    if (c1) print "HAS_CONST_1"
    if (c0) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}
