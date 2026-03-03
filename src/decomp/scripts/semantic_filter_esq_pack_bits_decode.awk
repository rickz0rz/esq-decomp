BEGIN {
    has_signed_run_test = 0
    has_literal_copy = 0
    has_repeat_copy = 0
    has_ff_skip = 0
    has_output_limit_cmp = 0
    has_return_src = 0
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

    if (u ~ /TST\.B D[0-7]/ || u ~ /BMI(\.W|\.S)? / || u ~ /BPL(\.W|\.S)? / || u ~ /^JLT / || u ~ /^JGE / || u ~ /^BLT(\.W|\.S)? / || u ~ /^BGE(\.W|\.S)? /) has_signed_run_test = 1
    if (u ~ /MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+/) has_literal_copy = 1
    if (u ~ /MOVE\.B D[0-7],\(A[0-7]\)\+/ || u ~ /MOVE\.B \(A[0-7]\),\(A[0-7]\)\+/) has_repeat_copy = 1
    if (u ~ /CMPI\.[BWL] #\$?FF,D[0-7]/ || u ~ /CMP\.[BWL] #\$?FF,D[0-7]/ || u ~ /CMP\.B #-1,D[0-7]/ || u ~ /CMPI\.B #-1,D[0-7]/) has_ff_skip = 1
    if (u ~ /^CMP\.[BWL] D[0-7],D[0-7]/ || u ~ /^CMPI\.[BWL] .*D[0-7]/) has_output_limit_cmp = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/) has_return_src = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGNED_RUN_TEST=" has_signed_run_test
    print "HAS_LITERAL_COPY=" has_literal_copy
    print "HAS_REPEAT_COPY=" has_repeat_copy
    print "HAS_FF_SKIP=" has_ff_skip
    print "HAS_OUTPUT_LIMIT_CMP=" has_output_limit_cmp
    print "HAS_RETURN_SRC=" has_return_src
    print "HAS_RTS=" has_rts
}
