BEGIN {
    has_arg_loads = 0
    has_ret_seed = 0
    has_find_null_loop = 0
    has_backstep_or_equiv = 0
    has_copy_loop = 0
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

    if ((u ~ /^MOVEA?\.L .*A0$/) || (u ~ /^MOVEA?\.L .*A1$/)) has_arg_loads = 1
    if (u ~ /^MOVE\.L A0,D0$/ || u ~ /^MOVE\.L .*D0$/) has_ret_seed = 1

    if (u ~ /^TST\.B \(A0\)\+$/ || u ~ /^CMP\.B #0,\(A0\)\+$/ || u ~ /^TST\.B \(A[0-7]\)\+$/) has_find_null_loop = 1
    if (u ~ /^(BNE|BNE\.S|JNE|JNE\.S) /) has_find_null_loop = 1

    if (u ~ /^SUBQ\.L #1,A0$/ || u ~ /^SUBQ\.L #1,A[0-7]$/ || u ~ /^LEA -1\(A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.L A[0-7],A[0-7]$/) {
        has_backstep_or_equiv = 1
    }

    if (u ~ /^MOVE\.B \(A1\)\+,\(A0\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/) has_copy_loop = 1
    if (u ~ /^TST\.B -1\(A0\)$/ || u ~ /^CMP\.B #0,-1\(A0\)$/ || u ~ /^TST\.B -1\(A[0-7]\)$/) has_copy_loop = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ARG_LOADS=" has_arg_loads
    print "HAS_RET_SEED=" has_ret_seed
    print "HAS_FIND_NULL_LOOP=" has_find_null_loop
    print "HAS_BACKSTEP_OR_EQUIV=" has_backstep_or_equiv
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_RTS=" has_rts
}
