BEGIN {
    has_setdrmd = 0
    has_setapen2 = 0
    has_setapen6 = 0
    saw_move_reg_bind_a5 = 0
    saw_move_reg_bind_a4 = 0
    saw_draw_reg_bind_a4 = 0
    saw_draw_reg_bind_a3 = 0
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
    if (u ~ /MOVEQ #2,D0/ || u ~ /PEA 2\.W/) has_setapen2 = 1
    if (u ~ /MOVEQ #6,D0/ || u ~ /PEA 6\.W/) has_setapen6 = 1
    if (n ~ /LEALVOMOVEA5/) saw_move_reg_bind_a5 = 1
    if (n ~ /LEALVOMOVEA4/) saw_move_reg_bind_a4 = 1
    if (n ~ /LEALVODRAWA4/) saw_draw_reg_bind_a4 = 1
    if (n ~ /LEALVODRAWA3/) saw_draw_reg_bind_a3 = 1
    if (n ~ /LVOMOVE/) move_count++
    if (n ~ /LVODRAW/) draw_count++
    if (saw_move_reg_bind_a5 && u ~ /^JSR \(A5\)/) move_count++
    if (saw_move_reg_bind_a4 && u ~ /^JSR \(A4\)/) move_count++
    if (saw_draw_reg_bind_a4 && u ~ /^JSR \(A4\)/) draw_count++
    if (saw_draw_reg_bind_a3 && u ~ /^JSR \(A3\)/) draw_count++
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_SETAPEN_2=" has_setapen2
    print "HAS_SETAPEN_6=" has_setapen6
    print "MOVE_COUNT_GE5=" (move_count >= 5 ? 1 : 0)
    print "DRAW_COUNT_GE5=" (draw_count >= 5 ? 1 : 0)
    print "HAS_RTS=" has_return
}
