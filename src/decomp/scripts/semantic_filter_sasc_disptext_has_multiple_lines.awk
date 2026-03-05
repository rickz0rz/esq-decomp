BEGIN {
    has_entry = 0
    has_finalize = 0
    has_current_check = 0
    has_target_check = 0
    has_true_one = 0
    has_false_zero = 0
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
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/) has_current_check = 1
    if (l ~ /DISPTEXT_TARGETLINEINDEX/) has_target_check = 1
    if (l ~ /MOVEQ(\.L)? #\$?1,D0/) has_true_one = 1
    if (l ~ /MOVEQ(\.L)? #\$?0,D0/ || l ~ /CLR\.L D0/) has_false_zero = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FINALIZE=" has_finalize
    print "HAS_CURRENT_CHECK=" has_current_check
    print "HAS_TARGET_CHECK=" has_target_check
    print "HAS_TRUE_ONE=" has_true_one
    print "HAS_FALSE_ZERO=" has_false_zero
    print "HAS_RETURN=" has_return
}
