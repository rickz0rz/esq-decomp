BEGIN {
    has_entry = 0
    has_probe = 0
    has_display_cmp = 0
    has_poll = 0
    has_grid_gate = 0
    has_grid = 0
    has_esc = 0
    has_serial_gate = 0
    has_serial = 0
    has_alert_gate = 0
    has_alerts = 0
    has_persist_test = 0
    has_persist_clear = 0
    has_commit = 0
    has_ifftask_gate = 0
    has_gate1_btst = 0
    has_gate1_clear = 0
    has_reset_refresh = 0
    has_gate0_btst = 0
    has_gate0_clear = 0
    has_next_frame = 0
    has_logo_ref_test = 0
    has_clear_logo_asset_flag = 0
    has_diag_cmp = 0
    has_gads_ref_test = 0
    has_clear_gads_asset_flag = 0
    has_weather_list_test = 0
    has_banner_resource_test = 0
    has_queue_load = 0
    has_logo_count_cmp = 0
    has_service_asset0 = 0
    has_gads_count_cmp = 0
    has_service_asset1 = 0
    has_tick_display = 0
    has_status_pending_test = 0
    has_holdoff_test = 0
    has_status_clear = 0
    has_refresh_status = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_PROCESSUIFRAMETICK:/) has_entry = 1

    if (uline ~ /ESQFUNC_JMPTBL_DISKIO_PROBEDRIVESANDASSIGNPATHS/ ||
        uline ~ /DISKIO_PROBEDRIVESANDASSIGNPATHS/ ||
        uline ~ /ESQFUNC_JMPTBL_DISKIO_PROBEDRIVE/) has_probe = 1

    if (uline ~ /CMP\.L ESQDISP_DISPLAYACTIVEFLAG/ ||
        uline ~ /CMP\.L ESQDISP_DISPLAYACTIVEFLAG\(A4\)/) has_display_cmp = 1

    if (uline ~ /ESQDISP_POLLINPUTMODEANDREFRESHSELECTION/ ||
        uline ~ /ESQDISP_POLLINPUTMODEANDREFRESHS/) has_poll = 1

    if (uline ~ /TST\.W GLOBAL_UIBUSYFLAG/ ||
        uline ~ /MOVE\.W GLOBAL_UIBUSYFLAG\(A4\),D[01]/) has_grid_gate = 1

    if (uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDLE/ ||
        uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDL/) has_grid = 1

    if (uline ~ /ED_DISPATCHESCMENUSTATE/) has_esc = 1

    if (uline ~ /TST\.W GLOBAL_UIBUSYFLAG/ ||
        uline ~ /MOVE\.W GLOBAL_UIBUSYFLAG\(A4\),D[01]/) has_serial_gate = 1

    if (uline ~ /ESQFUNC_JMPTBL_SCRIPT_HANDLESERIALCTRLCMD/ ||
        uline ~ /SCRIPT_HANDLESERIALCTRLCMD/ ||
        uline ~ /ESQFUNC_JMPTBL_SCRIPT_HANDLESERI/) has_serial = 1

    if (uline ~ /TST\.W CLEANUP_PENDINGALERTFLAG/ ||
        uline ~ /MOVE\.W CLEANUP_PENDINGALERTFLAG\(A4\),D0/) has_alert_gate = 1

    if (uline ~ /ESQFUNC_JMPTBL_CLEANUP_PROCESSALERTS/ ||
        uline ~ /CLEANUP_PROCESSALERTS/ ||
        uline ~ /ESQFUNC_JMPTBL_CLEANUP_PROCESSAL/) has_alerts = 1

    if (uline ~ /TST\.L ESQDISP_SECONDARYPERSISTREQUESTFLAG/ ||
        uline ~ /TST\.L ESQDISP_SECONDARYPERSISTREQUESTF\(A4\)/) has_persist_test = 1

    if (uline ~ /CLR\.L ESQDISP_SECONDARYPERSISTREQUESTFLAG/ ||
        uline ~ /CLR\.L ESQDISP_SECONDARYPERSISTREQUESTF\(A4\)/) has_persist_clear = 1

    if (uline ~ /ESQFUNC_COMMITSECONDARYSTATEANDPERSIST/ ||
        uline ~ /ESQFUNC_COMMITSECONDARYSTATEANDP/) has_commit = 1

    if (uline ~ /TST\.W CTASKS_IFFTASKDONEFLAG/ ||
        uline ~ /MOVE\.W CTASKS_IFFTASKDONEFLAG\(A4\),D0/) has_ifftask_gate = 1

    if (uline ~ /BTST #\$?1,ESQFUNC_IFFTASKGATEFLAGS/ ||
        uline ~ /BTST #\$?1,D0/) has_gate1_btst = 1

    if (uline ~ /BCLR #\$?1,ESQFUNC_IFFTASKGATEFLAGS/ ||
        (uline ~ /MOVE\.B D1,ESQFUNC_IFFTASKGATEFLAGS\(A4\)/ && has_gate1_btst && !has_reset_refresh)) has_gate1_clear = 1

    if (uline ~ /ESQFUNC_JMPTBL_TEXTDISP_RESETSELECTIONANDREFRESH/ ||
        uline ~ /TEXTDISP_RESETSELECTIONANDREFRESH/ ||
        uline ~ /TEXTDISP_RESETSELECTIONANDREFRES/ ||
        uline ~ /ESQFUNC_JMPTBL_TEXTDISP_RESETSEL/) has_reset_refresh = 1

    if (uline ~ /BTST #\$?0,ESQFUNC_IFFTASKGATEFLAGS/ ||
        uline ~ /BTST #\$?0,D0/) has_gate0_btst = 1

    if (uline ~ /BCLR #\$?0,ESQFUNC_IFFTASKGATEFLAGS/ ||
        (uline ~ /MOVE\.B D1,ESQFUNC_IFFTASKGATEFLAGS\(A4\)/ && has_gate0_btst && !has_next_frame)) has_gate0_clear = 1

    if (uline ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAME/ ||
        uline ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAM/) has_next_frame = 1

    if (uline ~ /TST\.L GLOBAL_REF_LONG_DF0_LOGO_LST_DATA/ ||
        uline ~ /TST\.L GLOBAL_REF_LONG_DF0_LOGO_LST_DAT\(A4\)/) has_logo_ref_test = 1

    if (uline ~ /ANDI\.[WL] #\$FFFD,D[01]/) has_clear_logo_asset_flag = 1

    if (uline ~ /MOVEQ #78,D1/ ||
        uline ~ /MOVEQ\.L #\$4E,D1/) has_diag_cmp = 1

    if (uline ~ /TST\.L GLOBAL_REF_LONG_GFX_G_ADS_DATA/ ||
        uline ~ /TST\.L GLOBAL_REF_LONG_GFX_G_ADS_DATA\(A4\)/) has_gads_ref_test = 1

    if (uline ~ /ANDI\.[WL] #\$FFFE,D0/) has_clear_gads_asset_flag = 1

    if (uline ~ /TST\.L WDISP_WEATHERSTATUSBRUSHLISTHEAD/ ||
        uline ~ /TST\.L WDISP_WEATHERSTATUSBRUSHLISTHEAD\(A4\)/) has_weather_list_test = 1

    if (uline ~ /TST\.L PARSEINI_BANNERBRUSHRESOURCEHEAD/ ||
        uline ~ /TST\.L PARSEINI_BANNERBRUSHRESOURCEHEAD\(A4\)/) has_banner_resource_test = 1

    if (uline ~ /ESQIFF_QUEUEIFFBRUSHLOAD/) has_queue_load = 1

    if (uline ~ /CMPI\.L #\$?1,ESQIFF_LOGOBRUSHLISTCOUNT/ ||
        uline ~ /CMPI\.L #\$?1,ESQIFF_LOGOBRUSHLISTCOUNT\(A4\)/) has_logo_count_cmp = 1

    if ((uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/ ||
         uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURC/) &&
        !has_service_asset0) {
        if (prev_uline ~ /^CLR\.L -\(A7\)$/) has_service_asset0 = 1
        else if (prev_uline ~ /^PEA (\(\$1\)|1)\.[Ww]$/ && !has_service_asset1) has_service_asset1 = 1
    }

    if (uline ~ /CMPI\.L #\$?2,ESQIFF_GADSBRUSHLISTCOUNT/ ||
        uline ~ /CMPI\.L #\$?2,ESQIFF_GADSBRUSHLISTCOUNT\(A4\)/) has_gads_count_cmp = 1

    if ((uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/ ||
         uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURC/) &&
        prev_uline ~ /^PEA (\(\$1\)|1)\.[Ww]$/) has_service_asset1 = 1

    if (uline ~ /ESQFUNC_JMPTBL_TEXTDISP_TICKDISPLAYSTATE/ ||
        uline ~ /TEXTDISP_TICKDISPLAYSTATE/ ||
        uline ~ /ESQFUNC_JMPTBL_TEXTDISP_TICKDISP/) has_tick_display = 1

    if (uline ~ /TST\.B ESQDISP_STATUSREFRESHPENDINGFLAG/ ||
        uline ~ /MOVE\.B ESQDISP_STATUSREFRESHPENDINGFLAG\(A4\),D0/) has_status_pending_test = 1

    if (uline ~ /TST\.B GCOMMAND_HIGHLIGHTHOLDOFFTICKCOUNT/ ||
        uline ~ /MOVE\.B GCOMMAND_HIGHLIGHTHOLDOFFTICKCOU\(A4\),D0/) has_holdoff_test = 1

    if (uline ~ /CLR\.B ESQDISP_STATUSREFRESHPENDINGFLAG/ ||
        uline ~ /CLR\.B ESQDISP_STATUSREFRESHPENDINGFLAG\(A4\)/) has_status_clear = 1

    if (uline ~ /ESQDISP_REFRESHSTATUSINDICATORSFROMCURRENTMASK/ ||
        uline ~ /ESQDISP_REFRESHSTATUSINDICATORSF/) has_refresh_status = 1

    if (uline ~ /^RTS$/) has_return = 1

    prev_uline = uline
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROBE=" has_probe
    print "HAS_DISPLAY_CMP=" has_display_cmp
    print "HAS_POLL=" has_poll
    print "HAS_GRID_GATE=" has_grid_gate
    print "HAS_GRID=" has_grid
    print "HAS_ESC=" has_esc
    print "HAS_SERIAL_GATE=" has_serial_gate
    print "HAS_SERIAL=" has_serial
    print "HAS_ALERT_GATE=" has_alert_gate
    print "HAS_ALERTS=" has_alerts
    print "HAS_PERSIST_TEST=" has_persist_test
    print "HAS_PERSIST_CLEAR=" has_persist_clear
    print "HAS_COMMIT=" has_commit
    print "HAS_IFFTASK_GATE=" has_ifftask_gate
    print "HAS_GATE1_BTST=" has_gate1_btst
    print "HAS_GATE1_CLEAR=" has_gate1_clear
    print "HAS_RESET_REFRESH=" has_reset_refresh
    print "HAS_GATE0_BTST=" has_gate0_btst
    print "HAS_GATE0_CLEAR=" has_gate0_clear
    print "HAS_NEXT_FRAME=" has_next_frame
    print "HAS_LOGO_REF_TEST=" has_logo_ref_test
    print "HAS_CLEAR_LOGO_ASSET_FLAG=" has_clear_logo_asset_flag
    print "HAS_DIAG_CMP=" has_diag_cmp
    print "HAS_GADS_REF_TEST=" has_gads_ref_test
    print "HAS_CLEAR_GADS_ASSET_FLAG=" has_clear_gads_asset_flag
    print "HAS_WEATHER_LIST_TEST=" has_weather_list_test
    print "HAS_BANNER_RESOURCE_TEST=" has_banner_resource_test
    print "HAS_QUEUE_LOAD=" has_queue_load
    print "HAS_LOGO_COUNT_CMP=" has_logo_count_cmp
    print "HAS_SERVICE_ASSET0=" has_service_asset0
    print "HAS_GADS_COUNT_CMP=" has_gads_count_cmp
    print "HAS_SERVICE_ASSET1=" has_service_asset1
    print "HAS_TICK_DISPLAY=" has_tick_display
    print "HAS_STATUS_PENDING_TEST=" has_status_pending_test
    print "HAS_HOLDOFF_TEST=" has_holdoff_test
    print "HAS_STATUS_CLEAR=" has_status_clear
    print "HAS_REFRESH_STATUS=" has_refresh_status
    print "HAS_RETURN=" has_return
}
