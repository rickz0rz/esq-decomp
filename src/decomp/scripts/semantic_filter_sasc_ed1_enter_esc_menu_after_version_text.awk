BEGIN {
    has_push_filter_ptr = 0
    has_reset_call = 0
    has_return = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /^PEA LOCAVAIL_PRIMARYFILTERSTATE$/ || l ~ /^PEA LOCAVAIL_PRIMARYFILTERSTATE\(A4\)$/ || l ~ /^MOVE\.L #LOCAVAIL_PRIMARYFILTERSTATE,-\(A7\)$/) {
        has_push_filter_ptr = 1
    }

    if (l ~ /(JSR|BSR).*ED1_JMPTBL_LOCAVAIL_RESETFILTERC/) has_reset_call = 1

    if (l ~ /^UNLK A5$/ || l ~ /^RTS$/ || l ~ /^ADDQ\.W #\$?4,A7$/) has_return = 1
}

END {
    print "HAS_PUSH_FILTER_PTR=" has_push_filter_ptr
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_RETURN=" has_return
}
