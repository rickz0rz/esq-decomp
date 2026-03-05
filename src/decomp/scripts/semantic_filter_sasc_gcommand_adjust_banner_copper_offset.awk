BEGIN {
    has_entry = 0
    has_delta_test = 0
    has_table_a_ref = 0
    has_table_b_ref = 0
    has_range_check = 0
    has_add_call = 0
    has_update_call = 0
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

    if (u ~ /^GCOMMAND_ADJUSTBANNERCOPPEROFFSE[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^TST\.B D[0-7]$/ || u ~ /^TST\.B GCOMMAND_/ || u ~ /^BEQ\./) has_delta_test = 1

    if (index(u, "ESQ_COPPERLISTBANNERA") > 0) has_table_a_ref = 1
    if (index(u, "ESQ_COPPERLISTBANNERB") > 0) has_table_b_ref = 1

    if (u ~ /^MOVEQ(\.L)? #65,D[0-7]$/ || u ~ /^ADD\.L D[0-7],D[0-7]$/ || u ~ /^CMP\.L D[0-7],D[0-7]$/ || u ~ /^CMPI\.[LW] #\$82,D[0-7]$/ || u ~ /^CMPI\.[LW] #130,D[0-7]$/) has_range_check = 1

    if (index(u, "GCOMMAND_ADDBANNERTABLEBYTEDELTA") > 0) has_add_call = 1
    if (index(u, "GCOMMAND_UPDATEBANNEROFFSET") > 0) has_update_call = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DELTA_TEST=" has_delta_test
    print "HAS_TABLE_A_REF=" has_table_a_ref
    print "HAS_TABLE_B_REF=" has_table_b_ref
    print "HAS_RANGE_CHECK=" has_range_check
    print "HAS_ADD_CALL=" has_add_call
    print "HAS_UPDATE_CALL=" has_update_call
    print "HAS_RETURN=" has_return
}
