BEGIN {
    has_entry = 0
    has_old_len_loop = 0
    has_dealloc_call = 0
    has_new_null_return = 0
    has_new_len_loop = 0
    has_empty_string_guard = 0
    has_availmem_check = 0
    has_alloc_call = 0
    has_copy_loop = 0
    has_return_branch = 0
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

    if (u ~ /^ESQPARS_REPLACEOWNEDSTRING:/ || u ~ /^ESQPARS_REPLACEOWNEDSTR[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^TST\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/ || index(u, "MEASURE_OLD_LEN_LOOP") > 0) has_old_len_loop = 1
    if (index(u, "DEALLOCATEMEMORY") > 0 || index(u, "DEALLOCATEMEM") > 0 || index(u, "DEALLOCATEM") > 0) has_dealloc_call = 1
    if (u ~ /^BEQ\.[SWB] \.CHECK_NEW_SOURCE$/ || u ~ /^BEQ\.[SWB] ___ESQPARS_REPLACEOWNEDSTR/ || u ~ /^MOVEQ\.L #\$0,D0$/) has_new_null_return = 1
    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^TST\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/ || index(u, "MEASURE_NEW_LEN_LOOP") > 0) has_new_len_loop = 1
    if (u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^CMP\.[LW] #\$1,D[0-7]$/ || u ~ /^CMP\.[LW] #1,D[0-7]$/ || u ~ /^SUBQ\.[LW] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[LW] #1,D[0-7]$/) has_empty_string_guard = 1
    if (index(u, "AVAILMEM") > 0 || u ~ /^CMPI\.L #\$2710,D0$/ || u ~ /^CMPI\.L #10000,D0$/) has_availmem_check = 1
    if (index(u, "ALLOCATEMEMORY") > 0 || index(u, "ALLOCATEMEM") > 0) has_alloc_call = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.[WL]\),\$0\(A[0-7],D[0-7]\.[WL]\)$/ || index(u, "COPY_LOOP") > 0) has_copy_loop = 1
    if (u ~ /^BRA\.[SWB] ESQPARS_REPLACEOWNEDSTRING_RETURN$/ || u ~ /^JMP ESQPARS_REPLACEOWNEDSTRING_RETURN$/ || u ~ /^BRA\.[SWB] ___ESQPARS_REPLACEOWNEDSTR/ || u == "RTS") has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OLD_LEN_LOOP=" has_old_len_loop
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_NEW_NULL_RETURN=" has_new_null_return
    print "HAS_NEW_LEN_LOOP=" has_new_len_loop
    print "HAS_EMPTY_STRING_GUARD=" has_empty_string_guard
    print "HAS_AVAILMEM_CHECK=" has_availmem_check
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_RETURN_BRANCH=" has_return_branch
}
