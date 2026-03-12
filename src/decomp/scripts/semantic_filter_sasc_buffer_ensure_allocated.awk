BEGIN {
    has_entry = 0
    has_capacity_test = 0
    has_force_realloc_test = 0
    has_alloc_call = 0
    has_cursor_store = 0
    has_base_store = 0
    has_alloc_fail_path = 0
    has_app_error_12 = 0
    has_fail_return = 0
    has_capacity_store = 0
    has_openflags_mask = 0
    has_read_write_clear = 0
    has_success_return = 0
    has_rts = 0
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

    if (u ~ /^BUFFER_ENSUREALLOCATED:/) has_entry = 1
    if ((u ~ /BUFFERCAPACITY/ && (u ~ /^TST\.L / || u ~ /^CMP\.L #\$?0,/)) || u ~ /^TST\.L \$14\(A[0-7]\)$/ || u ~ /^TST\.L \$1C\(A[0-7]\)$/) has_capacity_test = 1
    if (u ~ /^BTST #/ || u ~ /^ANDI?\.L #\$?8,D[0-7]/) has_force_realloc_test = 1
    if (u ~ /ALLOC_ALLOCFROMFREELIST/) has_alloc_call = 1
    if (u ~ /BUFFERCURSOR/ || u ~ /^MOVE\.L (D|A)[0-7],\$4\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\$C\(A[0-7]\)$/) has_cursor_store = 1
    if (u ~ /BUFFERBASE/ || u ~ /^MOVE\.L (D|A)[0-7],\$10\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\$8\(A[0-7]\)$/) has_base_store = 1
    if ((u ~ /^TST\.L D0$/ || u ~ /^CMP\.L #\$?0,D0$/) && (u ~ /BEQ|BNE|BMI|BPL/)) has_alloc_fail_path = 1
    if ((u ~ /^MOVEQ(\.L)? #\$?12,D[0-7]$/ || u ~ /^MOVE\.L #\$?12,D[0-7]$/) || u ~ /GLOBAL_APPERRORCODE/) has_app_error_12 = 1
    if (u ~ /^MOVEQ(\.L)? #\-1,D0$/ || u ~ /^MOVE\.L #\-1,D0$/ || u ~ /^MOVEQ(\.L)? #\$?FF,D0$/) has_fail_return = 1
    if ((u ~ /BUFFERCAPACITY/ && u ~ /GLOBAL_STREAMBUFFERALLOCSIZE/) || u ~ /^MOVE\.L GLOBAL_STREAMBUFFERALLOCSIZE\(A4\),\$14\(A[0-7]\)$/ || u ~ /^MOVE\.L GLOBAL_STREAMBUFFERALLOCSIZE\(A4\),\$1C\(A[0-7]\)$/) has_capacity_store = 1
    if (u ~ /AND(\.L|I\.L|I\.W)? #\$?FFFFFFF3/ || u ~ /AND(\.L|I\.L|I\.W)? #\-13/ || u ~ /^AND\.L D[0-7],\$18\(A[0-7]\)$/ || (u ~ /^AND\.L D[0-7],/ && u ~ /OPENFLAGS/) || u ~ /^MOVEQ(\.L)? #\$?F3,D[0-7]$/) has_openflags_mask = 1
    if (u ~ /WRITEREMAINING/ || u ~ /READREMAINING/ || u ~ /^CLR\.L \$C\(A[0-7]\)$/ || u ~ /^CLR\.L \$8\(A[0-7]\)$/ || u ~ /^CLR\.L \$14\(A[0-7]\)$/ || u ~ /^CLR\.L \$10\(A[0-7]\)$/) has_read_write_clear = 1
    if (u ~ /^MOVEQ(\.L)? #\$?0,D0$/ || u ~ /^CLR\.L D0$/) has_success_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CAPACITY_TEST=" has_capacity_test
    print "HAS_FORCE_REALLOC_TEST=" has_force_realloc_test
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_CURSOR_STORE=" has_cursor_store
    print "HAS_BASE_STORE=" has_base_store
    print "HAS_ALLOC_FAIL_PATH=" has_alloc_fail_path
    print "HAS_APP_ERROR_12=" has_app_error_12
    print "HAS_FAIL_RETURN=" has_fail_return
    print "HAS_CAPACITY_STORE=" has_capacity_store
    print "HAS_OPENFLAGS_MASK=" has_openflags_mask
    print "HAS_READ_WRITE_CLEAR=" has_read_write_clear
    print "HAS_SUCCESS_RETURN=" has_success_return
    print "HAS_RTS=" has_rts
}
