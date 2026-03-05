BEGIN {
    has_entry = 0
    has_vposr = 0
    has_cop1lch = 0
    has_active_flag = 0
    has_pending_flag = 0
    has_program_call = 0
    has_script_call = 0
    has_transition_flag = 0
    has_holdoff = 0
    has_read_mode = 0
    has_tick_state_call = 0
    has_blit_call = 0
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

    if (u ~ /^ESQSHARED4_TICKCOPPERANDBANNERTRANSITIONS:/ || u ~ /^ESQSHARED4_TICKCOPPERANDBANNERT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "VPOSR") > 0) has_vposr = 1
    if (index(u, "COP1LCH") > 0) has_cop1lch = 1
    if (index(u, "ESQPARS2_ACTIVECOPPERLISTSELECTFLAG") > 0 || index(u, "ACTIVECOPPERLISTSELECT") > 0) has_active_flag = 1
    if (index(u, "ESQPARS2_COPPERPROGRAMPENDINGFLAG") > 0 || index(u, "COPPERPROGRAMPENDING") > 0) has_pending_flag = 1
    if (index(u, "ESQSHARED4_PROGRAMDISPLAYWINDOWANDCOPPER") > 0 || index(u, "PROGRAMDISPLAYWINDOWANDCOPPER") > 0 || index(u, "ESQSHARED4_PROGRAMDISPLAYWINDOWA") > 0 || index(u, "PROGRAMDISPLAYWINDOWA") > 0) has_program_call = 1
    if (index(u, "SCRIPT_UPDATEBANNERCHARTRANSITION") > 0 || index(u, "UPDATEBANNERCHARTRANSITION") > 0 || index(u, "SCRIPT_UPDATEBANNERCHARTRANSITIO") > 0 || index(u, "UPDATEBANNERCHARTRANSITIO") > 0) has_script_call = 1
    if (index(u, "SCRIPT_BANNERTRANSITIONACTIVE") > 0 || index(u, "BANNERTRANSITIONACTIVE") > 0) has_transition_flag = 1
    if (index(u, "GCOMMAND_HIGHLIGHTHOLDOFFTICKCOUNT") > 0 || index(u, "HIGHLIGHTHOLDOFFTICKCOUNT") > 0 || index(u, "GCOMMAND_HIGHLIGHTHOLDOFFTICKCOU") > 0 || index(u, "HIGHLIGHTHOLDOFFTICKCOU") > 0) has_holdoff = 1
    if (index(u, "ESQPARS2_READMODEFLAGS") > 0 || index(u, "READMODEFLAGS") > 0) has_read_mode = 1
    if (index(u, "GCOMMAND_TICKHIGHLIGHTSTATE") > 0 || index(u, "TICKHIGHLIGHTSTATE") > 0) has_tick_state_call = 1
    if (index(u, "ESQSHARED4_BLITBANNERROWSFORACTIVEFIELD") > 0 || index(u, "BLITBANNERROWSFORACTI") > 0) has_blit_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_VPOSR=" has_vposr
    print "HAS_COP1LCH=" has_cop1lch
    print "HAS_ACTIVE_FLAG=" has_active_flag
    print "HAS_PENDING_FLAG=" has_pending_flag
    print "HAS_PROGRAM_CALL=" has_program_call
    print "HAS_SCRIPT_CALL=" has_script_call
    print "HAS_TRANSITION_FLAG=" has_transition_flag
    print "HAS_HOLDOFF=" has_holdoff
    print "HAS_READ_MODE=" has_read_mode
    print "HAS_TICK_STATE_CALL=" has_tick_state_call
    print "HAS_BLIT_CALL=" has_blit_call
    print "HAS_RTS=" has_rts
}
