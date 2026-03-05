BEGIN {
    has_entry = 0
    has_row_range = 0
    has_inner_loop = 0
    has_nibble_mask = 0
    has_accumulate = 0
    has_set_call = 0
    has_return = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_EXPANDPRESETBLOCK:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$8,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #8,D[0-7]$/) has_row_range = 1
    if (u ~ /^MOVEQ(\.L)? #\$3,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #3,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_inner_loop = 1
    if (u ~ /^MOVEQ(\.L)? #\$F,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #15,D[0-7]$/ || u ~ /^AND\.[LW] D[0-7],D[0-7]$/) has_nibble_mask = 1
    if (u ~ /^ADD\.[LW] D[0-7],D[0-7]$/ || u ~ /^MOVE\.L D[0-7],D[0-7]$/) has_accumulate = 1
    if (index(u, "GCOMMAND_SETPRESETENTRY") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_set_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROW_RANGE=" has_row_range
    print "HAS_INNER_LOOP=" has_inner_loop
    print "HAS_NIBBLE_MASK=" has_nibble_mask
    print "HAS_ACCUMULATE=" has_accumulate
    print "HAS_SET_CALL=" has_set_call
    print "HAS_RETURN=" has_return
}
