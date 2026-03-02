BEGIN {
    has_stack_load = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /4\(A7\)/ || u ~ /\(4,SP\)/) has_stack_load = 1
}

END {
    print "HAS_STACK_LOAD=" has_stack_load
}
