BEGIN {
    has_entry = 0
    has_row_loop = 0
    has_row_count_store = 0
    has_col_loop = 0
    has_mul_call = 0
    has_seed_table_ref = 0
    has_value_store = 0
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

    if (u ~ /^GCOMMAND_INITPRESETTABLEFROMPALETTE:/ || u ~ /^GCOMMAND_INITPRESETTABLEFROMPALE[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #\$10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #16,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_row_loop = 1
    if (u ~ /^MOVE\.W #\$10,/ || u ~ /^MOVE\.W #16,/) has_row_count_store = 1
    if (u ~ /^ADDQ\.[LW] #\$1,D[0-7]$/ || u ~ /^ADDQ\.[LW] #1,D[0-7]$/ || u ~ /^BGE\.[A-Z]+ /) has_col_loop = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || index(u, "MULU32") > 0) has_mul_call = 1
    if (index(u, "GCOMMAND_PRESETSEEDPACKEDWORDTABLE") > 0 || index(u, "GCOMMAND_PRESETSEEDPACKEDWORDTAB") > 0) has_seed_table_ref = 1
    if (u ~ /^MOVE\.W \(A[0-7]\),32\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],32\(A[0-7]\)$/ || u ~ /^MOVE\.W \(A[0-7]\),\(A[0-7]\)$/) has_value_store = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROW_LOOP=" has_row_loop
    print "HAS_ROW_COUNT_STORE=" has_row_count_store
    print "HAS_COL_LOOP=" has_col_loop
    print "HAS_MUL_CALL=" has_mul_call
    print "HAS_SEED_TABLE_REF=" has_seed_table_ref
    print "HAS_VALUE_STORE=" has_value_store
    print "HAS_RETURN=" has_return
}
