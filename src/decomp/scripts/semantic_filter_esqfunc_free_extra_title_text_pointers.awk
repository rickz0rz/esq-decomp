BEGIN {
    has_entry = 0
    has_link = 0
    has_movem_save = 0
    has_entry_loop = 0
    has_slot_loop = 0
    has_replace = 0
    has_clear_slot = 0
    has_mark_first = 0
    has_movem_restore = 0
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

    if (uline ~ /^ESQFUNC_FREEEXTRATITLETEXTPOINTERS:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-20$/) has_link = 1
    if (uline ~ /^MOVEM\.L D4-D7,-\(A7\)$/) has_movem_save = 1
    if (uline ~ /^\.ENTRY_LOOP:/) has_entry_loop = 1
    if (uline ~ /^\.SLOT_LOOP:/) has_slot_loop = 1
    if (uline ~ /ESQPARS_REPLACEOWNEDSTRING/) has_replace = 1
    if (uline ~ /^CLR\.L 56\(A0,D0\.L\)$/) has_clear_slot = 1
    if (uline ~ /^MOVEQ #1,D6$/) has_mark_first = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D4-D7$/) has_movem_restore = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_MOVEM_SAVE=" has_movem_save
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_SLOT_LOOP=" has_slot_loop
    print "HAS_REPLACE=" has_replace
    print "HAS_CLEAR_SLOT=" has_clear_slot
    print "HAS_MARK_FIRST=" has_mark_first
    print "HAS_MOVEM_RESTORE=" has_movem_restore
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
