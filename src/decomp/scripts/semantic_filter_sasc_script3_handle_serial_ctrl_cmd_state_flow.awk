BEGIN {
    has_entry = 0
    has_return = 0

    has_refresh_neg1 = 0
    has_refresh_zero = 0
    has_display_busy_return = 0
    has_pending_refresh_gate = 0
    has_pending_refresh_call = 0
    has_ui_busy_return = 0
    has_ctrlh_return = 0
    has_refresh_reset = 0

    has_state_dispatch = 0
    has_idle_switch = 0
    has_state1_collect = 0
    has_state2_checksum = 0
    has_state3_clear = 0
    has_invalid_reset = 0

    has_start_packet = 0
    has_select_code_gate_return = 0
    has_select_mode_dispatch = 0
    has_normal_dispatch = 0
    has_deferred_countdown_gate = 0
    has_deferred_minus_one_branch = 0
    has_defer_counter = 0
    has_checksum_mismatch = 0
    has_reset_parser = 0
    has_length_guard = 0
    has_length_error = 0
    has_runtime_reset = 0
    has_selection_reset = 0

    status_refresh_calls = 0
    handle_brush_calls = 0
    tick_context_calls = 0
    apply_pending_calls = 0
    set_copper_calls = 0
    set_rast_calls = 0
    checksum_error_writes = 0
    status_pending_writes = 0
    state2_sets = 0
    state1_sets = 0
    cmd_count_writes = 0
    checksum_writes = 0
    buffer_writes = 0
    read_index_writes = 0
    length_cmp_seen = 0
    length_branch_seen = 0
    saw_parse_result_test = 0
    saw_select_gate_test = 0
    saw_reset_checksum = 0
    saw_reset_index = 0
    saw_reset_state = 0
    saw_clear_state = 0
    saw_move_zero_state = 0
    saw_deferred_countdown_ref = 0
    saw_deferred_minus_one = 0
    prev_n = ""
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

    if (u ~ /^SCRIPT_HANDLESERIALCTRLCMD:/ || u ~ /^SCRIPT_HANDLESERIALCTRLC[A-Z0-9_]*:/) has_entry = 1
    if (u == "RTS") has_return = 1

    if (u ~ /^MOVE\.[BWL] #\$FFFFFFFF,GLOBAL_REFRESHTICKCOUNTER/ || \
        u ~ /^MOVE\.[BWL] #\$FFFFFFFF,_?GLOBAL_REFRESHTICKCOUNTER/ || \
        u ~ /^MOVE\.[BWL] #\(-1\),GLOBAL_REFRESHTICKCOUNTER/ || \
        u ~ /^MOVE\.[BWL] #\(-1\),_?GLOBAL_REFRESHTICKCOUNTER/) has_refresh_neg1 = 1
    if (u ~ /^CLR\.[BWL] GLOBAL_REFRESHTICKCOUNTER/ || \
        u ~ /^CLR\.[BWL] _?GLOBAL_REFRESHTICKCOUNTER/ || \
        u ~ /^MOVE\.[BWL] D[0-7],GLOBAL_REFRESHTICKCOUNTER/ || \
        u ~ /^MOVE\.[BWL] D[0-7],_?GLOBAL_REFRESHTICKCOUNTER/) has_refresh_zero = 1
    if (n ~ /ESQDISPDISPLAYACTIVEFLAG/ && (n ~ /CMPL1/ || u ~ /^CMP\.[BWL] .*ESQDISP_DISPLAYACTIVEFLAG/)) has_display_busy_return = 1
    if (n ~ /SCRIPTSTATUSMASKREFRESHPENDING/) has_pending_refresh_gate = 1
    if (n ~ /ESQDISPUPDATESTATUSMASKANDREFRESH/ || \
        n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRESH/ || \
        n ~ /ESQDISPUPDATESTATUSMASKANDREFRE/ || \
        n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRE/) status_refresh_calls++
    if (status_refresh_calls >= 1) has_pending_refresh_call = 1
    if (n ~ /GLOBALUIBUSYFLAG/ && (u ~ /^BNE\./ || u ~ /^BEQ\./ || u ~ /^TST\./ || u ~ /^MOVE\./)) has_ui_busy_return = 1
    if (n ~ /PARSEINICHECKCTRLHCHANGE/) has_state_dispatch = 1
    if (n ~ /PARSEINICHECKCTRLHCHANGE/) saw_parse_result_test = 1
    if (saw_parse_result_test && (u ~ /^TST\.[BWL] D[0-7]$/ || u ~ /^MOVE\.[BWL] D[0-7],D[0-7]$/)) has_ctrlh_return = 1
    if (has_ctrlh_return && u ~ /^BEQ\./) has_ctrlh_return = 1
    if (n ~ /GLOBALREFRESHTICKCOUNTER/ && (u ~ /^CLR\./ || u ~ /^MOVE\./)) has_refresh_reset = 1

    if (n ~ /SCRIPTCTRLSTATE/) has_state_dispatch = 1
    if (n ~ /SWITCHSCRIPTHANDLESERIALCTRLCMD/ || n ~ /CTRLCMDJMPTBL/) has_idle_switch = 1
    if (n ~ /SCRIPTCTRLCMDBUFFER/) buffer_writes++
    if (n ~ /SCRIPTCTRLCHECKSUM/) checksum_writes++
    if (n ~ /SCRIPTCTRLREADINDEX/) read_index_writes++
    if (n ~ /SCRIPTCTRLCMDCOUNT/) cmd_count_writes++
    if (n ~ /TEXTDISPDEFERREDACTIONCOUNTDOWN/ || n ~ /TEXTDISPDEFERREDACTIONCOUNTDOW/) saw_deferred_countdown_ref = 1
    if (saw_deferred_countdown_ref && (u ~ /^BEQ\./ || u ~ /^BNE\./)) has_deferred_countdown_gate = 1
    if (saw_deferred_countdown_ref && (u ~ /^SUBQ\.[BWL] #\$?1,D[0-7]$/ || u ~ /^SUBQ\.[BWL] #1,D[0-7]$/)) {
        saw_deferred_minus_one = 1
        saw_deferred_countdown_ref = 0
    }
    if (saw_deferred_minus_one && u ~ /^BNE\./) {
        has_deferred_minus_one_branch = 1
        saw_deferred_minus_one = 0
    }
    if (u ~ /^MOVE\.[BWL] #\$1,SCRIPT_CTRL_STATE/ || u ~ /^MOVE\.[BWL] #1,SCRIPT_CTRL_STATE/ || \
        u ~ /^MOVE\.[BWL] #\$1,_?SCRIPT_CTRL_STATE/ || u ~ /^MOVE\.[BWL] #1,_?SCRIPT_CTRL_STATE/) state1_sets++
    if ((u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_STATE(\(A4\))?$/ || \
         u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_STATE(\(A4\))?$/) && \
        (prev_n ~ /MOVEQ1D[0-7]/ || prev_n ~ /MOVEQL1D[0-7]/ || prev_n ~ /MOVEQ01D[0-7]/ || prev_n ~ /MOVEQL01D[0-7]/)) state1_sets++
    if (u ~ /^MOVE\.[BWL] #\$2,SCRIPT_CTRL_STATE/ || u ~ /^MOVE\.[BWL] #2,SCRIPT_CTRL_STATE/ || \
        u ~ /^MOVE\.[BWL] #\$2,_?SCRIPT_CTRL_STATE/ || u ~ /^MOVE\.[BWL] #2,_?SCRIPT_CTRL_STATE/) state2_sets++
    if ((u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_STATE(\(A4\))?$/ || \
         u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_STATE(\(A4\))?$/) && \
        (prev_n ~ /MOVEQ2D[0-7]/ || prev_n ~ /MOVEQL2D[0-7]/ || prev_n ~ /MOVEQ02D[0-7]/ || prev_n ~ /MOVEQL02D[0-7]/)) state2_sets++
    if (buffer_writes >= 2 && checksum_writes >= 2 && cmd_count_writes >= 1) has_start_packet = 1
    if (read_index_writes >= 2 && buffer_writes >= 3 && checksum_writes >= 3) has_state1_collect = 1
    if (n ~ /SCRIPTHANDLEBRUSHCOMMAND/ || n ~ /SCRIPTHANDLEBRUSHCOMMAN/) handle_brush_calls++
    if (handle_brush_calls >= 1 && checksum_writes >= 4) has_state2_checksum = 1
    if (u ~ /^MOVE\.[BWL] #\$3,SCRIPT_CTRL_STATE/ || u ~ /^MOVE\.[BWL] #3,SCRIPT_CTRL_STATE/ || \
        u ~ /^MOVE\.[BWL] #\$3,_?SCRIPT_CTRL_STATE/ || u ~ /^MOVE\.[BWL] #3,_?SCRIPT_CTRL_STATE/) has_state3_clear = 1
    if (u ~ /^CLR\.[BWL] SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^CLR\.[BWL] _?SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_STATE(\(A4\))?$/) {
        saw_clear_state = 1
        has_state3_clear = 1
    }
    if (u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_STATE(\(A4\))?$/) saw_move_zero_state = 1

    if (n ~ /GLOBALWORDSELECTCODEISRAVES/) saw_select_gate_test = 1
    if (saw_select_gate_test && u ~ /^BNE\./) has_select_code_gate_return = 1
    if (n ~ /SCRIPTAPPLYPENDINGBANNERTARGET/ || n ~ /SCRIPTAPPLYPENDINGBANNERTAR/) apply_pending_calls++
    if (n ~ /ESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHL/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGH/) set_copper_calls++
    if (n ~ /TEXTDISPSETRASTFORMODE/ || n ~ /TEXTDISPSETRASTFORMOD/) set_rast_calls++
    if (n ~ /SCRIPTPROCESSCTRLCONTEXTPLAYBACKTICK/ || n ~ /SCRIPTPROCESSCTRLCONTEXTPLAYBAC/) tick_context_calls++
    if (handle_brush_calls >= 1 && apply_pending_calls >= 1 && set_copper_calls >= 1 && set_rast_calls >= 1) has_select_mode_dispatch = 1
    if (handle_brush_calls >= 1 && tick_context_calls >= 1 && has_deferred_countdown_gate && has_deferred_minus_one_branch) has_normal_dispatch = 1
    if (n ~ /SCRIPTCTRLCMDDEFERCOUNTER/) has_defer_counter = 1
    if (n ~ /SCRIPTCTRLCMDCHECKSUMERRORCOUNT/ || n ~ /SCRIPTCTRLCMDCHECKSUMERRORCOUN/) checksum_error_writes++
    if (n ~ /SCRIPTSTATUSMASKREFRESHPENDING/) status_pending_writes++
    if (status_refresh_calls >= 2 && checksum_error_writes >= 1 && status_pending_writes >= 2) has_checksum_mismatch = 1

    if (u ~ /^CLR\.[BWL] SCRIPT_CTRL_CHECKSUM(\(A4\))?$/ || \
        u ~ /^CLR\.[BWL] _?SCRIPT_CTRL_CHECKSUM(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_CHECKSUM(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_CHECKSUM(\(A4\))?$/) saw_reset_checksum = 1
    if (u ~ /^CLR\.[BWL] SCRIPT_CTRL_READ_INDEX(\(A4\))?$/ || \
        u ~ /^CLR\.[BWL] _?SCRIPT_CTRL_READ_INDEX(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_READ_INDEX(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_READ_INDEX(\(A4\))?$/) saw_reset_index = 1
    if (u ~ /^CLR\.[BWL] SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^CLR\.[BWL] _?SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],SCRIPT_CTRL_STATE(\(A4\))?$/ || \
        u ~ /^MOVE\.[BWL] D[0-7],_?SCRIPT_CTRL_STATE(\(A4\))?$/) saw_reset_state = 1

    if (u ~ /^CMPI\.[BWL] #\$?C6,D[0-7]$/ || u ~ /^CMPI\.[BWL] #198,D[0-7]$/) length_cmp_seen = 1
    if (length_cmp_seen && (u ~ /^BLE\./ || u ~ /^BGE\./ || u ~ /^BLT\./ || u ~ /^BCC\./)) length_branch_seen = 1
    if (length_cmp_seen && length_branch_seen) has_length_guard = 1
    if (n ~ /SCRIPTCTRLCMDLENGTHERRORCOUNT/) has_length_error = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_reset = 1
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFRES/) has_selection_reset = 1

    if (saw_reset_checksum && saw_reset_index && saw_reset_state) has_reset_parser = 1
    if (saw_clear_state && saw_move_zero_state) has_invalid_reset = 1

    prev_n = n
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN=" has_return
    print "HAS_REFRESH_NEG1=" has_refresh_neg1
    print "HAS_REFRESH_ZERO=" has_refresh_zero
    print "HAS_DISPLAY_BUSY_RETURN=" has_display_busy_return
    print "HAS_PENDING_REFRESH_GATE=" has_pending_refresh_gate
    print "HAS_PENDING_REFRESH_CALL=" has_pending_refresh_call
    print "HAS_UI_BUSY_RETURN=" has_ui_busy_return
    print "HAS_CTRLH_RETURN=" has_ctrlh_return
    print "HAS_REFRESH_RESET=" has_refresh_reset
    print "HAS_STATE_DISPATCH=" has_state_dispatch
    print "HAS_IDLE_SWITCH=" has_idle_switch
    print "HAS_START_PACKET=" has_start_packet
    print "HAS_STATE1_COLLECT=" has_state1_collect
    print "HAS_STATE2_CHECKSUM=" has_state2_checksum
    print "HAS_STATE3_CLEAR=" has_state3_clear
    print "HAS_INVALID_RESET=" has_invalid_reset
    print "HAS_SELECT_CODE_GATE_RETURN=" has_select_code_gate_return
    print "HAS_SELECT_MODE_DISPATCH=" has_select_mode_dispatch
    print "HAS_NORMAL_DISPATCH=" has_normal_dispatch
    print "HAS_DEFERRED_COUNTDOWN_GATE=" has_deferred_countdown_gate
    print "HAS_DEFERRED_MINUS_ONE_BRANCH=" has_deferred_minus_one_branch
    print "HAS_DEFER_COUNTER=" has_defer_counter
    print "HAS_CHECKSUM_MISMATCH=" has_checksum_mismatch
    print "HAS_RESET_PARSER=" has_reset_parser
    print "HAS_LENGTH_GUARD=" has_length_guard
    print "HAS_LENGTH_ERROR=" has_length_error
    print "HAS_RUNTIME_RESET=" has_runtime_reset
    print "HAS_SELECTION_RESET=" has_selection_reset
    print "STATUS_REFRESH_CALLS=" status_refresh_calls
    print "HAS_PARSER_RESET_WRITES=" (saw_reset_checksum && saw_reset_index && saw_reset_state)
    print "HAS_STATE_CLEAR_WRITES=" (saw_clear_state && saw_move_zero_state)
}
