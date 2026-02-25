BEGIN {
    has_load_arg = 0
    has_store_self_head = 0
    has_bump_head_by4 = 0
    has_clear_next = 0
    has_store_self_tail = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^MOVEA\.L .*A0$/ || u ~ /^MOVE\.L .*A0$/) has_load_arg = 1

    if (u ~ /^MOVE\.L A0,\(A0\)$/ || u ~ /^MOVE\.L A[0-7],\(A[0-7]\)$/) has_store_self_head = 1

    if (u ~ /^ADDQ\.L #4,\(A0\)$/ || u ~ /^ADD\.L #4,\(A0\)$/ || u ~ /^ADDQ\.L #4,\(A[0-7]\)$/ || u ~ /^ADD\.L #4,\(A[0-7]\)$/ || u ~ /^LEA \(4,A[0-7]\),A[0-7]$/) {
        has_bump_head_by4 = 1
    }

    if (u ~ /^CLR\.L 4\(A0\)$/ || u ~ /^MOVE\.L #0,4\(A0\)$/ || u ~ /^CLR\.L 4\(A[0-7]\)$/ || u ~ /^MOVE\.L #0,4\(A[0-7]\)$/ || u ~ /^CLR\.L \(4,A[0-7]\)$/ || u ~ /^MOVE\.L #0,\(4,A[0-7]\)$/) {
        has_clear_next = 1
    }

    if (u ~ /^MOVE\.L A0,8\(A0\)$/ || u ~ /^MOVE\.L A[0-7],8\(A[0-7]\)$/ || u ~ /^MOVE\.L A[0-7],\(8,A[0-7]\)$/) has_store_self_tail = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LOAD_ARG=" has_load_arg
    print "HAS_STORE_SELF_HEAD=" has_store_self_head
    print "HAS_BUMP_HEAD_BY4=" has_bump_head_by4
    print "HAS_CLEAR_NEXT=" has_clear_next
    print "HAS_STORE_SELF_TAIL=" has_store_self_tail
    print "HAS_RTS=" has_rts
}
