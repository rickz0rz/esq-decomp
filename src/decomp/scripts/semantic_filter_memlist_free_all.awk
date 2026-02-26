BEGIN {
    has_head_load = 0
    has_next_load = 0
    has_size_load = 0
    has_freemem_call = 0
    has_loop_branch = 0
    has_clear_head = 0
    has_clear_tail = 0
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

    if (u ~ /GLOBAL_MEMLISTHEAD/) has_head_load = 1
    if (u ~ /^MOVEA?\.L \(A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.L \(A[0-7]\),D[0-7]$/) has_next_load = 1
    if (u ~ /^MOVE\.L 8\(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L \(8,A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L \(8,A[0-7]\),-\((A7|SP)\)$/) has_size_load = 1
    if (u ~ /JSR .*LVOFREEMEM/ || u ~ /JSR .*EXEC_FREE_MEM/ || u ~ /^JSR \(A[0-7]\)$/) has_freemem_call = 1
    if (u ~ /BRA\./ || u ~ /JNE / || u ~ /JRA /) has_loop_branch = 1
    if (u ~ /GLOBAL_MEMLISTHEAD/ && (u ~ /^MOVE\.L A[0-7],GLOBAL_MEMLISTHEAD/ || u ~ /^CLR\.L GLOBAL_MEMLISTHEAD/ || u ~ /^MOVE\.L #0,GLOBAL_MEMLISTHEAD/)) has_clear_head = 1
    if (u ~ /GLOBAL_MEMLISTTAIL/ && (u ~ /^MOVE\.L A[0-7],GLOBAL_MEMLISTTAIL/ || u ~ /^CLR\.L GLOBAL_MEMLISTTAIL/ || u ~ /^MOVE\.L #0,GLOBAL_MEMLISTTAIL/)) has_clear_tail = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_HEAD_LOAD=" has_head_load
    print "HAS_NEXT_LOAD=" has_next_load
    print "HAS_SIZE_LOAD=" has_size_load
    print "HAS_FREEMEM_CALL=" has_freemem_call
    print "HAS_LOOP_BRANCH=" has_loop_branch
    print "HAS_CLEAR_HEAD=" has_clear_head
    print "HAS_CLEAR_TAIL=" has_clear_tail
    print "HAS_RTS=" has_rts
}
