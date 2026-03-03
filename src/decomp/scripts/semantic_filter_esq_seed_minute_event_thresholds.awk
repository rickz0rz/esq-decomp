BEGIN {
    has_const_60 = 0
    has_const_30 = 0
    has_sub = 0
    has_offset_add = 0
    has_store_60 = 0
    has_store_30 = 0
    has_store_base = 0
    has_store_base_plus_30 = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (u ~ /#60/) has_const_60 = 1
    if (u ~ /#30/) has_const_30 = 1
    if (u ~ /^SUB\.[BWL] / || u ~ /^SUBQ\.[BWL] /) has_sub = 1
    if (u ~ /^ADD\.[BWL] / || u ~ /^ADDQ\.[BWL] /) has_offset_add = 1

    if (u ~ /CLOCK_MINUTETRIGGER60MINUSBASE/) has_store_60 = 1
    if (u ~ /CLOCK_MINUTETRIGGER30MINUSBASE/) has_store_30 = 1
    if (u ~ /CLOCK_MINUTETRIGGERBASEOFFSET( |$)/) has_store_base = 1
    if (u ~ /CLOCK_MINUTETRIGGERBASEOFFSETPLUS30/) has_store_base_plus_30 = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_CONST_60=" has_const_60
    print "HAS_CONST_30=" has_const_30
    print "HAS_SUB=" has_sub
    print "HAS_OFFSET_ADD=" has_offset_add
    print "HAS_STORE_60=" has_store_60
    print "HAS_STORE_30=" has_store_30
    print "HAS_STORE_BASE=" has_store_base
    print "HAS_STORE_BASE_PLUS_30=" has_store_base_plus_30
    print "HAS_RTS=" has_rts
}
