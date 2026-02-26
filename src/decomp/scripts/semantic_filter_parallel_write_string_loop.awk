BEGIN {
    has_byte_load = 0
    has_zero_check = 0
    has_write_call = 0
    has_loop_branch = 0
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

    if (u ~ /MOVE\.B .*\(A[0-7]\)\+,D[0-7]/ || u ~ /MOVE\.B .*\(A[0-7]\),D[0-7]/) has_byte_load = 1
    if (u ~ /^BEQ/ || u ~ /^JEQ/ || u ~ /^BNE/ || u ~ /^JNE/ || u ~ /TST\.B/ || u ~ /CMP\.B[[:space:]]+#0,/) has_zero_check = 1
    if (u ~ /PARALLEL_WRITECHARD0/ || u ~ /JSR .*\(A[0-7]\)/ || u ~ /BSR .*PARALLEL_WRITECHARD0/) has_write_call = 1
    if ((u ~ /^BRA/ || u ~ /^J[A-Z]+/) && u !~ /^JSR/) has_loop_branch = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_BYTE_LOAD=" has_byte_load
    print "HAS_ZERO_CHECK=" has_zero_check
    print "HAS_WRITE_CALL=" has_write_call
    print "HAS_LOOP_BRANCH=" has_loop_branch
    print "HAS_RTS=" has_rts
}
