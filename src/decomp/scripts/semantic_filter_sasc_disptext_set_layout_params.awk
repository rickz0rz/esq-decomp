BEGIN {
    has_entry = 0
    has_reset = 0
    has_width_check = 0
    has_width_store = 0
    has_lines_check = 0
    has_lines_store = 0
    has_commit = 0
    has_compare_width = 0
    has_compare_lines = 0
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
    if (l ~ /RESETTEXTBUFFERANDLINETABLES/ || l ~ /RESETTEXTBUFFERANDLINETA/) has_reset = 1
    if (l ~ /CMPI\.L #\$?270,D7/ || l ~ /CMP\.L #\$?270,D[0-7]/ || l ~ /BMI\./) has_width_check = 1
    if (l ~ /DISPTEXT_LINEWIDTHPX/) has_width_store = 1
    if (l ~ /CMP\.L .*D6/ || l ~ /MOVEQ(\.L)? #\$?14,D0/ || l ~ /BLE\./) has_lines_check = 1
    if (l ~ /DISPTEXT_TARGETLINEINDEX/) has_lines_store = 1
    if (l ~ /COMMITCURRENTLINEPENANDADVANCE/ || l ~ /COMMITCURRENTLINEPENANDA/) has_commit = 1
    if (l ~ /DISPTEXT_LINEWIDTHPX/ && l ~ /CMP\.L/) has_compare_width = 1
    if (l ~ /DISPTEXT_TARGETLINEINDEX/ && l ~ /CMP\.L/) has_compare_lines = 1
    if (l ~ /MOVEQ(\.L)? #\$?1,D0/) has_true_one = 1
    if (l ~ /MOVEQ(\.L)? #\$?0,D0/) has_false_zero = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RESET=" has_reset
    print "HAS_WIDTH_CHECK=" has_width_check
    print "HAS_WIDTH_STORE=" has_width_store
    print "HAS_LINES_CHECK=" has_lines_check
    print "HAS_LINES_STORE=" has_lines_store
    print "HAS_COMMIT=" has_commit
    print "HAS_COMPARE_WIDTH=" has_compare_width
    print "HAS_COMPARE_LINES=" has_compare_lines
    print "HAS_TRUE_ONE=" has_true_one
    print "HAS_FALSE_ZERO=" has_false_zero
    print "HAS_RETURN=" has_return
}
