BEGIN {
    has_entry = 0
    has_link = 0
    has_ptr = 0
    has_zero = 0
    has_load = 0
    has_unlk = 0
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

    if (uline ~ /^GCOMMAND_GETBANNERCHAR:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-4$/) has_link = 1
    if (uline ~ /^MOVE\.L #ESQ_COPPERLISTBANNERA,-4\(A5\)$/) has_ptr = 1
    if (uline ~ /^MOVEQ #0,D0$/) has_zero = 1
    if (uline ~ /^MOVE\.B \(A0\),D0$/) has_load = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_PTR=" has_ptr
    print "HAS_ZERO=" has_zero
    print "HAS_LOAD=" has_load
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
