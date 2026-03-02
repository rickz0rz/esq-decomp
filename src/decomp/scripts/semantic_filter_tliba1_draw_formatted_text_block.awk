BEGIN {
    label=0; draw=0; divs=0; mulu=0; alloc=0; dealloc=0; setpen=0; setfont=0; tlen=0;
    c24=0; c25=0; c6=0; c10=0; c8=0; c2115=0; c2385=0; ret=0
}

/^TLIBA1_DrawFormattedTextBlock:$/ { label=1 }
/TLIBA1_DrawInlineStyledText/ { draw=1 }
/MATH_DivS32/ { divs=1 }
/MATH_Mulu32/ { mulu=1 }
/MEMORY_AllocateMemory/ { alloc=1 }
/MEMORY_DeallocateMemory/ { dealloc=1 }
/LVOSetAPen|_LVOSetAPen/ { setpen=1 }
/LVOSetFont|_LVOSetFont/ { setfont=1 }
/LVOTextLength|_LVOTextLength/ { tlen=1 }
/#\$18|#24([^0-9]|$)|#-24/ { c24=1 }
/#\$19|#25([^0-9]|$)|#1([^0-9]|$)/ { c25=1 }
/#\$06|#6([^0-9]|$)/ { c6=1 }
/#\$0a|#10([^0-9]|$)|10\.[Ww]/ { c10=1 }
/#\$08|#8([^0-9]|$)/ { c8=1 }
/#2115/ { c2115=1 }
/#2385/ { c2385=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (draw) print "HAS_DRAW_INLINE_CALL"
    if (divs) print "HAS_DIVS_CALL"
    if (mulu) print "HAS_MULU_CALL"
    if (alloc) print "HAS_ALLOC_CALL"
    if (dealloc) print "HAS_DEALLOC_CALL"
    if (setpen) print "HAS_SETAPEN_CALL"
    if (setfont) print "HAS_SETFONT_CALL"
    if (tlen) print "HAS_TEXT_LENGTH_CALL"
    if (c24) print "HAS_CONST_24"
    if (c25) print "HAS_CONST_25"
    if (c6) print "HAS_CONST_6"
    if (c10) print "HAS_CONST_10"
    if (c8) print "HAS_CONST_8"
    if (c2115) print "HAS_CONST_2115"
    if (c2385) print "HAS_CONST_2385"
    if (ret) print "HAS_RTS"
}
