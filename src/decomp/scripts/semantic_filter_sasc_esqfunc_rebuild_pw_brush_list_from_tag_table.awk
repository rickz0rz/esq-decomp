BEGIN {
    has_entry = 0
    has_free_list = 0
    has_alloc = 0
    has_type8 = 0
    has_type9 = 0
    has_store_head = 0
    has_populate = 0
    has_clear_head = 0
    has_unlk = 0
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

    if (uline ~ /^ESQFUNC_REBUILDPWBRUSHLISTFROMTA[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /BRUSH_FREEBRUSHLIST/) has_free_list = 1
    if (uline ~ /BRUSH_ALLOCBRUSHNODE/ || uline ~ /ESQFUNC_BRUSHDESCRIPTORTAGSTRING/) has_alloc = 1
    if (uline ~ /^MOVE\.B/ && (uline ~ /#\$8/ || uline ~ /#8/) && (uline ~ /190\(A0\)/ || uline ~ /\$BE\(A5\)/ || uline ~ /TYPE190/)) has_type8 = 1
    if (uline ~ /^MOVE\.B/ && (uline ~ /#\$9/ || uline ~ /#9/) && (uline ~ /190\(A0\)/ || uline ~ /\$BE\(A5\)/ || uline ~ /TYPE190/)) has_type9 = 1
    if (uline ~ /ESQFUNC_PWBRUSHDESCRIPTORHEAD/) has_store_head = 1
    if (uline ~ /BRUSH_POPULATEBRUSHLIST/) has_populate = 1
    if (uline ~ /^CLR\.L ESQFUNC_PWBRUSHDESCRIPTORHEAD$/ || uline ~ /^MOVE\.L D0,ESQFUNC_PWBRUSHDESCRIPTORHEAD$/ || uline ~ /^MOVE\.L #0,ESQFUNC_PWBRUSHDESCRIPTORHEAD$/ || uline ~ /^CLR\.L ESQFUNC_PWBRUSHDESCRIPTORHEAD\(A4\)$/) has_clear_head = 1
    if (uline ~ /^UNLK A5$/ || uline ~ /^MOVE\.L \(A7\)\+,D7$/ || uline ~ /^MOVEM\.L \(A7\)\+,D7\/A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FREE_LIST=" has_free_list
    print "HAS_ALLOC=" has_alloc
    print "HAS_TYPE8=" has_type8
    print "HAS_TYPE9=" has_type9
    print "HAS_STORE_HEAD=" has_store_head
    print "HAS_POPULATE=" has_populate
    print "HAS_CLEAR_HEAD=" has_clear_head
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
