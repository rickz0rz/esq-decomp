BEGIN {
    has_setdrmd = 0
    has_setapen1 = 0
    has_setapen2 = 0
    saw_move_reg_bind = 0
    saw_move_reg_bind_a4 = 0
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
    if (u ~ /MOVEQ #1,D0/ || u ~ /PEA 1\.W/) has_setapen1 = 1
    if (u ~ /MOVEQ #2,D0/ || u ~ /PEA 2\.W/) has_setapen2 = 1
    if (n ~ /LEALVOMOVEA5/) saw_move_reg_bind = 1
    if (n ~ /LEALVOMOVEA4/) saw_move_reg_bind_a4 = 1
    if (n ~ /LEALVODRAWA3/) saw_draw_reg_bind = 1
    if (n ~ /LVOMOVE/) move_count++
    if (n ~ /LVODRAW/) draw_count++
    if (saw_move_reg_bind && u ~ /^JSR \(A5\)/) move_count++
    if (saw_move_reg_bind_a4 && u ~ /^JSR \(A4\)/) move_count++
    if (saw_draw_reg_bind && u ~ /^JSR \(A3\)/) draw_count++
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_SETAPEN_1=" has_setapen1
    print "HAS_SETAPEN_2=" has_setapen2
    print "MOVE_COUNT_GE8=" (move_count >= 8 ? 1 : 0)
    print "DRAW_COUNT_GE8=" (draw_count >= 8 ? 1 : 0)
    print "HAS_RTS=" has_return
}
