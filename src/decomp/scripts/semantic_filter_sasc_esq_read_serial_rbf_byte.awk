BEGIN {
    has_entry = 0
    has_tail_load = 0
    has_ring_wrap = 0
    has_fill_threshold = 0
    has_flag_cmp = 0
    has_flag_clear = 0
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

    if (l ~ /GLOBAL_WORD_T_VALUE/) has_tail_load = 1
    if (l ~ /#\$?FA00/ || l ~ /#64000/ || l ~ /#-1536/) has_ring_wrap = 1
    if (l ~ /#\$?BB80/ || l ~ /#48000/ || l ~ /#-17537/) has_fill_threshold = 1
    if (l ~ /#\$?102/ || l ~ /#258/ || l ~ /ESQPARS2_READMODEFLAGS/) has_flag_cmp = 1
    if (l ~ /CLR\.W ESQPARS2_READMODEFLAGS/ || l ~ /MOVE\.W #\$?0,ESQPARS2_READMODEFLAGS/) has_flag_clear = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TAIL_LOAD=" has_tail_load
    print "HAS_RING_WRAP_CONST=" has_ring_wrap
    print "HAS_FILL_THRESHOLD_CONST=" has_fill_threshold
    print "HAS_FLAG_CMP=" has_flag_cmp
    print "HAS_FLAG_CLEAR=" has_flag_clear
    print "HAS_RETURN=" has_return
}
