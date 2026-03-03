BEGIN {
    has_entry = 0
    has_save = 0
    has_ptr = 0
    has_delta = 0
    has_add = 0
    has_restore = 0
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

    if (uline ~ /^GCOMMAND_ADDBANNERTABLEBYTEDELTA:/) has_entry = 1
    if (uline ~ /^MOVEM\.L D7\/A3,-\(A7\)$/) has_save = 1
    if (uline ~ /^MOVEA\.L 12\(A7\),A3$/) has_ptr = 1
    if (uline ~ /^MOVE\.B 19\(A7\),D7$/) has_delta = 1
    if (uline ~ /^ADD\.B D7,\(A3\)$/) has_add = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D7\/A3$/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_PTR=" has_ptr
    print "HAS_DELTA=" has_delta
    print "HAS_ADD=" has_add
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
