BEGIN {
    has_save = 0
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
    has_restore = 0
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

    if (u ~ /^MOVEM\.L D0-D3\/A0-A6,-\(A7\)$/) has_save = 1
    if (u ~ /VPOSR/) has_vposr = 1
    if (u ~ /COP1LCH/) has_cop1lch = 1
    if (u ~ /ESQPARS2_ACTIVECOPPERLISTSELECTFLAG/) has_active_flag = 1
    if (u ~ /ESQPARS2_COPPERPROGRAMPENDINGFLAG/) has_pending_flag = 1
    if (u ~ /ESQSHARED4_PROGRAMDISPLAYWINDOWANDCOPPER/) has_program_call = 1
    if (u ~ /SCRIPT_UPDATEBANNERCHARTRANSITION/) has_script_call = 1
    if (u ~ /SCRIPT_BANNERTRANSITIONACTIVE/) has_transition_flag = 1
    if (u ~ /GCOMMAND_HIGHLIGHTHOLDOFFTICKCOUNT/) has_holdoff = 1
    if (u ~ /ESQPARS2_READMODEFLAGS/) has_read_mode = 1
    if (u ~ /GCOMMAND_TICKHIGHLIGHTSTATE/) has_tick_state_call = 1
    if (u ~ /ESQSHARED4_BLITBANNERROWSFORACTIVEFIELD/) has_blit_call = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D0-D3\/A0-A6$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SAVE=" has_save
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
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
