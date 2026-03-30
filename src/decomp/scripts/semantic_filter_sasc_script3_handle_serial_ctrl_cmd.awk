BEGIN {
    has_entry = 0
    has_return = 0
    jmptbl_cases = 0

    has_select_code_gate = 0
    has_config_msn_gate = 0
    has_refresh_tick = 0
    has_status_hold = 0
    has_display_active = 0
    has_status_pending = 0
    has_clock_ref = 0
    has_clock_seconds = 0
    has_ui_busy = 0

    has_parse_change = 0
    has_capture_byte = 0
    has_handle_brush = 0
    has_apply_pending = 0
    has_tick_context = 0
    handle_brush_calls = 0
    tick_context_calls = 0
    has_deferred_action_gate = 0
    has_deferred_minus_one_gate = 0
    saw_deferred_action_ref = 0
    status_refresh_calls = 0
    has_set_copper = 0
    has_set_rast = 0
    has_reset_selection = 0

    has_ctrl_state = 0
    has_ctrl_index = 0
    has_ctrl_checksum = 0
    has_ctrl_buffer = 0
    has_ctrl_cmd_count = 0
    has_deferred_action = 0
    deferred_action_writes = 0
    has_defer_counter = 0
    has_checksum_error = 0
    has_length_error = 0
    has_runtime_mode = 0

    has_state_set_3 = 0
    has_state_set_2 = 0
    has_state_clear = 0
    has_refresh_call_32 = 0
    has_refresh_call_32_1 = 0
    has_body_cr_gate = 0
    has_checksum_xor = 0
    has_checksum_compare = 0
    has_length_limit_198 = 0
    reset_triads = 0
    prev_n = ""
    prev2_n = ""
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
    if (u ~ /^DC\.W /) jmptbl_cases++

    if (n ~ /GLOBALWORDSELECTCODEISRAVES/) has_select_code_gate = 1
    if (n ~ /CONFIGMSNFLAGCHAR/) has_config_msn_gate = 1
    if (n ~ /GLOBALREFRESHTICKCOUNTER/) has_refresh_tick = 1
    if (n ~ /SCRIPTSTATUSREFRESHHOLDFLAG/) has_status_hold = 1
    if (n ~ /ESQDISPDISPLAYACTIVEFLAG/) has_display_active = 1
    if (n ~ /SCRIPTSTATUSMASKREFRESHPENDING/) has_status_pending = 1
    if (n ~ /GLOBALREFCLOCKDATASTRUCT/) has_clock_ref = 1
    if (n ~ /GLOBALWORDCLOCKSECONDS/) has_clock_seconds = 1
    if (n ~ /GLOBALUIBUSYFLAG/) has_ui_busy = 1

    if (n ~ /PARSEINICHECKCTRLHCHANGE/) has_parse_change = 1
    if (n ~ /SCRIPTESQCAPTURECTRLBIT4STREAMBUFFERBYTE/ || n ~ /SCRIPTESQCAPTURECTRLBIT4STREAMBUFF/ || n ~ /SCRIPTESQCAPTURECTRLBIT4STREAM/ || n ~ /ESQCAPTURECTRLBIT4STREAMBUFFERBYTE/ || n ~ /ESQCAPTURECTRLBIT4STREAMBUFF/ || n ~ /ESQCAPTURECTRLBIT4STREAM/) has_capture_byte = 1
    if (n ~ /SCRIPTHANDLEBRUSHCOMMAND/ || n ~ /SCRIPTHANDLEBRUSHCOMMAN/) {
        handle_brush_calls++
        has_handle_brush = 1
    }
    if (n ~ /SCRIPTAPPLYPENDINGBANNERTARGET/ || n ~ /SCRIPTAPPLYPENDINGBANNERTAR/) has_apply_pending = 1
    if (n ~ /SCRIPTPROCESSCTRLCONTEXTPLAYBACKTICK/ || n ~ /SCRIPTPROCESSCTRLCONTEXTPLAYBAC/) {
        tick_context_calls++
        has_tick_context = 1
    }
    if (n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRESH/ || n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMAS/ || n ~ /SCRIPT3JMPTBLESQDISPUPDATESTA/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRESH/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFR/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRE/) status_refresh_calls++
    if (n ~ /WDISPJMPTBLESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /WDISPJMPTBLESQSETCOPPEREFF/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHL/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGH/) has_set_copper = 1
    if (n ~ /TEXTDISPSETRASTFORMODE/ || n ~ /TEXTDISPSETRASTFORMOD/) has_set_rast = 1
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFR/) has_reset_selection = 1

    if (n ~ /SCRIPTCTRLSTATE/) has_ctrl_state = 1
    if (n ~ /SCRIPTCTRLREADINDEX/ || n ~ /SCRIPTCTRLREADINDE/) has_ctrl_index = 1
    if (n ~ /SCRIPTCTRLCHECKSUM/ || n ~ /SCRIPTCTRLCHECKSU/) has_ctrl_checksum = 1
    if (n ~ /SCRIPTCTRLCMDBUFFER/ || n ~ /SCRIPTCTRLCMDBUFFE/) has_ctrl_buffer = 1
    if (n ~ /SCRIPTCTRLCMDCOUNT/) has_ctrl_cmd_count = 1
    if (n ~ /TEXTDISPDEFERREDACTIONCOUNTDOWN/ || n ~ /TEXTDISPDEFERREDACTIONCOUNTDOW/) {
        has_deferred_action = 1
        saw_deferred_action_ref = 1
    }
    if (u ~ /^MOVE\.[BWL][[:space:]]+D[0-7],[[:space:]]*TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^MOVE\.[BWL][[:space:]]+D[0-7],[[:space:]]*_?TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^MOVE\.[BWL][[:space:]]+[A-Z0-9_()$.-]+,[[:space:]]*TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^MOVE\.[BWL][[:space:]]+[A-Z0-9_()$.-]+,[[:space:]]*_?TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^ADDQ\.[BWL][[:space:]]+#-?[0-9]+,[[:space:]]*TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^ADDQ\.[BWL][[:space:]]+#-?[0-9]+,[[:space:]]*_?TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^SUBQ\.[BWL][[:space:]]+#-?[0-9]+,[[:space:]]*TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^SUBQ\.[BWL][[:space:]]+#-?[0-9]+,[[:space:]]*_?TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^CLR\.[BWL][[:space:]]+TEXTDISP_DEFERREDACTIONCOUNTDOWN$/ || \
        u ~ /^CLR\.[BWL][[:space:]]+_?TEXTDISP_DEFERREDACTIONCOUNTDOWN$/) deferred_action_writes++
    if (saw_deferred_action_ref && (u ~ /^BEQ\./ || u ~ /^BNE\./)) has_deferred_action_gate = 1
    if (saw_deferred_action_ref && (u ~ /^SUBQ\.[BWL][[:space:]]+#\$?1,[[:space:]]*D[0-7]$/ || \
                                    u ~ /^SUBQ\.[BWL][[:space:]]+#1,[[:space:]]*D[0-7]$/)) {
        has_deferred_minus_one_gate = 1
        saw_deferred_action_ref = 0
    }
    if (n ~ /SCRIPTCTRLCMDDEFERCOUNTER/ || n ~ /SCRIPTCTRLCMDDEFERCOUNT/) has_defer_counter = 1
    if (n ~ /SCRIPTCTRLCMDCHECKSUMERRORCOUNT/ || n ~ /SCRIPTCTRLCMDCHECKSUMERRORCOUN/) has_checksum_error = 1
    if (n ~ /SCRIPTCTRLCMDLENGTHERRORCOUNT/ || n ~ /SCRIPTCTRLCMDLENGTHERRORCOUN/) has_length_error = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1

    if (n ~ /MOVEW3SCRIPTCTRLSTATE/ || n ~ /MOVEW3SCRIPTCTRLSTAT/) has_state_set_3 = 1
    if (n ~ /MOVEW2SCRIPTCTRLSTATE/ || n ~ /MOVEW2SCRIPTCTRLSTAT/ ||
        ((n ~ /MOVEWD[0-7]SCRIPTCTRLSTATE/ || n ~ /MOVEWD[0-7]SCRIPTCTRLSTAT/) &&
         (prev_n ~ /MOVEQ2D[0-7]/ || prev_n ~ /MOVEQL2D[0-7]/ || prev_n ~ /MOVEQ\$2D[0-7]/ || prev_n ~ /MOVEQL\$2D[0-7]/))) {
        has_state_set_2 = 1
    }
    if (n ~ /CLRWSCRIPTCTRLSTATE/ || n ~ /CLRSCRIPTCTRLSTATE/ || n ~ /CLRWSCRIPTCTRLSTAT/ || n ~ /CLRSCRIPTCTRLSTAT/) has_state_clear = 1
    if (u ~ /PEA[[:space:]]+\(\$20\)\.W/ || u ~ /PEA[[:space:]]+32\.W/) has_refresh_call_32 = 1
    if (u ~ /PEA[[:space:]]+\(\$1\)\.W/ || u ~ /PEA[[:space:]]+1\.W/) has_refresh_call_32_1 = 1
    if (u ~ /^MOVEQ(\.L)?[[:space:]]+#\$?D,[[:space:]]*D[0-7]$/ || u ~ /^MOVEQ(\.L)?[[:space:]]+#13,[[:space:]]*D[0-7]$/ || u ~ /^CMP(\.[BWL])?[[:space:]]+D[0-7],[[:space:]]*D[0-7]$/) {
        if (n ~ /MOVEQD/ || n ~ /MOVEQ13/ || n ~ /CMPBD1D0/ || n ~ /CMPBD0D6/) has_body_cr_gate = 1
    }
    if (n ~ /EORLD1D0/ || n ~ /EORWD0D3/ || n ~ /EORWD1D0/) has_checksum_xor = 1
    if (n ~ /CMPLD1D0/ || n ~ /CMPWD1D0/) has_checksum_compare = 1
    if (u ~ /CMPI\.W[[:space:]]+#\$?198,[[:space:]]*D[0-7]/ || u ~ /CMPI\.W[[:space:]]+#198,[[:space:]]*D[0-7]/ ||
        u ~ /CMPI\.W[[:space:]]+#\$?C6,[[:space:]]*D[0-7]/ ||
        ((u ~ /^CMP\.W[[:space:]]+D[0-7],[[:space:]]*D[0-7]$/) &&
         (prev_n ~ /MOVEQ\$C6D[0-7]/ || prev_n ~ /MOVEQL\$C6D[0-7]/ || prev_n ~ /MOVEQ198D[0-7]/ || prev_n ~ /MOVEQL198D[0-7]/))) {
        has_length_limit_198 = 1
    }
    if ((prev2_n ~ /SCRIPTCTRLCHECKSUM/ || prev2_n ~ /SCRIPTCTRLCHECKSU/ ||
         prev_n ~ /SCRIPTCTRLCHECKSUM/ || prev_n ~ /SCRIPTCTRLCHECKSU/ ||
         n ~ /SCRIPTCTRLCHECKSUM/ || n ~ /SCRIPTCTRLCHECKSU/) &&
        (prev2_n ~ /SCRIPTCTRLREADINDEX/ || prev2_n ~ /SCRIPTCTRLREADINDE/ ||
         prev_n ~ /SCRIPTCTRLREADINDEX/ || prev_n ~ /SCRIPTCTRLREADINDE/ ||
         n ~ /SCRIPTCTRLREADINDEX/ || n ~ /SCRIPTCTRLREADINDE/) &&
        (prev2_n ~ /SCRIPTCTRLSTATE/ || prev2_n ~ /SCRIPTCTRLSTAT/ ||
         prev_n ~ /SCRIPTCTRLSTATE/ || prev_n ~ /SCRIPTCTRLSTAT/ ||
         n ~ /SCRIPTCTRLSTATE/ || n ~ /SCRIPTCTRLSTAT/)) {
        reset_triads++
    }
    if (u == "RTS") has_return = 1

    prev2_n = prev_n
    prev_n = n
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN=" has_return
    print "JMPTABLE_CASES=" jmptbl_cases

    print "HAS_SELECT_CODE_GATE=" has_select_code_gate
    print "HAS_CONFIG_MSN_GATE=" has_config_msn_gate
    print "HAS_REFRESH_TICK=" has_refresh_tick
    print "HAS_STATUS_HOLD=" has_status_hold
    print "HAS_DISPLAY_ACTIVE=" has_display_active
    print "HAS_STATUS_PENDING=" has_status_pending
    print "HAS_CLOCK_REF=" has_clock_ref
    print "HAS_CLOCK_SECONDS=" has_clock_seconds
    print "HAS_UI_BUSY=" has_ui_busy

    print "HAS_PARSE_CHANGE=" has_parse_change
    print "HAS_CAPTURE_BYTE=" has_capture_byte
    print "HAS_HANDLE_BRUSH=" has_handle_brush
    print "HAS_APPLY_PENDING=" has_apply_pending
    print "HAS_TICK_CONTEXT=" has_tick_context
    print "STATUS_REFRESH_CALLS=" status_refresh_calls
    print "HAS_SET_COPPER=" has_set_copper
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_RESET_SELECTION=" has_reset_selection

    print "HAS_CTRL_STATE=" has_ctrl_state
    print "HAS_CTRL_INDEX=" has_ctrl_index
    print "HAS_CTRL_CHECKSUM=" has_ctrl_checksum
    print "HAS_CTRL_BUFFER=" has_ctrl_buffer
    print "HAS_CTRL_CMD_COUNT=" has_ctrl_cmd_count
    print "HAS_DEFERRED_ACTION=" has_deferred_action
    print "DEFERRED_ACTION_WRITES=" deferred_action_writes
    print "HAS_DEFERRED_ACTION_GATE=" has_deferred_action_gate
    print "HAS_DEFERRED_MINUS_ONE_GATE=" has_deferred_minus_one_gate
    print "HAS_DEFER_COUNTER=" has_defer_counter
    print "HAS_CHECKSUM_ERROR=" has_checksum_error
    print "HAS_LENGTH_ERROR=" has_length_error
    print "HAS_RUNTIME_MODE=" has_runtime_mode

    print "HAS_STATE_SET_2=" has_state_set_2
    print "HAS_STATE_SET_3=" has_state_set_3
    print "HAS_STATE_CLEAR=" has_state_clear
    print "HAS_REFRESH_CALL_32=" has_refresh_call_32
    print "HAS_REFRESH_CALL_32_1=" has_refresh_call_32_1
    print "HAS_BODY_CR_GATE=" has_body_cr_gate
    print "HAS_CHECKSUM_XOR=" has_checksum_xor
    print "HAS_CHECKSUM_COMPARE=" has_checksum_compare
    print "HAS_LENGTH_LIMIT_198=" has_length_limit_198
    print "RESET_TRIADS=" reset_triads
}
