BEGIN {
    has_entry = 0
    has_alloc_call = 0
    has_dealloc_call = 0
    has_read_call = 0
    has_size_96 = 0
    has_guard_fail = 0
    has_nibble_unpack = 0
    has_shift4 = 0
    has_success_one = 0
    has_fail_minus1 = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /MEMORY_ALLOCATEMEMORY/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_alloc_call = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc_call = 1
    if (u ~ /LVOREAD/ || u ~ /_LVOREAD/) has_read_call = 1
    if (u ~ /#96|96\.W|STRUCT_COLORTEXTFONT_SIZE|#\$60|\(\$60\)\.W/) has_size_96 = 1
    if (u ~ /MOVEQ[[:space:]]*#-1,D0/ || u ~ /MOVEQ(\.L)? #\$FF,D0/ || u ~ /MOVEQ(\.L)? #\$FFFFFFFF,D0/) has_fail_minus1 = 1
    if (u ~ /MOVEQ[[:space:]]*#1,D0/ || u ~ /MOVEQ(\.L)? #\$1,D0/) has_success_one = 1
    if (u ~ /CMP\.L|BLE|BGT|BEQ|BNE|BGE|BLT/) has_guard_fail = 1
    if (u ~ /\(A0\)\+/ || u ~ /\(A1\)\+/ || u ~ /MOVE\.B D0/ || u ~ /MOVE\.B \(A[0-7]\),D0/) has_nibble_unpack = 1
    if (u ~ /ASR\.L[[:space:]]*#4|ASR\.L[[:space:]]*#\$4|LSR\.|LSR[[:space:]]*#4/) has_shift4 = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_READ_CALL=" has_read_call
    print "HAS_SIZE_96=" has_size_96
    print "HAS_GUARD_FLOW=" has_guard_fail
    print "HAS_NIBBLE_UNPACK_FLOW=" has_nibble_unpack
    print "HAS_SHIFT4=" has_shift4
    print "HAS_SUCCESS_ONE=" has_success_one
    print "HAS_FAIL_MINUS1=" has_fail_minus1
    print "HAS_RTS=" has_rts
}
