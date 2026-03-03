BEGIN {
    has_entry = 0
    has_loop_cmp = 0
    has_dealloc_call = 0
    has_clear_slot = 0
    has_inc = 0
    has_restore_d7 = 0
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

    if (uline ~ /^ESQFUNC_FREELINETEXTBUFFERS:/) has_entry = 1
    if (uline ~ /^CMP\.W D0,D7$/) has_loop_cmp = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc_call = 1
    if (uline ~ /^CLR\.L \(A0\)$/) has_clear_slot = 1
    if (uline ~ /^ADDQ\.W #1,D7$/) has_inc = 1
    if (uline ~ /^MOVE\.L \(A7\)\+,D7$/) has_restore_d7 = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_CLEAR_SLOT=" has_clear_slot
    print "HAS_INC=" has_inc
    print "HAS_RESTORE_D7=" has_restore_d7
    print "HAS_RTS=" has_rts
}
