BEGIN {
    has_entry = 0
    has_strlen = 0
    has_text_length = 0
    has_width_delta = 0
    has_align_branch = 0
    has_div = 0
    has_alloc = 0
    has_space_pad = 0
    has_append = 0
    has_free = 0
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

    if (l ~ /^TST\.B \(A0\)\+/ || l ~ /^SUBA\.L A3,A0$/ || l ~ /^TST\.B \$0\(A5,D6\.L\)$/) has_strlen = 1
    if (l ~ /LVOTEXTLENGTH/ || l ~ /TEXTLENGTH/) has_text_length = 1
    if (l ~ /MOVE\.L #624,D1/ || l ~ /SUB\.L D0,D1/) has_width_delta = 1
    if (l ~ /CMP\.B D0,D7/ || l ~ /#\$18/ || l ~ /#\$1A/) has_align_branch = 1
    if (l ~ /MATH_DIVS32/ || l ~ /GROUP_AG_JMPTBL_MATH_DIVS32/ || l ~ /_DIVS32/) has_div = 1
    if (l ~ /MEMORY_ALLOCATEMEMORY/ || l ~ /MEMORY_ALLOCAT/) has_alloc = 1
    if (l ~ /MOVE\.B #\$20,\(A0\)\+/ || l ~ /MOVE\.B #\$20,\(A[0-7]\)\+/ || l ~ /MOVE\.B #\$20,\$0\(A3,D1\.L\)/) has_space_pad = 1
    if (l ~ /STRING_APPENDATNULL/ || l ~ /APPENDATNULL/ || l ~ /APPENDATN/) has_append = 1
    if (l ~ /MEMORY_DEALLOCATEMEMORY/ || l ~ /MEMORY_DEALLOCAT/) has_free = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STRLEN=" has_strlen
    print "HAS_TEXT_LENGTH=" has_text_length
    print "HAS_WIDTH_DELTA=" has_width_delta
    print "HAS_ALIGN_BRANCH=" has_align_branch
    print "HAS_DIV=" has_div
    print "HAS_ALLOC=" has_alloc
    print "HAS_SPACE_PAD=" has_space_pad
    print "HAS_APPEND=" has_append
    print "HAS_FREE=" has_free
}
