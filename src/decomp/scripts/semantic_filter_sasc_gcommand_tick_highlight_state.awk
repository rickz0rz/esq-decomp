BEGIN {
    has_entry = 0
    has_rebuild_test = 0
    has_rebuild_call = 0
    has_phase_inc = 0
    has_phase_wrap_98 = 0
    has_row_offset_update = 0
    has_tail_offset_update = 0
    has_queue_slot_update = 0
    has_queue_wrap_61 = 0
    has_row_index_update = 0
    has_service_call = 0
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

    if (u ~ /^GCOMMAND_TICKHIGHLIGHTSTATE[A-Z0-9_]*:/) has_entry = 1

    if ((index(u, "GCOMMAND_BANNERREBUILDPENDINGFLAG") > 0 || index(u, "GCOMMAND_BANNERREBUILDPENDINGFLA") > 0) && (u ~ /^TST\.W / || u ~ /^MOVE\.W /)) has_rebuild_test = 1
    if (index(u, "GCOMMAND_REBUILDBANNERTABLESFROMBOUNDS") > 0 || index(u, "GCOMMAND_REBUILDBANNERTABLESFROM") > 0) has_rebuild_call = 1

    if (index(u, "GCOMMAND_BANNERPHASEINDEXCURRENT") > 0 && (u ~ /^ADDQ\.L #\$1,/ || u ~ /^ADDQ\.L #1,/ || u ~ /^ADD\.L /)) has_phase_inc = 1
    if (u ~ /^MOVEQ(\.L)? #98,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$62,D[0-7]$/ || u ~ /^CMPI\.[LW] #98,D[0-7]$/ || u ~ /^CMPI\.[LW] #\$62,D[0-7]$/) has_phase_wrap_98 = 1

    if (index(u, "GCOMMAND_BANNERROWBYTEOFFSETCURRENT") > 0 || index(u, "GCOMMAND_BANNERROWBYTEOFFSETCURR") > 0) {
        if (u ~ /^ADD\.L / || u ~ /^MOVE\.L /) has_row_offset_update = 1
    }
    if ((index(u, "ESQSHARED4_INTERLEAVECOPYTAILOFFSETCURRENT") > 0 || index(u, "ESQSHARED4_INTERLEAVECOPYTAILOFF") > 0) && (u ~ /^ADD\.L / || u ~ /^MOVE\.L /)) has_tail_offset_update = 1
    if (u ~ /^MOVEQ(\.L)? #32,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/ || u ~ /^ADDI?\.[LW] #\$20,/) has_tail_offset_update = 1

    if ((index(u, "GCOMMAND_BANNERQUEUESLOTPREVIOUS") > 0 || index(u, "GCOMMAND_BANNERQUEUESLOTCURRENT") > 0) && (u ~ /^MOVE\.W / || u ~ /^SUBQ\.W /)) has_queue_slot_update = 1
    if (u ~ /^MOVE\.W #\$61,/ || u ~ /^MOVE\.W #97,/) has_queue_wrap_61 = 1

    if ((index(u, "GCOMMAND_BANNERROWINDEXPREVIOUS") > 0 || index(u, "GCOMMAND_BANNERROWINDEXCURRENT") > 0) && (u ~ /^MOVE\.L / || u ~ /^ADDQ\.L / || u ~ /^CLR\.L /)) has_row_index_update = 1

    if (index(u, "GCOMMAND_SERVICEHIGHLIGHTMESSAGES") > 0 || index(u, "GCOMMAND_SERVICEHIGHLIGHTMESSAGE") > 0) has_service_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REBUILD_TEST=" has_rebuild_test
    print "HAS_REBUILD_CALL=" has_rebuild_call
    print "HAS_PHASE_INC=" has_phase_inc
    print "HAS_PHASE_WRAP_98=" has_phase_wrap_98
    print "HAS_ROW_OFFSET_UPDATE=" has_row_offset_update
    print "HAS_TAIL_OFFSET_UPDATE=" has_tail_offset_update
    print "HAS_QUEUE_SLOT_UPDATE=" has_queue_slot_update
    print "HAS_QUEUE_WRAP_61=" has_queue_wrap_61
    print "HAS_ROW_INDEX_UPDATE=" has_row_index_update
    print "HAS_SERVICE_CALL=" has_service_call
    print "HAS_RETURN=" has_return
}
