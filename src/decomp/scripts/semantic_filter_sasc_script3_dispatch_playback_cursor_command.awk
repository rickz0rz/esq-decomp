BEGIN {
    has_entry = 0
    has_clear_search = 0
    clear_search_count = 0
    has_reset_sel = 0
    reset_sel_count = 0
    has_set_copper = 0
    set_copper_count = 0
    has_set_rast = 0
    set_rast_count = 0
    has_update_shadow = 0
    update_shadow_count = 0
    has_shadow_value1 = 0
    has_shadow_value3 = 0
    has_custom_copper = 0
    has_render_aligned = 0
    render_aligned_count = 0
    has_render_arg53 = 0
    has_weather = 0
    has_weather_pending_cmd = 0
    has_textdisp_cmd = 0
    has_textdisp_pending_cmd = 0
    has_textdisp_pending_arg = 0
    has_textdisp_command_ptr = 0
    has_assert_ctrl = 0
    has_read_latch = 0
    read_latch_count = 0
    has_read_flags = 0
    read_flags_count = 0
    has_read_flags_256 = 0
    has_pending_target = 0
    pending_target_count = 0
    has_pending_target_plus28 = 0
    has_pending_speed = 0
    pending_speed_count = 0
    has_pending_speed_1000 = 0
    has_runtime_mode = 0
    has_runtime_mode_one = 0
    has_fallback_counter = 0
    has_deferred_guard = 0
    has_deferred_countdown = 0
    has_deferred_armed = 0
    has_bne = 0
    has_add_28 = 0
    has_banner_head = 0
    has_current_match_index = 0
    current_match_index_count = 0
    has_cursor_ptr_write = 0
    has_return = 0
    prev_u = ""
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

    if (u ~ /^SCRIPT_DISPATCHPLAYBACKCURSORCOMMAND:/ || u ~ /^SCRIPT_DISPATCHPLAYBACKCURSORC[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^BNE\./) has_bne = 1
    if (n ~ /SCRIPTCLEARSEARCHTEXTSANDCHANNELS/ || n ~ /SCRIPTCLEARSEARCHTEXTSANDCHAN/) {
        has_clear_search = 1
        clear_search_count += 1
    }
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFR/) {
        has_reset_sel = 1
        reset_sel_count += 1
    }
    if (n ~ /WDISPJMPTBLESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /WDISPJMPTBLESQSETCOPPEREFF/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHL/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGH/) {
        has_set_copper = 1
        set_copper_count += 1
    }
    if (n ~ /TEXTDISPSETRASTFORMODE/ || n ~ /TEXTDISPSETRASTFORMOD/) {
        has_set_rast = 1
        set_rast_count += 1
    }
    if (n ~ /SCRIPTUPDATESERIALSHADOWFROMCTRLBYTE/ || n ~ /SCRIPTUPDATESERIALSHADOWFR/) {
        has_update_shadow = 1
        update_shadow_count += 1
    }
    if (u ~ /PEA[ ]+\(\$1\)\.W/ || u ~ /PEA[ ]+1\.W/ || u ~ /PEA[ ]+\(1\)\.W/ || u ~ /PEA[ ]+\$1\.W/) has_shadow_value1 = 1
    if (u ~ /PEA[ ]+\(\$3\)\.W/ || u ~ /PEA[ ]+3\.W/ || u ~ /PEA[ ]+\(3\)\.W/ || u ~ /PEA[ ]+\$3\.W/) has_shadow_value3 = 1
    if (n ~ /SCRIPT3JMPTBLESQSETCOPPEREFFECTCUSTOM/ || n ~ /SCRIPT3JMPTBLESQSETCOPPEREFF/ || n ~ /ESQSETCOPPEREFFECTCUSTOM/) has_custom_copper = 1
    if (n ~ /SCRIPT3JMPTBLCLEANUPRENDERALIGNEDSTATUSSCREEN/ || n ~ /SCRIPT3JMPTBLCLEANUPRENDERALIGNEDSTAT/ || n ~ /SCRIPT3JMPTBLCLEANUPRENDERALI/ || n ~ /CLEANUPRENDERALIGNEDSTATUSSCREEN/ || n ~ /CLEANUPRENDERALIGNEDSTATUSSCR/ || n ~ /CLEANUPRENDERALIGNEDSTATUSSCRE/ || n ~ /CLEANUPRENDERALIGNEDSTATUSS/) {
        has_render_aligned = 1
        render_aligned_count += 1
    }
    if (u ~ /#\$35/ || u ~ /PEA[ ]+\(\$35\)\.W/ || u ~ /PEA[ ]+53\.W/ || u ~ /PEA[ ]+\(53\)\.W/) has_render_arg53 = 1
    if (n ~ /WDISPHANDLEWEATHERSTATUSCOMMAND/ || n ~ /WDISPHANDLEWEATHERSTATUSCOM/) has_weather = 1
    if (n ~ /SCRIPTPENDINGWEATHERCOMMANDCHAR/ || n ~ /SCRIPTPENDINGWEATHERCOMMANDCHA/) has_weather_pending_cmd = 1
    if (n ~ /TEXTDISPHANDLESCRIPTCOMMAND/ || n ~ /TEXTDISPHANDLESCRIPTCOM/) has_textdisp_cmd = 1
    if (n ~ /SCRIPTPENDINGTEXTDISPCMDCHAR/ || n ~ /SCRIPTPENDINGTEXTDISPCMDCHA/) has_textdisp_pending_cmd = 1
    if (n ~ /SCRIPTPENDINGTEXTDISPCMDARG/ || n ~ /SCRIPTPENDINGTEXTDISPCMDA/) has_textdisp_pending_arg = 1
    if (n ~ /SCRIPTCOMMANDTEXTPTR/ || n ~ /SCRIPTCOMMANDTEXTPT/) has_textdisp_command_ptr = 1
    if (n ~ /SCRIPTASSERTCTRLLINENOW/ || n ~ /SCRIPTASSERTCTRLLINENO/) has_assert_ctrl = 1
    if (n ~ /SCRIPTREADMODEACTIVELATCH/ || n ~ /SCRIPTREADMODEACTIVELATC/) {
        has_read_latch = 1
        read_latch_count += 1
    }
    if (n ~ /ESQPARS2READMODEFLAGS/ || n ~ /ESQPARS2READMODEFLAG/) {
        has_read_flags = 1
        read_flags_count += 1
    }
    if (u ~ /#\$100/ || u ~ /#256/) has_read_flags_256 = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/ || n ~ /SCRIPTPENDINGBANNERTARGETCHA/) {
        has_pending_target = 1
        pending_target_count += 1
    }
    if (u ~ /#\$1C/ || u ~ /#28/) has_add_28 = 1
    if (n ~ /CONFIGBANNERCOPPERHEADBYTE/ || n ~ /CONFIGBANNERCOPPERHEADBYT/) has_banner_head = 1
    if (has_add_28 && has_banner_head && has_pending_target) has_pending_target_plus28 = 1
    if (n ~ /SCRIPTPENDINGBANNERSPEEDMS/ || n ~ /SCRIPTPENDINGBANNERSPEEDM/) {
        has_pending_speed = 1
        pending_speed_count += 1
    }
    if (u ~ /#\$3E8/ || u ~ /#1000/) has_pending_speed_1000 = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if ((n ~ /SCRIPTRUNTIMEMODE/) && (u ~ /#\$1/ || u ~ /#1/)) has_runtime_mode_one = 1
    if (n ~ /SCRIPTPLAYBACKFALLBACKCOUNTER/ || n ~ /SCRIPTPLAYBACKFALLBACKCOU/) has_fallback_counter = 1
    if (n ~ /TEXTDISPDEFERREDACTIONCOUNTDOWN/ || n ~ /TEXTDISPDEFERREDACTIONCOUNTD/) has_deferred_countdown = 1
    if (n ~ /TEXTDISPDEFERREDACTIONARMED/ || n ~ /TEXTDISPDEFERREDACTIONARME/) has_deferred_armed = 1
    if (has_deferred_countdown && has_bne) has_deferred_guard = 1
    if ((n ~ /TEXTDISPCURRENTMATCHINDEX/ || n ~ /TEXTDISPCURRENTMATCHIND/) && (u ~ /^MOVE\.W / || u ~ /^CLR\.W /)) {
        has_current_match_index = 1
        current_match_index_count += 1
    }
    if (u ~ /^CLR\.L \(A[0-7]\)$/) has_cursor_ptr_write = 1
    if (u == "RTS") has_return = 1

    prev_u = u
    prev_n = n
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLEAR_SEARCH=" has_clear_search
    print "HAS_CLEAR_SEARCH_COUNT_GE1=" (clear_search_count >= 1)
    print "HAS_RESET_SEL=" has_reset_sel
    print "HAS_RESET_SEL_COUNT_EQ1=" (reset_sel_count == 1)
    print "HAS_SET_COPPER=" has_set_copper
    print "HAS_SET_COPPER_COUNT_GE3=" (set_copper_count >= 3)
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_SET_RAST_COUNT_GE3=" (set_rast_count >= 3)
    print "HAS_UPDATE_SHADOW=" has_update_shadow
    print "HAS_UPDATE_SHADOW_COUNT_GE3=" (update_shadow_count >= 3)
    print "HAS_SHADOW_VALUE1=" has_shadow_value1
    print "HAS_SHADOW_VALUE3=" has_shadow_value3
    print "HAS_CUSTOM_COPPER=" has_custom_copper
    print "HAS_RENDER_ALIGNED=" has_render_aligned
    print "HAS_RENDER_ALIGNED_COUNT_GE3=" (render_aligned_count >= 3)
    print "HAS_RENDER_ARG53=" has_render_arg53
    print "HAS_WEATHER=" has_weather
    print "HAS_WEATHER_PENDING_CMD=" has_weather_pending_cmd
    print "HAS_TEXTDISP_CMD=" has_textdisp_cmd
    print "HAS_TEXTDISP_PENDING_CMD=" has_textdisp_pending_cmd
    print "HAS_TEXTDISP_PENDING_ARG=" has_textdisp_pending_arg
    print "HAS_TEXTDISP_COMMAND_PTR=" has_textdisp_command_ptr
    print "HAS_ASSERT_CTRL=" has_assert_ctrl
    print "HAS_READ_LATCH=" has_read_latch
    print "HAS_READ_LATCH_COUNT_EQ2=" (read_latch_count == 2)
    print "HAS_READ_FLAGS=" has_read_flags
    print "HAS_READ_FLAGS_COUNT_EQ2=" (read_flags_count == 2)
    print "HAS_READ_FLAGS_256=" has_read_flags_256
    print "HAS_PENDING_TARGET=" has_pending_target
    print "HAS_PENDING_TARGET_COUNT_GE2=" (pending_target_count >= 2)
    print "HAS_PENDING_TARGET_PLUS28=" has_pending_target_plus28
    print "HAS_PENDING_SPEED=" has_pending_speed
    print "HAS_PENDING_SPEED_COUNT_GE2=" (pending_speed_count >= 2)
    print "HAS_PENDING_SPEED_1000=" has_pending_speed_1000
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_RUNTIME_MODE_ONE=" has_runtime_mode_one
    print "HAS_FALLBACK_COUNTER=" has_fallback_counter
    print "HAS_DEFERRED_GUARD=" has_deferred_guard
    print "HAS_DEFERRED_COUNTDOWN=" has_deferred_countdown
    print "HAS_DEFERRED_ARMED=" has_deferred_armed
    print "HAS_CURRENT_MATCH_INDEX=" has_current_match_index
    print "HAS_CURRENT_MATCH_INDEX_COUNT_GE5=" (current_match_index_count >= 5)
    print "HAS_CURSOR_PTR_WRITE=" has_cursor_ptr_write
    print "HAS_RETURN=" has_return
}
