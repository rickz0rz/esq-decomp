BEGIN {
    has_entry=0
    has_find=0
    has_draw=0
    has_parse=0
    has_nibble=0
    has_move=0
    has_textlen=0
    has_fallback_draw=0
    has_const30=0
    has_const23=0
    has_const19=0
    has_const20=0
    has_return=0
    first_primary=0
    first_secondary=0
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

    if (u ~ /^TLIBA1_DRAWINLINESTYLEDTEXT:/ || u ~ /^TLIBA1_DRAWINLINESTYLEDTEX[A-Z0-9_]*:/) has_entry=1
    if (n ~ /STRFINDCHARPTR/) has_find=1
    if (n ~ /TLIBA1DRAWTEXTWITHINSETSEGMENTS/) has_draw=1
    if (n ~ /TLIBA1PARSESTYLECODECHAR/) has_parse=1
    if (n ~ /TLIBA1JMPTBLLADFUNCEXTRACTHIGHNIBBLE/ || n ~ /TLIBA1JMPTBLLADFUNCEXTRACTLOWNIBBLE/ || n ~ /TLIBA1JMPTBLLADFUNCEXTRACTHIG/ || n ~ /TLIBA1JMPTBLLADFUNCEXTRACTLOW/) has_nibble=1
    if (n ~ /MEMMOVE/) has_move=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlen=1
    if (n ~ /UNKNOWNJMPTBLDISPLIBDISPLAYTEXTATPOSITION/ || n ~ /DISPLIBDISPLAYTEXTATPOSITION/ || n ~ /UNKNOWNJMPTBLDISPLIBDISPLAYTE/ || n ~ /DISPLIBDISPLAYTE/) has_fallback_draw=1
    if (first_primary==0 && n ~ /CLEANUPALIGNEDINSETNIBBLEPRIMAR/) first_primary=NR
    if (first_secondary==0 && n ~ /CLEANUPALIGNEDINSETNIBBLESECOND/) first_secondary=NR
    if (u ~ /#30([^0-9]|$)/ || u ~ /#\$1E/) has_const30=1
    if (u ~ /#23([^0-9]|$)/ || u ~ /#\$17/) has_const23=1
    if (u ~ /#19([^0-9]|$)/ || u ~ /#\$13/) has_const19=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/) has_const20=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_FIND="has_find
    print "HAS_DRAW_INSET="has_draw
    print "HAS_PARSE_STYLE="has_parse
    print "HAS_NIBBLE="has_nibble
    print "HAS_MEM_MOVE="has_move
    print "HAS_TEXT_LENGTH="has_textlen
    print "HAS_FALLBACK_DRAW="has_fallback_draw
    print "HAS_CONST_30="has_const30
    print "HAS_CONST_23="has_const23
    print "HAS_CONST_19="has_const19
    print "HAS_CONST_20="has_const20
    print "HAS_GATE_SECONDARY_BEFORE_PRIMARY="((first_secondary > 0 && first_primary > 0 && first_secondary < first_primary) ? 1 : 0)
    print "HAS_RETURN="has_return
}
