BEGIN {
    has_entry = 0
    has_key_fetch = 0
    has_dispatch_chain = 0
    has_mem_mask_toggle = 0
    has_preset_cycle = 0
    has_clear_counters = 0
    has_text_mode_update = 0
    has_scroll_speed_update = 0
    has_graph_mode_update = 0
    has_ctrl_line_path = 0
    has_serial_shadow_path = 0
    has_copper_effect_path = 0
    has_ciab_status_path = 0
    has_vin_mode_update = 0
    has_view_mode_increment = 0
    has_view_mode_toggle = 0
    has_default_exit = 0
    has_rts = 0

    dispatch_sub_count = 0
    dispatch_branch_count = 0
    preset_bit_count = 0
    clear_counter_count = 0
    serial_value_count = 0
    copper_call_count = 0

    saw_state_ring_index = 0
    saw_state_ring_table = 0
    saw_last_key_code = 0
    saw_toggle_and = 0
    saw_toggle_or = 0
    saw_find_text_mode = 0
    saw_find_graph_mode = 0
    saw_find_vin_mode = 0
    saw_draw_mode_text = 0
    pending_text_mode = 0
    pending_graph_mode = 0
    pending_vin_mode = 0
    saw_scroll_speed_char = 0
    pending_scroll_speed = 0
    saw_scroll_wrap_compare = 0
    saw_scroll_wrap_reset = 0
    saw_scroll_decrement = 0
    saw_scroll_text_limit = 0
    saw_scroll_mul40 = 0
    pending_scroll_mul40 = 0
    saw_scroll_block_offset = 0
    saw_ctrl_string_start = 0
    saw_ctrl_string_stop = 0
    saw_ctrl_assert = 0
    saw_ctrl_deassert = 0
    saw_serial_silence = 0
    saw_serial_left = 0
    saw_serial_right = 0
    saw_serial_background = 0
    saw_serial_update = 0
    saw_copper_all_on = 0
    saw_copper_all_off = 0
    saw_copper_overlay = 0
    saw_copper_default = 0
    pending_copper_all_on = 0
    pending_copper_all_off = 0
    pending_copper_overlay = 0
    pending_copper_default = 0
    saw_ciab_video_switch = 0
    saw_ciab_open = 0
    saw_ciab_closed = 0
    saw_ciab_test = 0
    saw_view_mode_store = 0
    saw_view_mode_add = 0
    saw_view_mode_toggle_test = 0
    saw_help_call = 0
    saw_screen_disable = 0
}

