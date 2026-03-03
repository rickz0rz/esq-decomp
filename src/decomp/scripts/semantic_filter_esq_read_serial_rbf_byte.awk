BEGIN {
    has_tail_load = 0
    has_ring_wrap = 0
    has_fill_add = 0
    has_flag_cmp = 0
    has_flag_clear = 0
    has_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /GLOBAL_WORD_T_VALUE/) has_tail_load = 1
    if (uline ~ /#\$?FA00/ || uline ~ /#64000/ || uline ~ /#-1536/) has_ring_wrap = 1
    if (uline ~ /#\$?BB80/ || uline ~ /#48000/ || uline ~ /#-17537/) has_fill_add = 1
    if (uline ~ /#\$?102/ || uline ~ /#258/ || uline ~ /ESQPARS2_READMODEFLAGS/) has_flag_cmp = 1
    if ((uline ~ /CLR\.W ESQPARS2_READMODEFLAGS/) || (uline ~ /MOVE\.W #0,ESQPARS2_READMODEFLAGS/)) has_flag_clear = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_TAIL_LOAD=" has_tail_load
    print "HAS_RING_WRAP_CONST=" has_ring_wrap
    print "HAS_FILL_THRESHOLD_CONST=" has_fill_add
    print "HAS_FLAG_CMP=" has_flag_cmp
    print "HAS_FLAG_CLEAR=" has_flag_clear
    print "HAS_RTS=" has_rts
}
