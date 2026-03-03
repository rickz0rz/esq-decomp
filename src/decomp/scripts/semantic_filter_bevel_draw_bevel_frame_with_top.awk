BEGIN {
    has_call_vertical_pair = 0
    has_call_horizontal = 0
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
    if (n ~ /BEVELDRAWHORIZONTALBEVEL/) has_call_horizontal = 1
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_CALL_VERTICAL_PAIR=" has_call_vertical_pair
    print "HAS_CALL_HORIZONTAL=" has_call_horizontal
    print "HAS_RTS=" has_return
}
