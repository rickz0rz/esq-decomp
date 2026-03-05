BEGIN {
    has_entry = 0
    has_save = 0
    has_buffer_test = 0
    has_availmem = 0
    has_allocate = 0
    has_append = 0
    has_replace = 0
    has_store = 0
    has_status = 0
    saw_sne = 0
    saw_neg = 0
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

    if (l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /DISPTEXT_TEXTBUFFERPTR/ && (l ~ /TST\./ || l ~ /CMP\./)) has_buffer_test = 1
    if (l ~ /LVOAVAILMEM/ || l ~ /LV0AVAILMEM/) has_availmem = 1
    if (l ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || l ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_allocate = 1
    if (l ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/ || l ~ /GROUP_AI_JMPTBL_STRING_APPENDATN/) has_append = 1
    if (l ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || l ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/) has_replace = 1
    if (l ~ /DISPTEXT_TEXTBUFFERPTR/ && l ~ /MOVE\./) has_store = 1
    if (l ~ /SNE D0/) saw_sne = 1
    if (l ~ /NEG\.B D0/) saw_neg = 1
    if (l ~ /MOVEQ(\.L)? #\-1,D0/ || l ~ /MOVEQ(\.L)? #\$?FFFFFFFF,D0/ || l ~ /MOVEQ(\.L)? #\$?FF,D0/) has_status = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    if (saw_sne && saw_neg) has_status = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_BUFFER_TEST=" has_buffer_test
    print "HAS_AVAILMEM=" has_availmem
    print "HAS_ALLOCATE=" has_allocate
    print "HAS_APPEND=" has_append
    print "HAS_REPLACE=" has_replace
    print "HAS_STORE=" has_store
    print "HAS_STATUS=" has_status
    print "HAS_RETURN=" has_return
}
