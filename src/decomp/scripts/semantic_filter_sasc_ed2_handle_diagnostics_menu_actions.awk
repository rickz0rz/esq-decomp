BEGIN {
    has_entry=0
    has_state_ring_key=0
    has_dispatch_chain=0
    has_toggle_mem_mask=0
    has_preset_bit0=0
    has_preset_bit1=0
    has_refresh_guides=0
    has_preset_bit2=0
    has_clear_counters=0
    has_text_mode_update=0
    has_vin_mode_update=0
    has_graph_mode_update=0
    has_scroll_speed_path=0
    has_view_mode_increment=0
    has_view_mode_toggle=0
    has_serial_shadow_path=0
    has_copper_effect_path=0
    has_ciab_path=0
    has_ctrl_line_path=0
    has_default_help=0
    has_rts=0

    clear_counter_count=0
    serial_string_count=0
    serial_update_count=0
    copper_string_count=0
    copper_call_count=0
    has_ciab_label=0
    has_ciab_open=0
    has_ciab_closed=0
    has_ciab_test=0
    dispatch_sub_count=0
    dispatch_branch_count=0
    pending_text_mode=0
    pending_vin_mode=0
    pending_graph_mode=0
    saw_refresh_rastport=0
    saw_toggle_mem_mask_ref=0
    saw_toggle_mask_and=0
    saw_toggle_mask_or=0
    saw_ctrl_line_string=0
    saw_assert_call=0
    saw_deassert_call=0
    saw_view_mode_load=0
    saw_view_mode_add=0
    pending_serial_shadow_value=-1
    saw_serial_transition[0]=0
    saw_serial_transition[1]=0
    saw_serial_transition[2]=0
    saw_serial_transition[3]=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ED2_HANDLEDIAGNOSTICSMENUACTIONS:/ || u ~ /^ED2_HANDLEDIAGNOSTICSMENUACTION[A-Z0-9_]*:/) has_entry=1
    if ((n ~ /STATERINGINDEX/ && n ~ /STATERINGTABLE/) || n ~ /LASTKEYCODE/) has_state_ring_key=1

    if (u ~ /^SUBQ\.[WL][ \t]+#/) dispatch_sub_count++
    if (u ~ /^SUBI\.[WL][ \t]+#/) dispatch_sub_count++
    if (u ~ /^BEQ\.[BSWL]?[ \t]/) dispatch_branch_count++
    if (dispatch_sub_count >= 20 && dispatch_branch_count >= 20) has_dispatch_chain=1

    if (n ~ /DIAGAVAILMEMMASK/) saw_toggle_mem_mask_ref=1
    if (saw_toggle_mem_mask_ref && n ~ /ANDL/ && n ~ /DIAGAVAILMEMMASK/) saw_toggle_mask_and=1
    if (saw_toggle_mem_mask_ref && n ~ /ORL/ && n ~ /DIAGAVAILMEMMASK/) saw_toggle_mask_or=1
    if (saw_toggle_mask_and && saw_toggle_mask_or) has_toggle_mem_mask=1
    if (n ~ /DIAGAVAILMEMPRESETBITS/ && n ~ /BSET0/) has_preset_bit0=1
    if (n ~ /DIAGAVAILMEMPRESETBITS/ && n ~ /BSET1/) has_preset_bit1=1
    if (n ~ /RASTPORT1/) saw_refresh_rastport=1
    if (saw_refresh_rastport && (n ~ /DRAWVIEWMODEGUIDES/ || n ~ /DRAWVIEWM/)) has_refresh_guides=1
    if (n ~ /DIAGAVAILMEMPRESETBITS/ && n ~ /BSET2/) has_preset_bit2=1

    if (n ~ /GLOBALWORDMAXVALUE/ || n ~ /CTRLHDELTAMAX/ || n ~ /ESQIFFLINEERRORCOUNT/ || n ~ /DATACERRS/ || n ~ /ESQIFFPARSEATTEMPTCOUNT/ || n ~ /SCRIPTCTRLCMDLENGTHERRORCOUNT/ || n ~ /SCRIPTCTRLCMDCHECKSUMERRORCOUNT/ || n ~ /SCRIPTCTRLCMDCOUNT/) clear_counter_count++
    if (clear_counter_count >= 8) has_clear_counters=1

    if (n ~ /DIAGTEXTMODECHAR/) pending_text_mode=1
    if (pending_text_mode && n ~ /FINDNEXTCHARINTABLE/) has_text_mode_update=1
    if (n ~ /DIAGVINMODECHAR/) pending_vin_mode=1
    if (pending_vin_mode && n ~ /FINDNEXTCHARINTABLE/) has_vin_mode_update=1
    if (n ~ /DIAGGRAPHMODECHAR/) pending_graph_mode=1
    if (pending_graph_mode && n ~ /FINDNEXTCHARINTABLE/) has_graph_mode_update=1

    if ((n ~ /DIAGSCROLLSPEEDCHAR/ && n ~ /33/) || (n ~ /DIAGSCROLLSPEEDCHAR/ && n ~ /36/) || n ~ /TEXTLIMIT/ || n ~ /BLOCKOFFSET/ || n ~ /MATHMULU32/) has_scroll_speed_path=1

    if ((n ~ /DIAGNOSTICSVIEWMODE/ && n ~ /D0/) && (n ~ /MOVEW/ || n ~ /MOVEL/)) saw_view_mode_load=1
    if (saw_view_mode_load && (n ~ /ADDQW1D0/ || n ~ /ADDQL1D0/ || n ~ /ADDQW1/ || n ~ /ADDQL1/)) saw_view_mode_add=1
    if (saw_view_mode_add && n ~ /DIAGNOSTICSVIEWMODE/ && n ~ /D0/ && (n ~ /MOVEW/ || n ~ /MOVEL/)) has_view_mode_increment=1
    if ((n ~ /DIAGNOSTICSVIEWMODE/ && (n ~ /CLRW/ || n ~ /MOVEW1/ || n ~ /SUBQW1/)) || n ~ /^SCCD0/ || n ~ /DIAGNOSTICSVIEWMODE.*D1/) has_view_mode_toggle=1

    if (n ~ /STRSILENCE/ || n ~ /STRLEFT/ || n ~ /STRRIGHT/ || n ~ /STRBACKGROUND/) serial_string_count++
    if (n ~ /^CLRL[A0-7]*$/ || n ~ /^CLRL\(A7\)$/) pending_serial_shadow_value=0
    if (n ~ /PEA1W/ || n ~ /MOVEQ1D[0-7]/ || n ~ /MOVEQ1L?D[0-7]/) pending_serial_shadow_value=1
    if (n ~ /PEA2W/ || n ~ /MOVEQ2D[0-7]/ || n ~ /MOVEQ2L?D[0-7]/) pending_serial_shadow_value=2
    if (n ~ /PEA3W/ || n ~ /MOVEQ3D[0-7]/ || n ~ /MOVEQ3L?D[0-7]/) pending_serial_shadow_value=3
    if (n ~ /UPDATESERIALSHADOWFROMCTRLBYTE/ || n ~ /UPDATESER/) {
        if (pending_serial_shadow_value >= 0) {
            if (!saw_serial_transition[pending_serial_shadow_value]) {
                saw_serial_transition[pending_serial_shadow_value]=1
                serial_update_count++
            }
            pending_serial_shadow_value=-1
        }
    }
    if (serial_string_count >= 4 && serial_update_count >= 4) has_serial_shadow_path=1

    if (n ~ /STREXTDOTVIDEOONLY/ || n ~ /STRCOMPUTERONLY/ || n ~ /STROVERLAYEXTDOTVIDEO/ || n ~ /STRNEGATIVEVIDEO/) copper_string_count++
    if (n ~ /SETCOPPEREFFECTALLON/ || n ~ /SETCOPPEREFFECTOFFDISABLEHIGHLIGHT/ || n ~ /SETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /SETCOPPEREFFECTDEFAULT/ || n ~ /SETCOPPEREFF/) copper_call_count++
    if (copper_string_count >= 4 && copper_call_count >= 4) has_copper_effect_path=1

    if (n ~ /STRVIDEOSWITCH/) has_ciab_label=1
    if (n ~ /STROPEN/) has_ciab_open=1
    if (n ~ /STRCLOSED/) has_ciab_closed=1
    if (n ~ /READCIABBIT5MASK/ || n ~ /READHANDSHAKEBIT5MASK/ || n ~ /READCIABBIT5MASK/) has_ciab_test=1
    if (has_ciab_label && has_ciab_open && has_ciab_closed && has_ciab_test) has_ciab_path=1

    if (n ~ /STRSTARTTAPEVIDEO/ || n ~ /STRSTOP/) saw_ctrl_line_string=1
    if (n ~ /ASSERTCTR/) saw_assert_call=1
    if (n ~ /DEASSERTC/) saw_deassert_call=1
    if (saw_ctrl_line_string && saw_assert_call && saw_deassert_call) has_ctrl_line_path=1
    if ((n ~ /DRAWESCMENUBOTTOMHELP/ || n ~ /DRAWESCMENUBOTTOMHEL/) && n !~ /RETURN/) has_default_help=1
    if (n ~ /DIAGNOSTICSSCREENACTIVE/ && n ~ /CLRW/) has_default_help=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATE_RING_KEY=" has_state_ring_key
    print "HAS_DISPATCH_CHAIN=" has_dispatch_chain
    print "HAS_TOGGLE_MEM_MASK=" has_toggle_mem_mask
    print "HAS_PRESET_BIT0=" has_preset_bit0
    print "HAS_PRESET_BIT1=" has_preset_bit1
    print "HAS_REFRESH_GUIDES=" has_refresh_guides
    print "HAS_PRESET_BIT2=" has_preset_bit2
    print "HAS_CLEAR_COUNTERS=" has_clear_counters
    print "HAS_TEXT_MODE_UPDATE=" has_text_mode_update
    print "HAS_VIN_MODE_UPDATE=" has_vin_mode_update
    print "HAS_GRAPH_MODE_UPDATE=" has_graph_mode_update
    print "HAS_SCROLL_SPEED_PATH=" has_scroll_speed_path
    print "HAS_VIEW_MODE_INCREMENT=" has_view_mode_increment
    print "HAS_VIEW_MODE_TOGGLE=" has_view_mode_toggle
    print "HAS_SERIAL_SHADOW_PATH=" has_serial_shadow_path
    print "HAS_COPPER_EFFECT_PATH=" has_copper_effect_path
    print "HAS_CIAB_PATH=" has_ciab_path
    print "HAS_CTRL_LINE_PATH=" has_ctrl_line_path
    print "HAS_DEFAULT_HELP=" has_default_help
    print "HAS_RTS=" has_rts
}
