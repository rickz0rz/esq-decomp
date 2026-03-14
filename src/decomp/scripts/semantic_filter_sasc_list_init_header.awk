BEGIN {
    has_entry = 0
    has_load = 0
    has_self_store = 0
    has_add4 = 0
    has_zero_next = 0
    has_tail_store = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^LIST_INITHEADER:/) has_entry = 1
    if (l ~ /MOVEA\.L .*A0/ || l ~ /MOVE\.L .*A[0-6]/) has_load = 1
    if (l ~ /MOVE\.L A[0-6],\(A[0-6]\)/ || l ~ /MOVE\.L D0,\(A[0-6]\)/) has_self_store = 1
    if (l ~ /ADDQ\.L #\$?4,\(A[0-6]\)/ || l ~ /LEA \$?4\(A[0-6]\),(A[0-6]|D0)/) has_add4 = 1
    if (l ~ /CLR\.L (4|\$4)\(A[0-6]\)/ || l ~ /MOVE\.L #\$?0,(4|\$4)\(A[0-6]\)/) has_zero_next = 1
    if (l ~ /MOVE\.L A[0-6],(8|\$8)\(A[0-6]\)/ || l ~ /MOVE\.L D0,(8|\$8)\(A[0-6]\)/) has_tail_store = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_SELF_STORE=" has_self_store
    print "HAS_ADD4=" has_add4
    print "HAS_ZERO_NEXT=" has_zero_next
    print "HAS_TAIL_STORE=" has_tail_store
    print "HAS_RTS=" has_return
}
