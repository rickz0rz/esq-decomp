BEGIN {
    has_entry=0
    has_state_ring_key=0
    has_dispatch=0
    has_status_line_actions=0
    has_summary_detail_actions=0
    has_weather_reset=0
    has_refresh_toggle=0
    has_banner_transition=0
    has_display_rebuild=0
    has_clockcmd_read=0
    has_aux_actions=0
    has_debug_dump=0
    has_banner_fallback_toggle=0
    has_banner_datetime_dump=0
    has_diag_overlay_toggle=0
    has_shutdown_request=0
    has_menu_state_18=0
    has_set_apen_rectfill=0
    has_clock_sync_scan=0
    has_readmode_0200=0
    has_readmode_0100=0
    has_readmode_clear=0
    has_runtimemode_clear=0
    has_viewmode_cycle=0
    has_transition_class2=0
    has_transition_class3=0
    has_status_overlay_dump=0
    has_debug_dump_loop=0
    has_banner_datetime_pair=0
    has_clock_file_read=0
    has_clock_file_close=0
    has_clock_scan_u=0
    has_clock_scan_aa=0
    has_clock_scan_k=0
    has_clock_apply=0
    render_call_count=0
    has_render_short_arg=0
    has_render_zero_arg=0
    has_restore_state=0
    has_rts=0
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

    if (u ~ /^ED2_HANDLEMENUACTIONS:/ || u ~ /^ED2_HANDLEMENUACTION[A-Z0-9_]*:/) has_entry=1
    if (n ~ /STATERINGINDEX/ && n ~ /STATERINGTABLE/ || n ~ /LASTKEYCODE/) has_state_ring_key=1
    if (n ~ /SUBQW/ || n ~ /SUBQL/ || n ~ /BEQW/ || n ~ /SWITCHED2HANDLEMENUACTIONS/) has_dispatch=1
    if (n ~ /DRAWSTATUSLINE1/ || n ~ /DRAWSTATUSLINE2/ || n ~ /STATEINDEX/) has_status_line_actions=1
    if (n ~ /DRAWENTRYSUMMARYPANEL/ || n ~ /DRAWENTRYDETAILSPANEL/ || n ~ /SELECTEDFLAGBYTEOFFSET/ || n ~ /SELECTEDENTRYINDEX/) has_summary_detail_actions=1
    if (n ~ /WEATHERSTATUSCOUNTDOWN/ || n ~ /WEATHERSTATUSDIGITCHAR/ || n ~ /WEATHERSTATUSBRUSHINDEX/) has_weather_reset=1
    if (n ~ /REFRESHINTERVALMINUTES/ || n ~ /REFRESHINTERVALSECONDS/) has_refresh_toggle=1
    if (n ~ /BEGINBANNER/ || n ~ /GETBANNERCHAR/ || n ~ /GETBANN/) has_banner_transition=1
    if (n ~ /BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /INITRASTPORT2PENS/ || n ~ /STATUSREFRESHHOLDFLAG/ || n ~ /DRAWVIEWMODEGUIDES/) has_display_rebuild=1
    if (n ~ /OPENFILEWITHMODE/ || n ~ /LVOREAD/ || n ~ /LVOCLOSE/ || n ~ /APPLYRTCBYTESANDPERSIST/) has_clockcmd_read=1
    if (n ~ /RELOADDATAFILESANDREBUILDINDEX/ || n ~ /PARSEINIBUFFERANDDISPATCH/ || n ~ /SCANLOGODIRECTORY/ || n ~ /RENDERALIGNEDSTATUSSCREEN/ || n ~ /WAITFORFLAGANDCLEARBIT/ || n ~ /COPYGFXTOWORKIFAVAILABLE/ || n ~ /SETCOPPEREFFECTCUSTOM/ || n ~ /MOVECOPPERENTRYTOWARDEND/ || n ~ /SHUTDOWNREQUESTEDFLAG/) has_aux_actions=1
    if (n ~ /RAWDOFMTWITHSCRATCHBUFFER/ || n ~ /DUMPPROGRAMSOURCERECORDVERBOSE/ || n ~ /FORMATBANNERDATETIME/ || n ~ /BANNERROWFALLBACKONFIRSTROWFLAG/) has_debug_dump=1
    if (n ~ /BANNERROWFALLBACKONFIRSTROWFLAG/ || n ~ /BANNERROWFALLBACKONFIRS/) has_banner_fallback_toggle=1
    if (n ~ /DSTFORMATBANNERDATETIME/ || n ~ /CLOCKDAYSLOTINDEX/ || n ~ /CLOCKCURRENTDAYOFWEEKINDEX/) has_banner_datetime_dump=1
    if (n ~ /DIAGOVERLAYAUTOREFRESHFLAG/ || n ~ /DIAGOVERLAYAUTOREFRESHFL/) has_diag_overlay_toggle=1
    if (n ~ /SHUTDOWNREQUESTEDFLAG/) has_shutdown_request=1
    if (n ~ /MENUSTATEID/ && (u ~ /#\$18/ || u ~ /#24/ || u ~ /MOVEB #\$18/ || u ~ /MOVEB #24/)) has_menu_state_18=1
    if (n ~ /SETAPEN/ || n ~ /RECTFILL/) has_set_apen_rectfill=1
    if (u ~ /#\$AA/ || u ~ /#170/ || u ~ /#\$55/ || u ~ /#85/ || u ~ /#\$4B/ || u ~ /#75/ || n ~ /APPLYRTCBYTESANDPERSIST/) has_clock_sync_scan=1
    if (n ~ /READMODEFLAGS/ && (u ~ /#\$200/ || u ~ /#512/)) has_readmode_0200=1
    if (n ~ /READMODEFLAGS/ && (u ~ /#\$100/ || u ~ /#256/)) has_readmode_0100=1
    if (n ~ /READMODEFLAGS/ && (u ~ /^CLR(W|L)? / || u ~ /CLR.W ESQPARS2_READMODEFLAGS/ || u ~ /CLR.L ESQPARS2_READMODEFLAGS/)) has_readmode_clear=1
    if (n ~ /SCRIPTRUNTIMEMODE/ && (u ~ /^CLR(W|L)? / || u ~ /CLR.W SCRIPTRUNTIMEMODE/ || u ~ /CLR.L SCRIPTRUNTIMEMODE/)) has_runtimemode_clear=1
    if (n ~ /SELECTNEXTVIEWMODE/) has_viewmode_cycle=1
    if (n ~ /LOCAVAILFILTERPREVCLASSID/ && (u ~ /#2/ || u ~ /MOVEQ #2/)) has_transition_class2=1
    if (n ~ /LOCAVAILFILTERPREVCLASSID/ && (u ~ /#3/ || u ~ /MOVEQ #3/)) has_transition_class3=1
    if (n ~ /WDISPSPRINTF/ && n ~ /DISPLAYTEXTATPOSITION/ || n ~ /BITPLANE1PCT8LX/ && n ~ /BANNERROWSCRATCHRASTERBASE0/) has_status_overlay_dump=1
    if (n ~ /DUMPPROGRAMSOURCERECORDVERBOSE/ && n ~ /SERVICEUITICKIFRUNNING/ || n ~ /PRIMARYGROUPENTRYCOUNT/ && n ~ /PRIMARYGROUPENTRYPTRTABLE/ && n ~ /PRIMARYTITLEPTRTABLE/) has_debug_dump_loop=1
    if (n ~ /DSTFORMATBANNERDATETIME/ && n ~ /ED2STRCTIME/ && n ~ /ED2STRBTIME/ && n ~ /CLOCKDAYSLOTINDEX/ && n ~ /CLOCKCURRENTDAYOFWEEKINDEX/) has_banner_datetime_pair=1
    if (n ~ /OPENFILEWITHMODE/) has_clock_file_read=1
    if (n ~ /LVOREAD/) has_clock_file_read=1
    if (n ~ /LVOCLOSE/) has_clock_file_close=1
    if (u ~ /#\$55/ || u ~ /#85/ || n ~ /STATEWAITU/) has_clock_scan_u=1
    if (u ~ /#\$AA/ || u ~ /#170/ || n ~ /STATEWAITAA/ || u ~ /ADD.L D2,D2/) has_clock_scan_aa=1
    if (u ~ /#\$4B/ || u ~ /#75/ || n ~ /STATEWAITK/) has_clock_scan_k=1
    if (n ~ /APPLYRTCBYTESANDPERSIST/ || n ~ /STATEPROCESSMATCH/) has_clock_apply=1
    if (n ~ /RENDERALIGNEDSTATUSSCREEN/ || n ~ /RENDERALIGNEDSTATUSSCREE/) render_call_count++
    if (u ~ /PEA \(\$1\)\.W/ || u ~ /PEA \(1\)\.W/ || u ~ /PEA \(\$1\)/ || u ~ /PEA \$1\.W/ || u ~ /PEA 1\.W/) has_render_short_arg=1
    if (u ~ /^CLR\.L -\(A7\)$/ || u ~ /^MOVEQ(\.L)? #\$?0,D0$/ || u ~ /^CLR\.L \(A7\)$/ || u ~ /^MOVE\.L D0,-\(A7\)$/) has_render_zero_arg=1
    if (n ~ /SETAPEN/ || n ~ /SETDRMD/ || n ~ /SETBPEN/ || n ~ /GLOBALREF696400BITMAP/) has_restore_state=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATE_RING_KEY=" has_state_ring_key
    print "HAS_DISPATCH=" has_dispatch
    print "HAS_STATUS_LINE_ACTIONS=" has_status_line_actions
    print "HAS_SUMMARY_DETAIL_ACTIONS=" has_summary_detail_actions
    print "HAS_WEATHER_RESET=" has_weather_reset
    print "HAS_REFRESH_TOGGLE=" has_refresh_toggle
    print "HAS_BANNER_TRANSITION=" has_banner_transition
    print "HAS_DISPLAY_REBUILD=" has_display_rebuild
    print "HAS_CLOCKCMD_READ=" has_clockcmd_read
    print "HAS_AUX_ACTIONS=" has_aux_actions
    print "HAS_DEBUG_DUMP=" has_debug_dump
    print "HAS_BANNER_FALLBACK_TOGGLE=" has_banner_fallback_toggle
    print "HAS_BANNER_DATETIME_DUMP=" has_banner_datetime_dump
    print "HAS_DIAG_OVERLAY_TOGGLE=" has_diag_overlay_toggle
    print "HAS_SHUTDOWN_REQUEST=" has_shutdown_request
    print "HAS_MENU_STATE_18=" has_menu_state_18
    print "HAS_COLOR_BARS=" has_set_apen_rectfill
    print "HAS_CLOCK_SYNC_SCAN=" has_clock_sync_scan
    print "HAS_READMODE_0200=" has_readmode_0200
    print "HAS_READMODE_0100=" has_readmode_0100
    print "HAS_READMODE_CLEAR=" has_readmode_clear
    print "HAS_RUNTIME_MODE_CLEAR=" has_runtimemode_clear
    print "HAS_VIEWMODE_CYCLE=" has_viewmode_cycle
    print "HAS_TRANSITION_CLASS2=" has_transition_class2
    print "HAS_TRANSITION_CLASS3=" has_transition_class3
    print "HAS_STATUS_OVERLAY_DUMP=" has_status_overlay_dump
    print "HAS_DEBUG_DUMP_LOOP=" has_debug_dump_loop
    print "HAS_BANNER_DATETIME_PAIR=" has_banner_datetime_pair
    print "HAS_CLOCK_FILE_READ=" has_clock_file_read
    print "HAS_CLOCK_FILE_CLOSE=" has_clock_file_close
    print "HAS_CLOCK_SCAN_U=" has_clock_scan_u
    print "HAS_CLOCK_SCAN_AA=" has_clock_scan_aa
    print "HAS_CLOCK_SCAN_K=" has_clock_scan_k
    print "HAS_CLOCK_APPLY=" has_clock_apply
    print "HAS_RENDER_SHORT=" (render_call_count >= 2 && has_render_short_arg)
    print "HAS_RENDER_FULL=" (render_call_count >= 2 && has_render_zero_arg)
    print "HAS_RESTORE_STATE=" has_restore_state
    print "HAS_RTS=" has_rts
}