function norm(line, t) {
    t = line
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") {
        next
    }

    alnum = line
    gsub(/[^A-Z0-9]/, "", alnum)

    if (line ~ /^ED2_HANDLEDIAGNOSTICSMENUACTIONS:/ || line ~ /^ED2_HANDLEDIAGNOSTICSMENUACTION[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (alnum ~ /EDSTATERINGINDEX/) {
        saw_state_ring_index = 1
    }
    if (alnum ~ /EDSTATERINGTABLE/) {
        saw_state_ring_table = 1
    }
    if (alnum ~ /EDLASTKEYCODE/) {
        saw_last_key_code = 1
    }
    if (saw_state_ring_index && saw_state_ring_table && saw_last_key_code) {
        has_key_fetch = 1
    }

    if (line ~ /^SUBQ\.[WL]/ || line ~ /^SUBI\.[WL]/) {
        dispatch_sub_count++
    }
    if (line ~ /^BEQ\./) {
        dispatch_branch_count++
    }
    if (dispatch_sub_count >= 20 && dispatch_branch_count >= 20) {
        has_dispatch_chain = 1
    }

    if (alnum ~ /EDDIAGAVAILMEMMASK/ && alnum ~ /ANDL/) {
        saw_toggle_and = 1
    }
    if (alnum ~ /EDDIAGAVAILMEMMASK/ && alnum ~ /ORL/) {
        saw_toggle_or = 1
    }
    if (saw_toggle_and && saw_toggle_or) {
        has_mem_mask_toggle = 1
    }

    if (alnum ~ /EDDIAGAVAILMEMPRESETBITS/ && alnum ~ /BSET/) {
        preset_bit_count++
    }
    if (preset_bit_count >= 3) {
        has_preset_cycle = 1
    }

    if (alnum ~ /GLOBALWORDMAXVALUE/ ||
        alnum ~ /CTRLHDELTAMAX/ ||
        alnum ~ /ESQIFFLINEERRORCOUNT/ ||
        alnum ~ /DATACERRS/ ||
        alnum ~ /ESQIFFPARSEATTEMPTCOUNT/ ||
        alnum ~ /SCRIPTCTRLCMDLENGTHERRORCOUNT/ ||
        alnum ~ /SCRIPTCTRLCMDCHECKSUMERRORCOUNT/ ||
        alnum ~ /SCRIPTCTRLCMDCOUNT/) {
        clear_counter_count++
    }
    if (clear_counter_count >= 8) {
        has_clear_counters = 1
    }

    if ((alnum ~ /EDDIAGTEXTMODECHAR/ || alnum ~ /ED2TAGNRLS/) && alnum ~ /EDFINDNEXTCHARINTABLE/) {
        saw_find_text_mode = 1
    }
    if (alnum ~ /EDDIAGTEXTMODECHAR/ || alnum ~ /ED2TAGNRLS/) {
        pending_text_mode = 6
    }
    if ((alnum ~ /EDDIAGGRAPHMODECHAR/ || alnum ~ /ED2TAGNYLRS/) && alnum ~ /EDFINDNEXTCHARINTABLE/) {
        saw_find_graph_mode = 1
    }
    if (alnum ~ /EDDIAGGRAPHMODECHAR/ || alnum ~ /ED2TAGNYLRS/) {
        pending_graph_mode = 6
    }
    if ((alnum ~ /EDDIAGVINMODECHAR/ || alnum ~ /ED2STRNYYLLZ/) && alnum ~ /EDFINDNEXTCHARINTABLE/) {
        saw_find_vin_mode = 1
    }
    if (alnum ~ /EDDIAGVINMODECHAR/ || alnum ~ /ED2STRNYYLLZ/) {
        pending_vin_mode = 6
    }
    if (pending_text_mode > 0 && alnum ~ /EDFINDNEXTCHARINTABLE/) {
        saw_find_text_mode = 1
    }
    if (pending_graph_mode > 0 && alnum ~ /EDFINDNEXTCHARINTABLE/) {
        saw_find_graph_mode = 1
    }
    if (pending_vin_mode > 0 && alnum ~ /EDFINDNEXTCHARINTABLE/) {
        saw_find_vin_mode = 1
    }
    if (alnum ~ /EDDRAWDIAGNOSTICMODETEXT/) {
        saw_draw_mode_text = 1
    }
    if (saw_find_text_mode && saw_draw_mode_text) {
        has_text_mode_update = 1
    }
    if (saw_find_graph_mode && saw_draw_mode_text) {
        has_graph_mode_update = 1
    }
    if (saw_find_vin_mode && saw_draw_mode_text) {
        has_vin_mode_update = 1
    }

    if (alnum ~ /EDDIAGSCROLLSPEEDCHAR/) {
        saw_scroll_speed_char = 1
        pending_scroll_speed = 8
    }
    if (pending_scroll_speed > 0 && (alnum ~ /CMPB/ || alnum ~ /CMP/ || alnum ~ /MOVEQ/) &&
        (alnum ~ /33/ || alnum ~ /51/)) {
        saw_scroll_wrap_compare = 1
    }
    if (pending_scroll_speed > 0 && (alnum ~ /MOVEQ/ || alnum ~ /MOVEB/ || alnum ~ /MOVE/) &&
        (alnum ~ /36/ || alnum ~ /54/)) {
        saw_scroll_wrap_reset = 1
    }
    if (saw_scroll_speed_char && (alnum ~ /SUBQB1D0/ || alnum ~ /SUBQB1D1/)) {
        saw_scroll_decrement = 1
    }
    if (alnum ~ /EDTEXTLIMIT/) {
        saw_scroll_text_limit = 1
    }
    if (pending_scroll_speed > 0 && (alnum ~ /MOVEQ/ || alnum ~ /PEA/ || alnum ~ /MOVE/) &&
        (alnum ~ /28/ || alnum ~ /40/)) {
        pending_scroll_mul40 = 4
    }
    if (pending_scroll_mul40 > 0 && (alnum ~ /ESQIFFJMPTBLMATHMULU32/ || alnum ~ /MATHMULU32/)) {
        saw_scroll_mul40 = 1
    }
    if (alnum ~ /EDBLOCKOFFSET/) {
        saw_scroll_block_offset = 1
    }
    if (alnum ~ /ED2STRSTARTTAPEVIDEO/) {
        saw_ctrl_string_start = 1
    }
    if (alnum ~ /ED2STRSTOP/) {
        saw_ctrl_string_stop = 1
    }
    if (alnum ~ /ASSERTCTR/ || alnum ~ /ASSERTCTRLLINENOW/) {
        saw_ctrl_assert = 1
    }
    if (alnum ~ /DEASSERTC/ || alnum ~ /DEASSERTCTRLLINENOW/) {
        saw_ctrl_deassert = 1
    }
    if (saw_ctrl_string_start && saw_ctrl_string_stop && saw_ctrl_assert && saw_ctrl_deassert) {
        has_ctrl_line_path = 1
    }

    if (alnum ~ /ED2STRSILENCE/) {
        saw_serial_silence = 1
    }
    if (alnum ~ /ED2STRLEFT/) {
        saw_serial_left = 1
    }
    if (alnum ~ /ED2STRRIGHT/) {
        saw_serial_right = 1
    }
    if (alnum ~ /ED2STRBACKGROUND/) {
        saw_serial_background = 1
    }
    if (alnum ~ /UPDATESERIALSHADOWFROMCTRLBYTE/ || alnum ~ /UPDATESER/) {
        saw_serial_update = 1
        serial_value_count++
    }
    if (saw_serial_silence && saw_serial_left && saw_serial_right && saw_serial_background &&
        saw_serial_update && serial_value_count >= 4) {
        has_serial_shadow_path = 1
    }

    if (alnum ~ /ED2STREXTDOTVIDEOONLY/) {
        pending_copper_all_on = 6
    }
    if (alnum ~ /ED2STRCOMPUTERONLY/) {
        pending_copper_all_off = 6
    }
    if (alnum ~ /ED2STROVERLAYEXTDOTVIDEO/) {
        pending_copper_overlay = 6
    }
    if (alnum ~ /ED2STRNEGATIVEVIDEO/) {
        pending_copper_default = 6
    }
    if (pending_copper_all_on > 0 && (alnum ~ /SETCOPPEREFFECTALLON/ || alnum ~ /SETCOPPEREFF/)) {
        saw_copper_all_on = 1
    }
    if (pending_copper_all_off > 0 && (alnum ~ /OFFDISABLEHIGHLIGHT/ || alnum ~ /SETCOPPEREFF/)) {
        saw_copper_all_off = 1
    }
    if (pending_copper_overlay > 0 && (alnum ~ /ONENABLEHIGHLIGHT/ || alnum ~ /SETCOPPEREFF/)) {
        saw_copper_overlay = 1
    }
    if (pending_copper_default > 0 && (alnum ~ /SETCOPPEREFFECTDEFAULT/ || alnum ~ /SETCOPPEREFF/)) {
        saw_copper_default = 1
    }
    if (alnum ~ /SETCOPPEREFF/) {
        copper_call_count++
    }
    if (saw_copper_all_on && saw_copper_all_off && saw_copper_overlay && saw_copper_default &&
        copper_call_count >= 4) {
        has_copper_effect_path = 1
    }

    if (alnum ~ /ED2STRVIDEOSWITCH/) {
        saw_ciab_video_switch = 1
    }
    if (alnum ~ /ED2STROPEN/) {
        saw_ciab_open = 1
    }
    if (alnum ~ /ED2STRCLOSED/) {
        saw_ciab_closed = 1
    }
    if (alnum ~ /READHANDSHAKEBIT5MASK/ || alnum ~ /SCRIPTREADHANDSHAKEBIT5MASK/ || alnum ~ /READCIABBIT5MASK/) {
        saw_ciab_test = 1
    }
    if (saw_ciab_video_switch && saw_ciab_open && saw_ciab_closed && saw_ciab_test) {
        has_ciab_status_path = 1
    }

    if (alnum ~ /EDDIAGNOSTICSVIEWMODE/ && (alnum ~ /MOVEW/ || alnum ~ /MOVEL/)) {
        saw_view_mode_store = 1
    }
    if (alnum ~ /ADDQW1D0/ || alnum ~ /ADDQL1D0/ || alnum ~ /ADDQW1/ || alnum ~ /ADDQL1/) {
        saw_view_mode_add = 1
    }
    if (saw_view_mode_store && saw_view_mode_add) {
        has_view_mode_increment = 1
    }
    if ((alnum ~ /EDDIAGNOSTICSVIEWMODE/ && (alnum ~ /CLRW/ || alnum ~ /MOVEW1/)) ||
        alnum ~ /SCCD0/ || alnum ~ /SUBBD0D1/ || alnum ~ /SUBQW1D0/) {
        saw_view_mode_toggle_test = 1
    }
    if (saw_view_mode_store && saw_view_mode_toggle_test) {
        has_view_mode_toggle = 1
    }

    if (alnum ~ /EDDRAWESCMENUBOTTOMHELP/) {
        saw_help_call = 1
    }
    if (alnum ~ /EDDIAGNOSTICSSCREENACTIVE/ && alnum ~ /CLRW/) {
        saw_screen_disable = 1
    }
    if (saw_help_call && saw_screen_disable) {
        has_default_exit = 1
    }

    if (line == "RTS") {
        has_rts = 1
    }

    if (pending_text_mode > 0) {
        pending_text_mode--
    }
    if (pending_graph_mode > 0) {
        pending_graph_mode--
    }
    if (pending_vin_mode > 0) {
        pending_vin_mode--
    }
    if (pending_scroll_speed > 0) {
        pending_scroll_speed--
    }
    if (pending_scroll_mul40 > 0) {
        pending_scroll_mul40--
    }
    if (pending_copper_all_on > 0) {
        pending_copper_all_on--
    }
    if (pending_copper_all_off > 0) {
        pending_copper_all_off--
    }
    if (pending_copper_overlay > 0) {
        pending_copper_overlay--
    }
    if (pending_copper_default > 0) {
        pending_copper_default--
    }
}

END {
    if (saw_scroll_speed_char && saw_scroll_wrap_compare && saw_scroll_wrap_reset &&
        saw_scroll_decrement && saw_scroll_text_limit && saw_scroll_mul40 &&
        saw_scroll_block_offset && saw_draw_mode_text) {
        has_scroll_speed_update = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_KEY_FETCH=" has_key_fetch
    print "HAS_DISPATCH_CHAIN=" has_dispatch_chain
    print "HAS_MEM_MASK_TOGGLE=" has_mem_mask_toggle
    print "HAS_PRESET_CYCLE=" has_preset_cycle
    print "HAS_CLEAR_COUNTERS=" has_clear_counters
    print "HAS_TEXT_MODE_UPDATE=" has_text_mode_update
    print "HAS_SCROLL_SPEED_UPDATE=" has_scroll_speed_update
    print "HAS_GRAPH_MODE_UPDATE=" has_graph_mode_update
    print "HAS_CTRL_LINE_PATH=" has_ctrl_line_path
    print "HAS_SERIAL_SHADOW_PATH=" has_serial_shadow_path
    print "HAS_COPPER_EFFECT_PATH=" has_copper_effect_path
    print "HAS_CIAB_STATUS_PATH=" has_ciab_status_path
    print "HAS_VIN_MODE_UPDATE=" has_vin_mode_update
    print "HAS_VIEW_MODE_INCREMENT=" has_view_mode_increment
    print "HAS_VIEW_MODE_TOGGLE=" has_view_mode_toggle
    print "HAS_DEFAULT_EXIT=" has_default_exit
    print "HAS_RTS=" has_rts
}
