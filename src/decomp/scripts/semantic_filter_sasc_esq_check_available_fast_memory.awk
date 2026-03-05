BEGIN {
    has_entry = 0
    has_availmem_call = 0
    has_threshold = 0
    has_flag_set = 0
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
    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /_LVOAVAILMEM/ || l ~ /AVAILMEM/) has_availmem_call = 1
    if (l ~ /600000/ || l ~ /\$927C0/) has_threshold = 1
    if (l ~ /HAS_REQUESTED_FAST_MEMORY/) has_flag_set = 1
    if (l ~ /^RTS$/ || l ~ /^MOVE\.L D0,D0$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_AVAILMEM_CALL=" has_availmem_call
    print "HAS_THRESHOLD=" has_threshold
    print "HAS_FLAG_SET=" has_flag_set
    print "HAS_RETURN=" has_return
}
