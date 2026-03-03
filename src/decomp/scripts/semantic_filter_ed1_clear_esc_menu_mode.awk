BEGIN {
    has_entry = 0
    has_clr = 0
    has_rts = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^ED1_CLEARESCMENUMODE:/) has_entry = 1
    if (uline ~ /^CLR\.B ED_MENUSTATEID$/) has_clr = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLR=" has_clr
    print "HAS_RTS=" has_rts
}
