BEGIN {
    has_check_call = 0
    has_branch = 0
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

    if (u ~ /PARALLEL_CHECKREADY/ || u ~ /JSR \(A[0-7]\)/ || u ~ /BSR .*PARALLEL_CHECKREADY/) has_check_call = 1
    if ((u ~ /^B[A-Z]+/ || u ~ /^J[A-Z]+/) && u !~ /^JSR/) has_branch = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_CHECK_CALL=" has_check_call
    print "HAS_BRANCH=" has_branch
    print "HAS_RTS=" has_rts
}
