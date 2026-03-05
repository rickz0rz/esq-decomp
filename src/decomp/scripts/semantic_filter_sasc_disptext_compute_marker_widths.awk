BEGIN {
    has_entry = 0
    has_set_markers = 0
    has_test_prefix1 = 0
    has_test_prefix2 = 0
    has_textlength = 0
    has_sum = 0
    has_store_width = 0
    has_return = 0
    tstb_count = 0
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

    if (l ~ /SETSELECTIONMARKERS/ || l ~ /SETSELECTIONMARKE/ || l ~ /GROUP_AI_JMPTBL_NEWGRID_SETSELEC/) has_set_markers = 1
    if (l ~ /^TST\.B /) tstb_count++
    if (l ~ /LVOTEXTLENGTH/) has_textlength = 1
    if (l ~ /ADD\.L D4,D0/ || l ~ /ADD\.L D[0-7],D[0-7]/) has_sum = 1
    if (l ~ /DISPTEXT_CONTROLMARKERWIDTHPX/) has_store_width = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    if (tstb_count >= 1) has_test_prefix1 = 1
    if (tstb_count >= 2) has_test_prefix2 = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_SET_MARKERS=" has_set_markers
    print "HAS_TEST_PREFIX1=" has_test_prefix1
    print "HAS_TEST_PREFIX2=" has_test_prefix2
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_SUM=" has_sum
    print "HAS_STORE_WIDTH=" has_store_width
    print "HAS_RETURN=" has_return
}
