BEGIN {
    has_label = 0
    has_setdrmd = 0
    has_setapen = 0
    has_move = 0
    has_draw = 0
    has_mode_bits = 0
    has_height_dec = 0
    has_four = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^BEVEL_DRAWVERTICALBEVEL[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOSETDRMD/) has_setdrmd = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVODRAW/) has_draw = 1
    if (u ~ /BSET #0,33\(A3\)/ || u ~ /ORI\.B #1/ || u ~ /OR\.B \(A0\),D1/ || u ~ /MOVE\.B D1,\(A0\)/ || u ~ /33\(A/) has_mode_bits = 1
    if (u ~ /SUBQ\.L #1,D0/ || u ~ /HEIGHT--/ || u ~ /SUBQ\.L #/) has_height_dec = 1
    if (u ~ /#4/ || u ~ /#\$4/) has_four = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_SETAPEN=" has_setapen
    print "HAS_MOVE=" has_move
    print "HAS_DRAW=" has_draw
    print "HAS_MODE_BITS=" has_mode_bits
    print "HAS_HEIGHT_DEC=" has_height_dec
    print "HAS_FOUR=" has_four
    print "HAS_RETURN=" has_return
}
