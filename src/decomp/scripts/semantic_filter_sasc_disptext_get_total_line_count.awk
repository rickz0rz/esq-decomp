BEGIN {
    has_entry = 0
    has_finalize = 0
    has_load_count = 0
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
    if (l ~ /DISPTEXT_FINALIZELINETABLE/ || l ~ /DISPTEXT_FINALIZELINETAB/) has_finalize = 1
    if (l ~ /DISPTEXT_TARGETLINEINDEX/) has_load_count = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FINALIZE=" has_finalize
    print "HAS_LOAD_COUNT=" has_load_count
    print "HAS_RETURN=" has_return
}
