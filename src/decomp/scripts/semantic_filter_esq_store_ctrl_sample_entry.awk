BEGIN {
    has_ring_table = 0
    has_ring_index = 0
    has_scratch = 0
    has_mul5 = 0
    has_copy_loop = 0
    has_cmp20 = 0
    has_store_index = 0
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

    if (u ~ /ED_STATERINGTABLE/) has_ring_table = 1
    if (u ~ /ED_STATERINGWRITEINDEX/) has_ring_index = 1
    if (u ~ /CTRL_SAMPLEENTRYSCRATCH/) has_scratch = 1

    if (u ~ /#5,D[0-7]/ || u ~ /MULS #5/ || u ~ /LSL\.[BWL] #2,D[0-7]/) has_mul5 = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/ || u ~ /^BNE(\.S)? / || u ~ /^JNE /) has_copy_loop = 1
    if (u ~ /#20,D[0-7]/ || u ~ /#\$?14,D[0-7]/ || u ~ /#19,D[0-7]/ || u ~ /#\$?13,D[0-7]/) has_cmp20 = 1
    if (u ~ /MOVE\.L D[0-7],ED_STATERINGWRITEINDEX/ || u ~ /ED_STATERINGWRITEINDEX/) has_store_index = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_RING_TABLE=" has_ring_table
    print "HAS_RING_INDEX=" has_ring_index
    print "HAS_SCRATCH=" has_scratch
    print "HAS_MUL5=" has_mul5
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_CMP20=" has_cmp20
    print "HAS_STORE_INDEX=" has_store_index
    print "HAS_RTS=" has_rts
}
