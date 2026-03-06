BEGIN {
    saw_null_guard = 0
    saw_bound_reads = 0
    saw_value_compare = 0
    saw_return = 0
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

    if (u ~ /TST\\.L A3/ || u ~ /MOVE\\.L A3,D1/) saw_null_guard = 1
    if (u ~ /8\\(A3\\)/ || u ~ /12\\(A3\\)/) saw_bound_reads = 1
    if (u ~ /CMP\\.L D[0-7],D7/ || u ~ /CMP\\.L D7,D[0-7]/) saw_value_compare = 1
    if (u ~ /^RTS$/) saw_return = 1
}

END {
    print "HAS_NULL_GUARD=" saw_null_guard
    print "HAS_BOUND_READS=" saw_bound_reads
    print "HAS_VALUE_COMPARE=" saw_value_compare
    print "HAS_RTS=" saw_return
}
