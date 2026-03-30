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
    has_clock_read_minlen=0
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
    has_refresh_save_byte=0
    has_refresh_mul_60=0
    has_disk_warning_gate_update=0
    has_accumulator_clear=0
    has_diag_overlay_not=0
    has_runtime_weather_dump=0
    has_debug_dump_bookends=0
    has_clock_file_read=0
    has_clock_file_close=0
    has_clock_scan_u=0
    has_clock_scan_aa=0
    has_clock_scan_k=0
    has_clock_apply=0
    ctrl_shadow_transition_call_count=0
    has_ctrl_shadow_transition_arg3=0
    has_ctrl_shadow_enable_arg1=0
    has_external_asset_frame_one=0
    has_disk_sync_zero=0
    has_move_copper_zero_31=0
    has_banner_transition_next=0
    has_banner_transition_prev=0
    has_banner_transition_config=0
    saw_arg_one=0
    saw_arg_three=0
    saw_arg_thirtyone=0
    saw_zero_push=0
    saw_banner_config_load=0
    saw_banner_next_step=0
    saw_banner_prev_step=0
    saw_transition_const_2=0
    saw_transition_const_3=0
    saw_status_overlay_format=0
    saw_status_overlay_sprintf=0
    saw_status_overlay_display=0
    weather_runtime_dump_count=0
    saw_refresh_mul_60_arg=0
    saw_clock_minlen_const=0
    saw_clock_minlen_cmp=0
    saw_debug_dump_entry_count=0
    saw_debug_dump_reset_tick=0
    saw_debug_dump_entry_ptr=0
    saw_debug_dump_dump_call=0
    saw_debug_dump_tick_call=0
    saw_debug_dump_start=0
    saw_debug_dump_end=0
    saw_disk_warning_tick=0
    saw_gate_flag_ref=0
    saw_gate_booleanize=0
    saw_diag_overlay_flag=0
    saw_not_byte=0
    saw_banner_datetime_ctime=0
    saw_banner_datetime_btime=0
    saw_banner_datetime_day_slot=0
    saw_banner_datetime_day_of_week=0
    saw_banner_datetime_formatter=0
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
    if (u ~ /#\$0?B/ || u ~ /#11/) saw_clock_minlen_const=1
    if (u ~ /^CMP\.L / || u ~ /^BLT/ || n ~ /READMINIMUMBYTES/) saw_clock_minlen_cmp=1
    if (saw_clock_minlen_const && saw_clock_minlen_cmp) has_clock_read_minlen=1
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
    if (u ~ /PEA \(\$1\)\.W/ || u ~ /PEA \(1\)\.W/ || u ~ /PEA 1\.W/) saw_arg_one=1
    if (u ~ /PEA \(\$3\)\.W/ || u ~ /PEA \(3\)\.W/ || u ~ /PEA 3\.W/ || u ~ /MOVEQ(\.L)? #\$?3,D[0-7]$/) saw_arg_three=1
    if (u ~ /PEA \(\$1F\)\.W/ || u ~ /PEA \(31\)\.W/ || u ~ /PEA 31\.W/ || u ~ /PEA \(\$1f\)\.W/) saw_arg_thirtyone=1
    if (u ~ /^CLR\.L -\(A7\)$/ || u ~ /^MOVEQ(\.L)? #\$?0,D0$/ || u ~ /^MOVE\.L D0,-\(A7\)$/) saw_zero_push=1
    if (n ~ /CONFIGBANNERCOPPERHEADBYTE/) saw_banner_config_load=1
    if (u ~ /ADDQ\.(W|L)? #\$?1,D0$/ || u ~ /ADDQ\.(W|L)? #1,D0$/) saw_banner_next_step=1
    if (u ~ /SUBQ\.(W|L)? #\$?1,D0$/ || u ~ /SUBQ\.(W|L)? #1,D0$/) saw_banner_prev_step=1
    if (n ~ /SCRIPTUPDATESERIALSHADOWFROMCTRLBYTE/ || n ~ /SCRIPTUPDATESERIALSHADOWFROMCTR/) {
        if (saw_arg_three || saw_zero_push) {
            ctrl_shadow_transition_call_count++
            has_ctrl_shadow_transition_arg3=1
        }
        if (saw_arg_one) has_ctrl_shadow_enable_arg1=1
    }
    if ((n ~ /ESQIFFPLAYNEXTEXTERNALASSETFRAME/ || n ~ /PLAYNEXTEXTERNALASSETFRAM/) && saw_arg_one) has_external_asset_frame_one=1
    if (n ~ /DISKIO2RUNDISKSYNCWORKFLOW/ && saw_zero_push) has_disk_sync_zero=1
    if (n ~ /ESQMOVECOPPERENTRYTOWARDEND/ && saw_arg_thirtyone && saw_zero_push) has_move_copper_zero_31=1
    if (n ~ /SCRIPTBEGINBANNERCHARTRANSITION/ && saw_banner_next_step) has_banner_transition_next=1
    if (n ~ /SCRIPTBEGINBANNERCHARTRANSITION/ && saw_banner_prev_step) has_banner_transition_prev=1
    if (n ~ /SCRIPTBEGINBANNERCHARTRANSITION/ && saw_banner_config_load) has_banner_transition_config=1
    if (u ~ /MOVEQ(\.L)? #\$?2,D[0-7]$/ || u ~ /PEA \(\$2\)\.W/ || u ~ /PEA \(2\)\.W/ || u ~ /PEA 2\.W/) saw_transition_const_2=1
    if (u ~ /MOVEQ(\.L)? #\$?3,D[0-7]$/ || u ~ /PEA \(\$3\)\.W/ || u ~ /PEA \(3\)\.W/ || u ~ /PEA 3\.W/) saw_transition_const_3=1
    if (n ~ /LOCAVAILFILTERPREVCLASSID/ && saw_transition_const_2) has_transition_class2=1
    if (n ~ /LOCAVAILFILTERPREVCLASSID/ && saw_transition_const_3) has_transition_class3=1
    if (n ~ /SCRIPTRUNTIMEMODE/ && (u ~ /^CLR\.W / || u ~ /^CLR\.L / || u ~ /^CLR.W / || u ~ /^CLR.L /)) has_runtimemode_clear=1
    if (n ~ /ED2FMTBITPLANE1PCT8LX/ || n ~ /ESQSHAREDBANNERROWSCRATCHRASTER/) saw_status_overlay_format=1
    if (n ~ /WDISPSPRINTF/) saw_status_overlay_sprintf=1
    if (n ~ /DISPLAYTEXTATPOSITION/) saw_status_overlay_display=1
    if (saw_status_overlay_format && saw_status_overlay_sprintf && saw_status_overlay_display) has_status_overlay_dump=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /ED2FMTCLUPOS1PCTLDCURCLUPCTSJDCLU1/) saw_debug_dump_entry_count=1
    if (n ~ /ESQGLOBALTICKCOUNTER/) saw_debug_dump_reset_tick=1
    if (n ~ /TEXTDISPPRIMARYENTRYPTRTABLE/) saw_debug_dump_entry_ptr=1
    if (n ~ /DUMPPROGRAMSOURCERECORDV/) saw_debug_dump_dump_call=1
    if (n ~ /SERVICEUITICKIFRUNNING/) saw_debug_dump_tick_call=1
    if (saw_debug_dump_entry_count && saw_debug_dump_reset_tick && saw_debug_dump_entry_ptr && saw_debug_dump_dump_call && saw_debug_dump_tick_call) has_debug_dump_loop=1
    if (n ~ /ED2STRCTIME/) saw_banner_datetime_ctime=1
    if (n ~ /ED2STRBTIME/) saw_banner_datetime_btime=1
    if (n ~ /CLOCKDAYSLOTINDEX/) saw_banner_datetime_day_slot=1
    if (n ~ /CLOCKCURRENTDAYOFWEEKINDEX/) saw_banner_datetime_day_of_week=1
    if (n ~ /DSTFORMATBANNERDATETIME/) saw_banner_datetime_formatter++
    if (saw_banner_datetime_ctime && saw_banner_datetime_btime && saw_banner_datetime_day_slot && saw_banner_datetime_day_of_week && saw_banner_datetime_formatter >= 2) has_banner_datetime_pair=1
    if (n ~ /RENDERALIGNEDSTATUSSCREEN/ || n ~ /RENDERALIGNEDSTATUSSCREE/) render_call_count++
    if (u ~ /PEA \(\$1\)\.W/ || u ~ /PEA \(1\)\.W/ || u ~ /PEA \(\$1\)/ || u ~ /PEA \$1\.W/ || u ~ /PEA 1\.W/) has_render_short_arg=1
    if (u ~ /^CLR\.L -\(A7\)$/ || u ~ /^MOVEQ(\.L)? #\$?0,D0$/ || u ~ /^CLR\.L \(A7\)$/ || u ~ /^MOVE\.L D0,-\(A7\)$/) has_render_zero_arg=1
    if (n ~ /EDSAVEDCTASKSINTERVALBYTE/) has_refresh_save_byte=1
    if (u ~ /#\$3C/ || u ~ /#60/) saw_refresh_mul_60_arg=1
    if (saw_refresh_mul_60_arg && n ~ /MULU32/) has_refresh_mul_60=1
    if (n ~ /ESQFUNCUPDATEDISKWARNINGANDREFR/) saw_disk_warning_tick=1
    if (n ~ /PARSEINICTRLHCHANGEGATEFLAG/) saw_gate_flag_ref=1
    if (n ~ /TESTWORDISZEROBOOLEANIZE/) saw_gate_booleanize=1
    if (saw_disk_warning_tick && saw_gate_flag_ref && saw_gate_booleanize) has_disk_warning_gate_update=1
    if (n ~ /ACCUMULATORCAPTUREACTIVE/) has_accumulator_clear=1
    if (n ~ /DIAGOVERLAYAUTOREFRESHFL/) saw_diag_overlay_flag=1
    if (n ~ /NOTB/ || u ~ /^NOT\.B /) saw_not_byte=1
    if (saw_diag_overlay_flag && saw_not_byte) has_diag_overlay_not=1
    if (n ~ /FMTWICONPCTLD/ || n ~ /FMTWMINPCTLDMINUTES/ || n ~ /FMTWDCNTEVERYPCTLDTIMESPCTLD/ || n ~ /FMTCWCNTPCTLDTIMESFROMNOWPCTLD/ || n ~ /FMTWDATAPCT08LX/ || n ~ /FMTWCITYPCTS/ || n ~ /FMTWEATHERIDPCTS/ || n ~ /FMTCWCOLORPCTLD/ || n ~ /FMTBANNERFORWEATHERPCTD/) weather_runtime_dump_count++
    if (weather_runtime_dump_count >= 9) has_runtime_weather_dump=1
    if (n ~ /EDDOTCCOLONSHORTDUM/) saw_debug_dump_start=1
    if (n ~ /EDDOTCCOLONENDOFDU/) saw_debug_dump_end=1
    if (saw_debug_dump_start && saw_debug_dump_end) has_debug_dump_bookends=1
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
    print "HAS_CLOCK_READ_MINLEN=" has_clock_read_minlen
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
    print "HAS_REFRESH_SAVE_BYTE=" has_refresh_save_byte
    print "HAS_REFRESH_MUL_60=" has_refresh_mul_60
    print "HAS_DISK_WARNING_GATE_UPDATE=" has_disk_warning_gate_update
    print "HAS_ACCUMULATOR_CLEAR=" has_accumulator_clear
    print "HAS_DIAG_OVERLAY_NOT=" has_diag_overlay_not
    print "HAS_RUNTIME_WEATHER_DUMP=" has_runtime_weather_dump
    print "HAS_DEBUG_DUMP_BOOKENDS=" has_debug_dump_bookends
    print "HAS_CLOCK_FILE_READ=" has_clock_file_read
    print "HAS_CLOCK_FILE_CLOSE=" has_clock_file_close
    print "HAS_CLOCK_SCAN_U=" has_clock_scan_u
    print "HAS_CLOCK_SCAN_AA=" has_clock_scan_aa
    print "HAS_CLOCK_SCAN_K=" has_clock_scan_k
    print "HAS_CLOCK_APPLY=" has_clock_apply
    print "HAS_CTRL_SHADOW_TRANSITION_ARG3=" (has_ctrl_shadow_transition_arg3 && ctrl_shadow_transition_call_count >= 2)
    print "HAS_CTRL_SHADOW_ENABLE_ARG1=" has_ctrl_shadow_enable_arg1
    print "HAS_EXTERNAL_ASSET_FRAME_ONE=" has_external_asset_frame_one
    print "HAS_DISK_SYNC_ZERO=" has_disk_sync_zero
    print "HAS_MOVE_COPPER_ZERO_31=" has_move_copper_zero_31
    print "HAS_BANNER_TRANSITION_NEXT=" has_banner_transition_next
    print "HAS_BANNER_TRANSITION_PREV=" has_banner_transition_prev
    print "HAS_BANNER_TRANSITION_CONFIG=" has_banner_transition_config
    print "HAS_RENDER_SHORT=" (render_call_count >= 2 && has_render_short_arg)
    print "HAS_RENDER_FULL=" (render_call_count >= 2 && has_render_zero_arg)
    print "HAS_RESTORE_STATE=" has_restore_state
    print "HAS_RTS=" has_rts
}
