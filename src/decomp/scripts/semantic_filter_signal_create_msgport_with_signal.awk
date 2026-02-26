BEGIN {
    has_allocsignal_minus1 = 0
    has_allocsignal_call = 0
    has_signal_fail_guard = 0
    has_allocmem_size = 0
    has_allocmem_flags = 0
    has_allocmem_call = 0
    has_allocmem_fail_guard = 0
    has_freesignal_call = 0
    has_name_store = 0
    has_pri_store = 0
    has_type_store = 0
    has_flags_clear = 0
    has_sigbit_store = 0
    has_findtask_call = 0
    has_sigtask_store = 0
    has_addport_call = 0
    has_local_list_init = 0
    has_zero_return = 0
    has_ptr_return = 0
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

    if (u ~ /^MOVEQ #-1,D0$/ || u ~ /^MOVE\.L #-1,D0$/) has_allocsignal_minus1 = 1
    if (u ~ /JSR .*LVOALLOCSIGNAL/) has_allocsignal_call = 1
    if (u ~ /^CMPI\.B #\(-1\),D[0-7]$/ || u ~ /^CMP\.B #-1,D[0-7]$/ || u ~ /^CMPI\.L #-1,D[0-7]$/) has_signal_fail_guard = 1

    if (u ~ /^MOVEQ #34,D0$/ || u ~ /^MOVE\.L #34,D0$/) has_allocmem_size = 1
    if (u ~ /#\$?10001/ || u ~ /#65537/ || u ~ /MEMF_PUBLIC\+MEMF_CLEAR/) has_allocmem_flags = 1
    if (u ~ /JSR .*LVOALLOCMEM/) has_allocmem_call = 1
    if (u ~ /^MOVEA?\.L D0,A[0-7]$/ || u ~ /^TST\.L D0$/) has_allocmem_fail_guard = 1

    if (u ~ /JSR .*LVOFREESIGNAL/) has_freesignal_call = 1

    if (u ~ /^MOVE\.L A[0-7],[0-9]+\(A[0-7]\)$/ || u ~ /^MOVE\.L A[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /STRUCT_MSGPORT__MP_NODE\+STRUCT_NODE__LN_NAME/) has_name_store = 1
    if (u ~ /^MOVE\.B D[0-7],[0-9]+\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /STRUCT_MSGPORT__MP_NODE\+STRUCT_NODE__LN_PRI/) has_pri_store = 1
    if (u ~ /^MOVE\.B #4,[0-9]+\(A[0-7]\)$/ || u ~ /^MOVE\.B #4,\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.B #\(NT_MSGPORT\),/) has_type_store = 1
    if (u ~ /^CLR\.B [0-9]+\(A[0-7]\)$/ || u ~ /^CLR\.B \([0-9]+,A[0-7]\)$/ || u ~ /^CLR\.B STRUCT_MSGPORT__MP_FLAGS\(A[0-7]\)$/) has_flags_clear = 1
    if (u ~ /^MOVE\.B D[0-7],[0-9]+\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],STRUCT_MSGPORT__MP_SIGBIT\(A[0-7]\)$/) has_sigbit_store = 1

    if (u ~ /JSR .*LVOFINDTASK/) has_findtask_call = 1
    if (u ~ /^MOVE\.L D[0-7],[0-9]+\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],STRUCT_MSGPORT__MP_SIGTASK\(A[0-7]\)$/) has_sigtask_store = 1

    if (u ~ /JSR .*LVOADDPORT/) has_addport_call = 1

    if ((u ~ /^LEA 24\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \(24,A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.L A[0-7],20\(A[0-7]\)$/ || u ~ /^MOVE\.L A[0-7],\(20,A[0-7]\)$/) &&
        (u ~ /LEA 20\(A[0-7]\),A[0-7]/ || u ~ /LEA \(20,A[0-7]\),A[0-7]/ || u ~ /MOVE\.L A[0-7],28\(A[0-7]\)/ || u ~ /MOVE\.L A[0-7],\(28,A[0-7]\)/ || u ~ /CLR\.L 24\(A[0-7]\)/ || u ~ /CLR\.L \(24,A[0-7]\)/ || u ~ /MOVE\.B #\$?2,32\(A[0-7]\)/ || u ~ /MOVE\.B #\$?2,\(32,A[0-7]\)/)) {
        has_local_list_init = 1
    }
    if (u ~ /MOVE\.L A[0-7],20\(A[0-7]\)/ || u ~ /MOVE\.L A[0-7],\(20,A[0-7]\)/ || u ~ /MOVE\.L A[0-7],28\(A[0-7]\)/ || u ~ /MOVE\.L A[0-7],\(28,A[0-7]\)/ || u ~ /CLR\.L 24\(A[0-7]\)/ || u ~ /CLR\.L \(24,A[0-7]\)/ || u ~ /MOVE\.B #\$?2,32\(A[0-7]\)/ || u ~ /MOVE\.B #\$?2,\(32,A[0-7]\)/) {
        has_local_list_init = 1
    }

    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_zero_return = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVE\.L D[0-7],D0$/) has_ptr_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ALLOCSIGNAL_MINUS1=" has_allocsignal_minus1
    print "HAS_ALLOCSIGNAL_CALL=" has_allocsignal_call
    print "HAS_SIGNAL_FAIL_GUARD=" has_signal_fail_guard
    print "HAS_ALLOCMEM_SIZE=" has_allocmem_size
    print "HAS_ALLOCMEM_FLAGS=" has_allocmem_flags
    print "HAS_ALLOCMEM_CALL=" has_allocmem_call
    print "HAS_ALLOCMEM_FAIL_GUARD=" has_allocmem_fail_guard
    print "HAS_FREESIGNAL_CALL=" has_freesignal_call
    print "HAS_NAME_STORE=" has_name_store
    print "HAS_PRI_STORE=" has_pri_store
    print "HAS_TYPE_STORE=" has_type_store
    print "HAS_FLAGS_CLEAR=" has_flags_clear
    print "HAS_SIGBIT_STORE=" has_sigbit_store
    print "HAS_FINDTASK_CALL=" has_findtask_call
    print "HAS_SIGTASK_STORE=" has_sigtask_store
    print "HAS_ADDPORT_CALL=" has_addport_call
    print "HAS_LOCAL_LIST_INIT=" has_local_list_init
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_PTR_RETURN=" has_ptr_return
    print "HAS_RTS=" has_rts
}
