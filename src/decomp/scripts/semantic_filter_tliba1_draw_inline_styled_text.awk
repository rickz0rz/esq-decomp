BEGIN {
    label=0; find=0; draw=0; parse=0; mem=0; tex=0; hi=0; lo=0; disp=0;
    c19=0; c20=0; c23=0; c30=0; c32=0; c8=0; c7=0; c1=0; ret=0
}

/^TLIBA1_DrawInlineStyledText:$/ { label=1 }
/STR_FindCharPtr/ { find=1 }
/TLIBA1_DrawTextWithInsetSegments/ { draw=1 }
/TLIBA1_ParseStyleCodeChar/ { parse=1 }
/MEM_Move/ { mem=1 }
/LVOTextLength|_LVOTextLength/ { tex=1 }
/TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble/ { hi=1 }
/TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble/ { lo=1 }
/DISPLIB_DisplayTextAtPosition/ { disp=1 }
/#\$13|#19|19\.[Ww]/ { c19=1 }
/#\$14|#20|20\.[Ww]/ { c20=1 }
/#\$17|#23|23\.[Ww]/ { c23=1 }
/#\$1e|#30|30\.[Ww]/ { c30=1 }
/#\$20|#32|#-32/ { c32=1 }
/#\$08|#8([^0-9]|$)/ { c8=1 }
/#\$07|#7([^0-9]|$)|#6([^0-9]|$)/ { c7=1 }
/#\$01|#1([^0-9]|$)/ { c1=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (find) print "HAS_FIND_CALL"
    if (draw) print "HAS_DRAW_INSET_CALL"
    if (parse) print "HAS_PARSE_STYLE_CALL"
    if (mem) print "HAS_MEM_MOVE_CALL"
    if (tex) print "HAS_TEXT_LENGTH_CALL"
    if (hi) print "HAS_HIGH_NIBBLE_CALL"
    if (lo) print "HAS_LOW_NIBBLE_CALL"
    if (disp) print "HAS_DISPLAY_CALL"
    if (c19) print "HAS_CONST_19"
    if (c20) print "HAS_CONST_20"
    if (c23) print "HAS_CONST_23"
    if (c30) print "HAS_CONST_30"
    if (c32) print "HAS_CONST_32"
    if (c8) print "HAS_CONST_8"
    if (c7) print "HAS_CONST_7"
    if (c1) print "HAS_CONST_1"
    if (ret) print "HAS_RTS"
}
