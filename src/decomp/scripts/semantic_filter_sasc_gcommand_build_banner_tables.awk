BEGIN {
    has_entry = 0
    has_disable = 0
    has_enable = 0
    has_reset_preset = 0
    has_clear_queue = 0
    has_copy_call = 0
    has_table_a_ref = 0
    has_table_b_ref = 0
    has_phase_zero = 0
    has_slots_seed = 0
    has_row_index_seed = 0
    has_highlight_enable = 0
    has_readmode_seed = 0
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

    if (u ~ /^GCOMMAND_BUILDBANNERTABLE[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "_LVODISABLE") > 0) has_disable = 1
    if (index(u, "_LVOENABLE") > 0) has_enable = 1

    if (index(u, "GCOMMAND_RESETPRESETWORKTABLES") > 0) has_reset_preset = 1
    if (index(u, "GCOMMAND_CLEARBANNERQUEUE") > 0) has_clear_queue = 1
    if (index(u, "GCOMMAND_COPYIMAGEDATATOBITMAP") > 0) has_copy_call = 1

    if (index(u, "ESQ_COPPERLISTBANNERA") > 0) has_table_a_ref = 1
    if (index(u, "ESQ_COPPERLISTBANNERB") > 0) has_table_b_ref = 1

    if (index(u, "GCOMMAND_BANNERPHASEINDEXCURRENT") > 0 && (u ~ /^CLR\.L / || u ~ /^MOVE\.L D[0-7],/ || u ~ /^MOVE\.L #\$0,/)) has_phase_zero = 1

    if ((u ~ /^MOVEQ(\.L)? #97,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$61,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #96,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$60,D[0-7]$/) ||
        ((index(u, "GCOMMAND_BANNERQUEUESLOTPREVIOUS") > 0 || index(u, "GCOMMAND_BANNERQUEUESLOTCURRENT") > 0) && (u ~ /^MOVE\.W / || u ~ /^SUBQ\.W #\$1,D[0-7]$/))) has_slots_seed = 1

    if ((u ~ /^MOVEQ(\.L)? #84,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$54,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #85,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$55,D[0-7]$/) ||
        ((index(u, "GCOMMAND_BANNERROWINDEXPREVIOUS") > 0 || index(u, "GCOMMAND_BANNERROWINDEXCURRENT") > 0) && u ~ /^MOVE\.L /)) has_row_index_seed = 1

    if (index(u, "ED2_HIGHLIGHTTICKENABLEDFLAG") > 0 && u ~ /^MOVE\.W /) has_highlight_enable = 1
    if (index(u, "ESQPARS2_READMODEFLAGS") > 0 && (u ~ /^MOVE\.W #\$100,/ || u ~ /^MOVE\.W #256,/ || u ~ /^MOVE\.W D[0-7],/)) has_readmode_seed = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DISABLE=" has_disable
    print "HAS_ENABLE=" has_enable
    print "HAS_RESET_PRESET=" has_reset_preset
    print "HAS_CLEAR_QUEUE=" has_clear_queue
    print "HAS_COPY_CALL=" has_copy_call
    print "HAS_TABLE_A_REF=" has_table_a_ref
    print "HAS_TABLE_B_REF=" has_table_b_ref
    print "HAS_PHASE_ZERO=" has_phase_zero
    print "HAS_SLOTS_SEED=" has_slots_seed
    print "HAS_ROW_INDEX_SEED=" has_row_index_seed
    print "HAS_HIGHLIGHT_ENABLE=" has_highlight_enable
    print "HAS_READMODE_SEED=" has_readmode_seed
    print "HAS_RETURN=" has_return
}
