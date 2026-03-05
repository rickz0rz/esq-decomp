BEGIN {
    has_entry = 0
    has_active_ref = 0
    has_restore_20 = 0
    has_restore_24 = 0
    has_restore_28 = 0
    has_slot_base = 0
    has_slot_clear_countdown = 0
    has_slot_clear_trigger = 0
    has_queue_ref = 0
    has_queue_loop_99 = 0
    has_queue_clear = 0
    has_return = 0
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

    if (u ~ /^GCOMMAND_RESETHIGHLIGHTMESSAGES:/) has_entry = 1
    if (index(u, "GCOMMAND_ACTIVEHIGHLIGHTMSGPTR") > 0 || index(u, "GCOMMAND_ACTIVEHIGHLIGHTMSGPT") > 0) has_active_ref = 1
    if ((index(u, "GCOMMAND_ACTIVEMSGSAVEDFIELD20") > 0 || index(u, "GCOMMAND_ACTIVEMSGSAVEDFIELD2") > 0) && u ~ /^MOVE\.L /) has_restore_20 = 1
    if ((index(u, "GCOMMAND_ACTIVEMSGSAVEDFIELD24") > 0 || index(u, "GCOMMAND_ACTIVEMSGSAVEDFIELD2") > 0) && u ~ /^MOVE\.L /) has_restore_24 = 1
    if ((index(u, "GCOMMAND_ACTIVEMSGSAVEDFIELD28") > 0 || index(u, "GCOMMAND_ACTIVEMSGSAVEDFIELD2") > 0) && u ~ /^MOVE\.L /) has_restore_28 = 1
    if (index(u, "GCOMMAND_HIGHLIGHTMESSAGESLOTTABLE") > 0 || index(u, "GCOMMAND_HIGHLIGHTMESSAGESLO") > 0) has_slot_base = 1
    if (u ~ /^CLR\.W 52\(A[0-7]\)$/ || u ~ /^CLR\.W \$34\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],\$34\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.W \(A[0-7]\)$/) has_slot_clear_countdown = 1
    if (u ~ /^CLR\.B 54\(A[0-7]\)$/ || u ~ /^CLR\.B \$36\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\$36\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.B \(A[0-7]\)$/) has_slot_clear_trigger = 1
    if (index(u, "ESQPARS2_BANNERQUEUEBUFFER") > 0) has_queue_ref = 1
    if (u ~ /^MOVEQ(\.L)? #98,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$62,D[0-7]$/ || u ~ /^DBF D[0-7],/) has_queue_loop_99 = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^CLR\.B \(A[0-7]\)\+$/ || u ~ /^MOVE\.B #\$0,\(A[0-7]\)\+$/ || u ~ /^CLR\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/) has_queue_clear = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ACTIVE_REF=" has_active_ref
    print "HAS_RESTORE_20=" has_restore_20
    print "HAS_RESTORE_24=" has_restore_24
    print "HAS_RESTORE_28=" has_restore_28
    print "HAS_SLOT_BASE=" has_slot_base
    print "HAS_SLOT_CLEAR_COUNTDOWN=" has_slot_clear_countdown
    print "HAS_SLOT_CLEAR_TRIGGER=" has_slot_clear_trigger
    print "HAS_QUEUE_REF=" has_queue_ref
    print "HAS_QUEUE_LOOP_99=" has_queue_loop_99
    print "HAS_QUEUE_CLEAR=" has_queue_clear
    print "HAS_RETURN=" has_return
}
