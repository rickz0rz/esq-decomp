BEGIN {
    has_entry=0
    has_find=0
    has_draw=0
    has_parse=0
    has_nibble=0
    has_textlen=0
    has_fallback_draw=0
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

    if (u ~ /^TLIBA1_DRAWINLINESTYLEDTEXT:/ || u ~ /^TLIBA1_DRAWINLINESTYLEDTEX[A-Z0-9_]*:/) has_entry=1
    if (n ~ /STRFINDCHARPTR/) has_find=1
    if (n ~ /TLIBA1DRAWTEXTWITHINSETSEGMENTS/) has_draw=1
    if (n ~ /TLIBA1PARSESTYLECODECHAR/) has_parse=1
    if (n ~ /TLIBA1JMPTBLLADFUNCEXTRACTHIGHNIBBLE/ || n ~ /TLIBA1JMPTBLLADFUNCEXTRACTLOWNIBBLE/ || n ~ /TLIBA1JMPTBLLADFUNCEXTRACTHIG/ || n ~ /TLIBA1JMPTBLLADFUNCEXTRACTLOW/) has_nibble=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlen=1
    if (n ~ /UNKNOWNJMPTBLDISPLIBDISPLAYTEXTATPOSITION/ || n ~ /DISPLIBDISPLAYTEXTATPOSITION/ || n ~ /UNKNOWNJMPTBLDISPLIBDISPLAYTE/ || n ~ /DISPLIBDISPLAYTE/) has_fallback_draw=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_FIND="has_find
    print "HAS_DRAW_INSET="has_draw
    print "HAS_PARSE_STYLE="has_parse
    print "HAS_NIBBLE="has_nibble
    print "HAS_TEXT_LENGTH="has_textlen
    print "HAS_FALLBACK_DRAW="has_fallback_draw
    print "HAS_RETURN="has_return
}
