BEGIN {
    has_arg_loads = 0
    has_ret_seed = 0
    has_copy_loop = 0
    has_copy_nul_break = 0
    has_pad_loop = 0
    has_len_countdown = 0
    has_return_dst = 0
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

    if (u ~ /^MOVEA?\.L .*A0$/ || u ~ /^MOVEA?\.L .*A1$/) has_arg_loads = 1
    if (u ~ /^MOVE\.L A0,D1$/ || u ~ /^MOVE\.L A[0-7],D1$/ || u ~ /^MOVE\.L \([0-9]+,SP\),D0$/) has_ret_seed = 1

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_copy_loop = 1
    if (u ~ /^BEQ(\.S)? / || u ~ /^JEQ(\.S)? /) has_copy_nul_break = 1

    if (u ~ /^CLR\.B \(A[0-7]\)\+$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)\+$/) has_pad_loop = 1

    if (u ~ /^SUBQ\.L #1,D0$/ || u ~ /^SUBQ\.L #1,D[0-7]$/ || u ~ /^DBRA D[0-7],/) has_len_countdown = 1
    if (u ~ /^BCC(\.S)? / || u ~ /^JCC /) has_len_countdown = 1

    if (u ~ /^MOVE\.L D1,D0$/ || u ~ /^MOVE\.L D[0-7],D0$/ || u ~ /^MOVE\.L \([0-9]+,SP\),D0$/) has_return_dst = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ARG_LOADS=" has_arg_loads
    print "HAS_RET_SEED=" has_ret_seed
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_COPY_NUL_BREAK=" has_copy_nul_break
    print "HAS_PAD_LOOP=" has_pad_loop
    print "HAS_LEN_COUNTDOWN=" has_len_countdown
    print "HAS_RETURN_DST=" has_return_dst
    print "HAS_RTS=" has_rts
}
