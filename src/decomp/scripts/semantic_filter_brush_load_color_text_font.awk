BEGIN {
    label = 0
    has_alloc_call = 0
    has_dealloc_call = 0
    has_read_call = 0
    has_size_96 = 0
    has_guard_fail = 0
    has_nibble_unpack = 0
    has_shift4 = 0
    has_success_one = 0
    has_fail_minus1 = 0
    has_return = 0
}

/^BRUSH_LoadColorTextFont:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /MEMORY_ALLOCATEMEMORY/) has_alloc_call = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/) has_dealloc_call = 1
    if (line ~ /LVOREAD/) has_read_call = 1
    if (line ~ /#96|96\.W|STRUCT_COLORTEXTFONT_SIZE|#\$60/) has_size_96 = 1
    if (line ~ /MOVEQ[[:space:]]*#-1,D0/) has_fail_minus1 = 1
    if (line ~ /MOVEQ[[:space:]]*#1,D0/) has_success_one = 1
    if (line ~ /CMP\.L|BLE|BGT|BEQ|BNE/) has_guard_fail = 1
    if (line ~ /\(A0\)\+/ || line ~ /\(A1\)\+/ || line ~ /MOVE\.B D0/) has_nibble_unpack = 1
    if (line ~ /ASR\.L[[:space:]]*#4|LSR\.|LSR[[:space:]]*#4/) has_shift4 = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_alloc_call) print "HAS_ALLOC_CALL"
    if (has_dealloc_call) print "HAS_DEALLOC_CALL"
    if (has_read_call) print "HAS_READ_CALL"
    if (has_size_96) print "HAS_SIZE_96"
    if (has_guard_fail) print "HAS_GUARD_FLOW"
    if (has_nibble_unpack) print "HAS_NIBBLE_UNPACK_FLOW"
    if (has_shift4) print "HAS_SHIFT4"
    if (has_success_one) print "HAS_SUCCESS_ONE"
    if (has_fail_minus1) print "HAS_FAIL_MINUS1"
    if (has_return) print "HAS_RTS"
}
