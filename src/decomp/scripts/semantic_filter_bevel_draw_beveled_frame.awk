BEGIN {
    has_call_vertical_pair = 0
    has_call_vertical = 0
    has_pen2 = 0
    has_move = 0
    has_draw = 0
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

    if (n ~ /BEVELDRAWVERTICALBEVELPAIR/) has_call_vertical_pair = 1
    if (n ~ /BEVELDRAWVERTICALBEVEL/ && n !~ /PAIR/) has_call_vertical = 1
    if (u ~ /MOVEQ #2,D0/ || u ~ /MOVE\.L #2,D0/ || u ~ /MOVE\.W #2,D0/ || u ~ /PEA 2\.W/) has_pen2 = 1
    if (n ~ /LVOMOVE/) has_move = 1
    if (n ~ /LVODRAW/) has_draw = 1
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_CALL_VERTICAL_PAIR=" has_call_vertical_pair
    print "HAS_CALL_VERTICAL=" has_call_vertical
    print "HAS_SETAPEN_2=" has_pen2
    print "HAS_MOVE=" has_move
    print "HAS_DRAW=" has_draw
    print "HAS_RTS=" has_return
}
