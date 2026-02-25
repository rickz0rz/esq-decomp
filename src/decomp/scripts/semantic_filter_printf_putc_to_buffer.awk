BEGIN {
    has_counter_inc = 0
    has_ptr_load = 0
    has_byte_store = 0
    has_ptr_advance = 0
    has_ptr_store_back = 0
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

    if (u ~ /GLOBAL_PRINTFBYTECOUNT/ && (u ~ /^ADDQ\.L #1,/ || u ~ /^ADD\.L #1,/)) has_counter_inc = 1
    if (u ~ /GLOBAL_PRINTFBUFFERPTR/ && (u ~ /,A[0-7]$/ || u ~ /,D[0-7]$/)) has_ptr_load = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_byte_store = 1
    if (u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^LEA \(1,A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_ptr_advance = 1
    if (u ~ /GLOBAL_PRINTFBUFFERPTR/ && u ~ /^MOVE\.L A[0-7],/) has_ptr_store_back = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_COUNTER_INC=" has_counter_inc
    print "HAS_PTR_LOAD=" has_ptr_load
    print "HAS_BYTE_STORE=" has_byte_store
    print "HAS_PTR_ADVANCE=" has_ptr_advance
    print "HAS_PTR_STORE_BACK=" has_ptr_store_back
    print "HAS_RTS=" has_rts
}
