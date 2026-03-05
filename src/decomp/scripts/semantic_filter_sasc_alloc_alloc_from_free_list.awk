BEGIN {
    has_entry = 0
    has_nonpos_guard = 0
    has_min8 = 0
    has_align4 = 0
    has_list_scan = 0
    has_exact_take = 0
    has_split_take = 0
    has_total_sub = 0
    has_div_call = 0
    has_mul_call = 0
    has_alloc_call = 0
    has_insert_call = 0
    has_recurse_call = 0
    has_zero_return = 0
    has_rts = 0
    saw_nonpos_cmp = 0
    saw_nonpos_branch = 0
    saw_align_add = 0
    saw_align_mask = 0
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

    if (u ~ /^ALLOC_ALLOCFROMFREELIST:/) has_entry = 1
    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMP\.L #\$?0,D[0-7]$/) saw_nonpos_cmp = 1
    if (u ~ /^(BGT|BGT\.S|BGT\.B|BLE|BLE\.S|BLE\.B|BMI|BMI\.S|BMI\.B|BEQ|BEQ\.S|BEQ\.B) /) saw_nonpos_branch = 1
    if (u ~ /MOVEQ(\.L)? #\$?8,D[0-7]/ || u ~ /CMP\.L #\$?8,D[0-7]/) has_min8 = 1
    if (u ~ /ADDQ\.L #\$?3,D[0-7]/ || u ~ /ADDI\.L #\$?3,D[0-7]/) saw_align_add = 1
    if (u ~ /ANDI\.W #\$?FFFC,D[0-7]/ || u ~ /ANDI\.W #\$?FFFFFFFC,D[0-7]/ || u ~ /AND\.L #\$?FFFFFFFC,D[0-7]/ || u ~ /ANDI\.L #\$?FFFFFFFC,D[0-7]/) saw_align_mask = 1
    if (u ~ /GLOBAL_ALLOCLISTHEAD/ || u ~ /\(A[0-7]\),A[0-7]/) has_list_scan = 1
    if (u ~ /^CMP\.L D[0-7],D[0-7]$/ || u ~ /^CMP\.L [0-9]+\((A[0-7]|A0)\),D[0-7]$/) has_exact_take = 1
    if (u ~ /SUB\.L D[0-7],D[0-7]/ || u ~ /ADDA?\.L D[0-7],A[0-7]/) has_split_take = 1
    if (u ~ /GLOBAL_ALLOCBYTESTOTAL/) has_total_sub = 1
    if (u ~ /MATH_DIVS32/) has_div_call = 1
    if (u ~ /MATH_MULU32/) has_mul_call = 1
    if (u ~ /MEMLIST_ALLOCTRACKED/) has_alloc_call = 1
    if (u ~ /ALLOC_INSERTFREEBLOCK/) has_insert_call = 1
    if (u ~ /ALLOC_ALLOCFROMFREELIST/ && u !~ /^ALLOC_ALLOCFROMFREELIST:/) has_recurse_call = 1
    if (u ~ /^MOVEQ(\.L)? #\$?0,D0$/ || u ~ /^CLR\.L D0$/) has_zero_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (saw_nonpos_cmp && saw_nonpos_branch) has_nonpos_guard = 1
    if (saw_align_add && saw_align_mask) has_align4 = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_NONPOS_GUARD=" has_nonpos_guard
    print "HAS_MIN8=" has_min8
    print "HAS_ALIGN4=" has_align4
    print "HAS_LIST_SCAN=" has_list_scan
    print "HAS_EXACT_TAKE=" has_exact_take
    print "HAS_SPLIT_TAKE=" has_split_take
    print "HAS_TOTAL_SUB=" has_total_sub
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_MUL_CALL=" has_mul_call
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_INSERT_CALL=" has_insert_call
    print "HAS_RECURSE_CALL=" has_recurse_call
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RTS=" has_rts
}
