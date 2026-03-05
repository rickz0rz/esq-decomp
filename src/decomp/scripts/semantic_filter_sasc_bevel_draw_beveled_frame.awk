BEGIN {
    has_label = 0
    has_vert_pair = 0
    has_vert = 0
    has_setapen = 0
    has_move = 0
    has_draw = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^BEVEL_DRAWBEVELEDFRAME[A-Z0-9_]*:/) has_label = 1
    if (u ~ /BEVEL_DRAWVERTICALBEVELPAIR/) has_vert_pair = 1
    if (u ~ /BEVEL_DRAWVERTICALBEVEL/) has_vert = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVODRAW/) has_draw = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_VERT_PAIR=" has_vert_pair
    print "HAS_VERT=" has_vert
    print "HAS_SETAPEN=" has_setapen
    print "HAS_MOVE=" has_move
    print "HAS_DRAW=" has_draw
    print "HAS_RETURN=" has_return
}
