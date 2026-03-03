BEGIN {
    has_entry = 0
    has_free_list = 0
    has_alloc_node = 0
    has_set_type8 = 0
    has_set_type9 = 0
    has_head_set = 0
    has_populate = 0
    has_head_clear = 0
    has_restore = 0
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

    if (uline ~ /^ESQFUNC_REBUILDPWBRUSHLISTFROMTAGTABLE:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FREEBRUSHLIST/) has_free_list = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_ALLOCBRUSHNODE/) has_alloc_node = 1
    if (uline ~ /^MOVE\.B #\$8,190\(A0\)$/) has_set_type8 = 1
    if (uline ~ /^MOVE\.B #\$9,190\(A0\)$/) has_set_type9 = 1
    if (uline ~ /^MOVE\.L -4\(A5\),ESQFUNC_PWBRUSHDESCRIPTORHEAD$/) has_head_set = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_POPULATEBRUSHLIST/) has_populate = 1
    if (uline ~ /^CLR\.L ESQFUNC_PWBRUSHDESCRIPTORHEAD$/) has_head_clear = 1
    if (uline ~ /^MOVE\.L -12\(A5\),D7$/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FREE_LIST=" has_free_list
    print "HAS_ALLOC_NODE=" has_alloc_node
    print "HAS_SET_TYPE8=" has_set_type8
    print "HAS_SET_TYPE9=" has_set_type9
    print "HAS_HEAD_SET=" has_head_set
    print "HAS_POPULATE=" has_populate
    print "HAS_HEAD_CLEAR=" has_head_clear
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
