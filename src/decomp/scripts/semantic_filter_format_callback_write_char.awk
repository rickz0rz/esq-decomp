BEGIN {
    has_counter_inc = 0
    has_buffer_ptr_load = 0
    has_space_decrement = 0
    has_overflow_branch = 0
    has_write_ptr_advance = 0
    has_store_byte = 0
    has_overflow_call = 0
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

    if (u ~ /GLOBAL_FORMATCALLBACKBYTECOUNT/ && (u ~ /^ADDQ\.L #1,/ || u ~ /^ADD\.L #1,/)) has_counter_inc = 1
    if (u ~ /GLOBAL_FORMATCALLBACKBUFFERPTR/) has_buffer_ptr_load = 1
    if (u ~ /^SUBQ\.L #1,[0-9]+\((A[0-7]|A0)\)$/ || u ~ /^SUBQ\.L #1,\([0-9]+,A[0-7]\)$/ || u ~ /^SUBQ\.L #1,D[0-7]$/) has_space_decrement = 1
    if (u ~ /^MOVE\.L D[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],[0-9]+\((A[0-7]|A0)\)$/) has_space_decrement = 1
    if (u ~ /^(BLT|BLT\.S|JLT|JLT\.S) / || u ~ /^(BMI|BMI\.S) /) has_overflow_branch = 1
    if (u ~ /^LEA 1\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \(1,A[0-7]\),A[0-7]$/ || u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^MOVE\.L A[0-7],[0-9]+\((A[0-7]|A0)\)$/ || u ~ /^MOVE\.L A[0-7],\([0-9]+,A[0-7]\)$/) has_write_ptr_advance = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\([0-9]+,A[0-7]\)$/) has_store_byte = 1
    if (u ~ /STREAM_BUFFEREDPUTCORFLUSH/) has_overflow_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_COUNTER_INC=" has_counter_inc
    print "HAS_BUFFER_PTR_LOAD=" has_buffer_ptr_load
    print "HAS_SPACE_DECREMENT=" has_space_decrement
    print "HAS_OVERFLOW_BRANCH=" has_overflow_branch
    print "HAS_WRITE_PTR_ADVANCE=" has_write_ptr_advance
    print "HAS_STORE_BYTE=" has_store_byte
    print "HAS_OVERFLOW_CALL=" has_overflow_call
    print "HAS_RTS=" has_rts
}
