BEGIN {
    has_entry=0
    has_draw_inline=0
    has_divs=0
    has_mulu=0
    has_alloc=0
    has_dealloc=0
    has_setpen=0
    has_setfont=0
    has_textlen=0
    has_const24=0
    has_const25=0
    has_const6=0
    has_const10=0
    has_const8=0
    has_const2115=0
    has_const2385=0
    has_return=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TLIBA1_DRAWFORMATTEDTEXTBLOCK:/ || u ~ /^TLIBA1_DRAWFORMATTEDTEXTBLOC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA1DRAWINLINESTYLEDTEXT/ || n ~ /TLIBA1DRAWINLINESTYLED/) has_draw_inline=1
    if (n ~ /MATHDIVS32/) has_divs=1
    if (n ~ /MATHMULU32/) has_mulu=1
    if (n ~ /MEMORYALLOCATEMEMORY/) has_alloc=1
    if (n ~ /MEMORYDEALLOCATEMEMORY/) has_dealloc=1
    if (n ~ /LVOSETAPEN/) has_setpen=1
    if (n ~ /LVOSETFONT/) has_setfont=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlen=1
    if (u ~ /#24/ || u ~ /#\$18/) has_const24=1
    if (u ~ /#25/ || u ~ /#\$19/) has_const25=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/) has_const6=1
    if (u ~ /#10/ || u ~ /#\$0A/ || u ~ /#\$A([^0-9A-F]|$)/ || u ~ /\(\$A\)/) has_const10=1
    if (u ~ /#8([^0-9]|$)/ || u ~ /#\$08/ || u ~ /#\$8([^0-9A-F]|$)/) has_const8=1
    if (u ~ /2115/ || u ~ /#\$843/ || u ~ /\$843/) has_const2115=1
    if (u ~ /2385/ || u ~ /#\$951/ || u ~ /\$951/) has_const2385=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_INLINE="has_draw_inline
    print "HAS_DIVS="has_divs
    print "HAS_MULU="has_mulu
    print "HAS_ALLOC="has_alloc
    print "HAS_DEALLOC="has_dealloc
    print "HAS_SETAPEN="has_setpen
    print "HAS_SETFONT="has_setfont
    print "HAS_TEXT_LENGTH="has_textlen
    print "HAS_CONST_24="has_const24
    print "HAS_CONST_25="has_const25
    print "HAS_CONST_6="has_const6
    print "HAS_CONST_10="has_const10
    print "HAS_CONST_8="has_const8
    print "HAS_CONST_2115="has_const2115
    print "HAS_CONST_2385="has_const2385
    print "HAS_RETURN="has_return
}
