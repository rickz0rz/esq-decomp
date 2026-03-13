BEGIN {
    has_entry = 0
    has_finalize = 0
    has_current = 0
    has_target = 0
    has_compare = 0
    has_booleanize = 0
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
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/) has_current = 1
    if (l ~ /DISPTEXT_TARGETLINEINDEX/) has_target = 1
    if (l ~ /CMP\.[WL] D1,D0/ || l ~ /CMP\.[WL] D0,D1/ || l ~ /CMP\.L D1,D0/ || l ~ /CMP\.L D6,D7/ || l ~ /CMP\.L D7,D6/) has_compare = 1
    if (l ~ /SEQ D[0-7]/ || l ~ /NEG\.B D[0-7]/ || l ~ /EXT\.L D[0-7]/ ||
        l ~ /MOVEQ(\.L)? #\$?FF,D0/ || l ~ /MOVEQ(\.L)? #-1,D0/) has_booleanize = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FINALIZE=" has_finalize
    print "HAS_CURRENT=" has_current
    print "HAS_TARGET=" has_target
    print "HAS_COMPARE=" has_compare
    print "HAS_BOOLEANIZE=" has_booleanize
    print "HAS_RETURN=" has_return
}
