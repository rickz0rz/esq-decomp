BEGIN {
    has_setdrmd = 0
    has_setapen = 0
    saw_move_reg_bind = 0
    saw_draw_reg_bind = 0
    move_count = 0
    draw_count = 0
    has_return = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)

    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /LVOSETDRMD/) has_setdrmd = 1
    if (n ~ /LVOSETAPEN/) has_setapen = 1
    if (n ~ /LEALVOMOVEA5/) saw_move_reg_bind = 1
    if (n ~ /LEALVODRAWA3/) saw_draw_reg_bind = 1
    if (n ~ /LVOMOVE/) move_count++
    if (n ~ /LVODRAW/) draw_count++
    if (saw_move_reg_bind && u ~ /^JSR \(A5\)/) move_count++
    if (saw_draw_reg_bind && u ~ /^JSR \(A3\)/) draw_count++
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_SETAPEN=" has_setapen
    print "MOVE_COUNT_GE4=" (move_count >= 4 ? 1 : 0)
    print "DRAW_COUNT_GE4=" (draw_count >= 4 ? 1 : 0)
    print "HAS_RTS=" has_return
}
