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
    render_call_count=0
    has_render_short_arg=0
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
    if (n ~ /MENUSTATEID/ && (u ~ /#\\$18/ || u ~ /#24/)) has_menu_state_18=1
    if (n ~ /SETAPEN/ || n ~ /RECTFILL/) has_set_apen_rectfill=1
    if (u ~ /#\\$AA/ || u ~ /#170/ || u ~ /#85/ || u ~ /#75/ || n ~ /APPLYRTCBYTESANDPERSIST/) has_clock_sync_scan=1
    if (n ~ /RENDERALIGNEDSTATUSSCREEN/ || n ~ /RENDERALIGNEDSTATUSSCREE/) render_call_count++
    if (u ~ /PEA \\(\\$1\\)\\.W/ || u ~ /PEA \\(1\\)\\.W/ || u ~ /PEA \\(\\$1\\)/) has_render_short_arg=1
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
    print "HAS_RENDER_SHORT=" (render_call_count >= 2 && has_render_short_arg)
    print "HAS_RENDER_FULL=" (render_call_count >= 2)
    print "HAS_RESTORE_STATE=" has_restore_state
    print "HAS_RTS=" has_rts
}
