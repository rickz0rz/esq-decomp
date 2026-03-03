BEGIN {
    has_entry = 0
    has_loop_cmp = 0
    has_copy = 0
    has_inc = 0
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

    if (uline ~ /^ESQIFF_RESTOREBASEPALETTETRIPLES:/) has_entry = 1
    if (uline ~ /^CMP\.W D0,D7$/) has_loop_cmp = 1
    if (uline ~ /^MOVE\.B \(A1\),\(A0\)$/) has_copy = 1
    if (uline ~ /^ADDQ\.W #1,D7$/) has_inc = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_COPY=" has_copy
    print "HAS_INC=" has_inc
    print "HAS_RTS=" has_rts
}
