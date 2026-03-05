BEGIN {
    has_entry = 0
    has_value_load = 0
    has_negative_guard = 0
    has_init_ptrs = 0
    has_loop_bound = 0
    has_compute_call = 0
    has_store_result = 0
    has_ptr_advance = 0
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

    if (u ~ /^GCOMMAND_UPDATEPRESETENTRYCACHE:/ || u ~ /^GCOMMAND_UPDATEPRESETENTRYCAC[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.L \(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L [0-9]+\(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L \$[0-9A-F]+\((A[0-7])\),D[0-7]$/) has_value_load = 1
    if (u ~ /^TST\.[LW] D[0-7]$/ || u ~ /^BMI\.[SWB] GCOMMAND_UPDATEPRESETENTRYCACHE_RETURN$/) has_negative_guard = 1
    if (u ~ /^LEA [0-9]+\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$[0-9A-F]+\((A[0-7])\),A[0-7]$/) has_init_ptrs = 1
    if (u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #4,D[0-7]$/) has_loop_bound = 1
    if (index(u, "GCOMMAND_COMPUTEPRESETINCREMENT") > 0 || index(u, "COMPUTEPRESETINCREMENT") > 0) has_compute_call = 1
    if (u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\$0\(A[0-7]\)$/) has_store_result = 1
    if (u ~ /^ADDQ\.[LW] #\$1,D[0-7]$/ || u ~ /^ADDQ\.[LW] #1,D[0-7]$/ || u ~ /^ADDQ\.[LW] #\$4,-[0-9]+\((A5)\)$/ || u ~ /^ADDQ\.[LW] #4,-[0-9]+\((A5)\)$/ || u ~ /^ADDQ\.[LW] #\$1,-[0-9]+\((A5)\)$/ || u ~ /^ADDQ\.[LW] #1,-[0-9]+\((A5)\)$/) has_ptr_advance = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_VALUE_LOAD=" has_value_load
    print "HAS_NEGATIVE_GUARD=" has_negative_guard
    print "HAS_INIT_PTRS=" has_init_ptrs
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_COMPUTE_CALL=" has_compute_call
    print "HAS_STORE_RESULT=" has_store_result
    print "HAS_PTR_ADVANCE=" has_ptr_advance
    print "HAS_RETURN=" has_return
}
