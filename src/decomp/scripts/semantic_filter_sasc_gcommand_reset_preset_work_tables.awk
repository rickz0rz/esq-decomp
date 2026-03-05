BEGIN {
    has_entry = 0
    has_loop_bound_4 = 0
    has_table_ref = 0
    has_seed_index = 0
    has_zero_fields = 0
    has_reset_pending = 0
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

    if (u ~ /^GCOMMAND_RESETPRESETWORKTABLES[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^MOVEQ(\.L)? #4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^CMPI\.[LW] #4,D[0-7]$/ || u ~ /^CMPI\.[LW] #\$4,D[0-7]$/) has_loop_bound_4 = 1

    if (index(u, "GCOMMAND_PRESETWORKENTRYTABLE") > 0 || index(u, "GCOMMAND_PRESETWORKENTRYTABL") > 0) has_table_ref = 1

    if (u ~ /^ADDQ\.L #\$4,D[0-7]$/ || u ~ /^ADDQ\.L #4,D[0-7]$/ || u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/) has_seed_index = 1

    if (u ~ /^MOVE\.L D[0-7],4\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],8\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],12\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],16\(A[0-7]\)$/ || u ~ /^CLR\.L 4\(A[0-7]\)$/ || u ~ /^CLR\.L 8\(A[0-7]\)$/ || u ~ /^CLR\.L 12\(A[0-7]\)$/ || u ~ /^CLR\.L 16\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\$4\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.L \$4\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.L \$8\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.L \$C\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.L \$10\(A[0-7],D[0-7]\.[WL]\)$/) has_zero_fields = 1

    if ((index(u, "GCOMMAND_PRESETWORKRESETPENDINGFLAG") > 0 || index(u, "GCOMMAND_PRESETWORKRESETPENDINGF") > 0) && (u ~ /^CLR\.W / || u ~ /^MOVE\.W /)) has_reset_pending = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND_4=" has_loop_bound_4
    print "HAS_TABLE_REF=" has_table_ref
    print "HAS_SEED_INDEX=" has_seed_index
    print "HAS_ZERO_FIELDS=" has_zero_fields
    print "HAS_RESET_PENDING=" has_reset_pending
    print "HAS_RETURN=" has_return
}
