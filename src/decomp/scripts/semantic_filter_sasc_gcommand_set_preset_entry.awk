BEGIN {
    has_entry = 0
    has_index_min_guard = 0
    has_index_max_guard = 0
    has_value_min_guard = 0
    has_value_max_guard = 0
    has_stride_shift = 0
    has_table_store = 0
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

    if (u ~ /^GCOMMAND_SETPRESETENTRY:/ || u ~ /^GCOMMAND_SETPRESETENTR[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^TST\.[LW] D[0-7]$/ || u ~ /^BLE\.[SWB] GCOMMAND_SETPRESETENTRY_RETURN$/) has_index_min_guard = 1
    if (u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #16,D[0-7]$/) has_index_max_guard = 1
    if (u ~ /^BMI\.[SWB] GCOMMAND_SETPRESETENTRY_RETURN$/ || u ~ /^TST\.[LW] D[0-7]$/) has_value_min_guard = 1
    if (u ~ /^CMPI\.[LW] #\$1000,D[0-7]$/ || u ~ /^CMPI\.[LW] #4096,D[0-7]$/ || u ~ /^BGE\.[SWB] GCOMMAND_SETPRESETENTRY_RETURN$/) has_value_max_guard = 1
    if (u ~ /^ASL\.[LW] #\$7,D[0-7]$/ || u ~ /^ASL\.[LW] #7,D[0-7]$/) has_stride_shift = 1
    if ((index(u, "GCOMMAND_PRESETVALUETABLE") > 0 && (u ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],\$0\(A[0-7]\)$/)) || u ~ /^MOVE\.W D[0-7],\$0\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],\$0\(A[0-7]\)$/) has_table_store = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_MIN_GUARD=" has_index_min_guard
    print "HAS_INDEX_MAX_GUARD=" has_index_max_guard
    print "HAS_VALUE_MIN_GUARD=" has_value_min_guard
    print "HAS_VALUE_MAX_GUARD=" has_value_max_guard
    print "HAS_STRIDE_SHIFT=" has_stride_shift
    print "HAS_TABLE_STORE=" has_table_store
    print "HAS_RETURN=" has_return
}
