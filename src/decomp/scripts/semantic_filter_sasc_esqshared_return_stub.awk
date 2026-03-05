BEGIN {
    has_entry = 0
    has_unlk = 0
    has_rts = 0
    has_covf_guard = 0
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
    if (l ~ /^UNLK A5$/) has_unlk = 1
    if (l ~ /^CMP\.L __BASE\(A4\),A7$/ || l ~ /^BCS(\.[A-Z]+)? _XCOVF$/) has_covf_guard = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    if (!has_unlk && has_covf_guard && has_rts) has_unlk = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
