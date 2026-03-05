BEGIN {
    has_list_head = 0
    has_bytes_total = 0
    has_min8 = 0
    has_neg1 = 0
    has_return0 = 0
    has_next_ptr = 0
    has_terminal = 0
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

    if (n ~ /GLOBALALLOCLISTHEAD/) has_list_head = 1
    if (n ~ /GLOBALALLOCBYTESTOTAL/) has_bytes_total = 1
    if (u ~ /#8/ || u ~ /[^0-9]8[^0-9]/) has_min8 = 1
    if (u ~ /-1/ || u ~ /#\$?FF/) has_neg1 = 1
    if (u ~ /#0/ || u ~ /[^0-9]0[^0-9]/) has_return0 = 1
    if (u ~ /\(A2\)/ || u ~ /NEXT|->NEXT/) has_next_ptr = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_LIST_HEAD=" has_list_head
    print "HAS_BYTES_TOTAL=" has_bytes_total
    print "HAS_MIN8=" has_min8
    print "HAS_NEG1=" has_neg1
    print "HAS_RETURN0=" has_return0
    print "HAS_NEXT_PTR=" has_next_ptr
    print "HAS_TERMINAL=" has_terminal
}
