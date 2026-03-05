BEGIN {
    has_entry = 0
    has_range_guard = 0
    has_one_seed = 0
    has_shift_to_mask = 0
    has_bset_to_mask = 0
    has_zero_return = 0
    has_rts = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /TST\.L [D][0-7]/) has_range_guard = 1
    if (u ~ /CMP(\.L|I\.L)? #?9,[D][0-7]/) has_range_guard = 1
    if (u ~ /MOVEQ(\.L)? #9,D0/ || u ~ /MOVEQ(\.L)? #\$9,D0/) has_range_guard = 1
    if (u ~ /SUBQ\.L #1,[D][0-7]/ || u ~ /MOVEQ #7,[D][0-7]/) has_range_guard = 1

    if (u ~ /MOVEQ(\.L)? #1,D0/ || u ~ /MOVEQ(\.L)? #\$1,D0/ || u ~ /MOVE\.L #1,D0/) has_one_seed = 1
    if (u ~ /ASL\.L [D][0-7],D0/ || u ~ /LSL\.L [D][0-7],D0/) has_shift_to_mask = 1
    if (u ~ /BSET [D][0-7],D[0-7]/) has_bset_to_mask = 1

    if (u ~ /MOVEQ(\.L)? #0,D0/ || u ~ /MOVEQ(\.L)? #\$0,D0/ || u ~ /CLR\.L D0/) has_zero_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RANGE_GUARD=" has_range_guard
    print "HAS_ONE_SEED=" (has_one_seed || has_bset_to_mask)
    print "HAS_SHIFT_TO_MASK=" (has_shift_to_mask || has_bset_to_mask)
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RTS=" has_rts
}
