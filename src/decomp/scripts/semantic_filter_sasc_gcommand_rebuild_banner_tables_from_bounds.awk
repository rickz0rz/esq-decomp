BEGIN {
    has_entry = 0
    has_table_base = 0
    has_ui_seed = 0
    has_init_calls = 0
    has_row_loop_17 = 0
    has_fallback_refs = 0
    has_value_table_ref = 0
    has_row_writes = 0
    has_tick_call = 0
    has_clear_pending = 0
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

    if (u ~ /^GCOMMAND_REBUILDBANNERTABLESFROMBOUNDS:/ || u ~ /^GCOMMAND_REBUILDBANNERTABLESFROM[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "ESQ_COPPERLISTBANNERA") > 0 || index(u, "ESQ_COPPERLISTBANNERB") > 0) has_table_base = 1
    if (index(u, "GLOBAL_UIBUSYFLAG") > 0 || u ~ /^MOVEQ(\.L)? #\$11,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #17,D[0-7]$/) has_ui_seed = 1
    if (index(u, "GCOMMAND_INITPRESETWORKENTRY") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_init_calls = 1
    if (u ~ /^MOVEQ(\.L)? #\$11,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #17,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_row_loop_17 = 1
    if (index(u, "GCOMMAND_PRESETFALLBACKVALUE0") > 0 || index(u, "GCOMMAND_PRESETFALLBACKVALUE1") > 0 || index(u, "GCOMMAND_PRESETFALLBACKVALUE2") > 0 || index(u, "GCOMMAND_PRESETFALLBACKVALUE3") > 0) has_fallback_refs = 1
    if (index(u, "GCOMMAND_PRESETVALUETABLE") > 0) has_value_table_ref = 1
    if (u ~ /^MOVE\.W D[0-7],[0-9]+\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.W \(A[0-7]\),[0-9]+\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/) has_row_writes = 1
    if (index(u, "GCOMMAND_TICKPRESETWORKENTRIES") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_tick_call = 1
    if (index(u, "GCOMMAND_BANNERREBUILDPENDINGFLAG") > 0 || index(u, "GCOMMAND_BANNERREBUILDPENDINGFLA") > 0) has_clear_pending = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TABLE_BASE=" has_table_base
    print "HAS_UI_SEED=" has_ui_seed
    print "HAS_INIT_CALLS=" has_init_calls
    print "HAS_ROW_LOOP_17=" has_row_loop_17
    print "HAS_FALLBACK_REFS=" has_fallback_refs
    print "HAS_VALUE_TABLE_REF=" has_value_table_ref
    print "HAS_ROW_WRITES=" has_row_writes
    print "HAS_TICK_CALL=" has_tick_call
    print "HAS_CLEAR_PENDING=" has_clear_pending
    print "HAS_RETURN=" has_return
}
