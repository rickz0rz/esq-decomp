BEGIN {
    has_entry = 0
    has_seed_logic = 0
    has_init_calls = 0
    has_loop = 0
    has_header_words = 0
    has_color_loads = 0
    has_ptr_words = 0
    has_tick_call = 0
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

    if (u ~ /^GCOMMAND_BUILDBANNERBLOCK:/) has_entry = 1
    if (index(u, "GLOBAL_UIBUSYFLAG") > 0 || index(u, "GCOMMAND_COMPUTEPRESETINCREMENT") > 0) has_seed_logic = 1
    if (index(u, "GCOMMAND_INITPRESETWORKENTRY") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_init_calls = 1
    if (u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^ADDQ\.[LW] #\$1,-[0-9]+\((A5)\)$/ || u ~ /^ADDQ\.[LW] #1,-[0-9]+\((A5)\)$/ || u ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #32,D[0-7]$/) has_loop = 1
    if (u ~ /^MOVE\.W #\$188,/ || u ~ /^MOVE\.W #\$18A,/ || u ~ /^MOVE\.W #\$18C,/ || u ~ /^MOVE\.W #\$18E,/ || u ~ /^MOVE\.W #\$84,/ || u ~ /^MOVE\.W #\$86,/ || u ~ /^MOVE\.W #\$8A,/) has_header_words = 1
    if (index(u, "GCOMMAND_PRESETVALUETABLE") > 0 || index(u, "GCOMMAND_PRESETFALLBACKVALUE") > 0) has_color_loads = 1
    if (u ~ /^SWAP D[0-7]$/ || u ~ /^ANDI\.L #\$FFFF,D[0-7]$/ || u ~ /^MOVE\.W D[0-7],22\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],26\(A[0-7]\)$/) has_ptr_words = 1
    if (index(u, "GCOMMAND_TICKPRESETWORKENTRIES") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_tick_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SEED_LOGIC=" has_seed_logic
    print "HAS_INIT_CALLS=" has_init_calls
    print "HAS_LOOP=" has_loop
    print "HAS_HEADER_WORDS=" has_header_words
    print "HAS_COLOR_LOADS=" has_color_loads
    print "HAS_PTR_WORDS=" has_ptr_words
    print "HAS_TICK_CALL=" has_tick_call
    print "HAS_RETURN=" has_return
}
