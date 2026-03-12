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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQFUNC_FREELINETEXTBUFFERS:/ || u ~ /^ESQFUNC_FREELINETEXTBUFFER[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\\$14/ || n ~ /CMPWD0D7/) has_loop_cmp = 1
    if (n ~ /DEALLOCATEM/) has_dealloc_call = 1
    if (n ~ /CLRL0A0/ || u ~ /CLR\\.L \\(A0\\)/ || u ~ /MOVE\\.L #0,\\(A0\\)/ || u ~ /MOVEQ #0,D[0-7]/) has_clear_slot = 1
    if (n ~ /ADDQW1D7/) has_inc = 1
    if (n ~ /MOVELA7D7/ || n ~ /MOVEA7D7/) has_restore_d7 = 1
    if (u == "RTS") has_rts = 1
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
