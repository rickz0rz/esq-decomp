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
    if (n ~ /SUBQW/ || n ~ /SUBQL/ || n ~ /BEQW/) has_dispatch=1
    if (n ~ /DRAWSTATUSLINE1/ || n ~ /DRAWSTATUSLINE2/ || n ~ /STATEINDEX/) has_status_line_actions=1
    if (n ~ /DRAWENTRYSUMMARYPANEL/ || n ~ /DRAWENTRYDETAILSPANEL/ || n ~ /SELECTEDFLAGBYTEOFFSET/ || n ~ /SELECTEDENTRYINDEX/) has_summary_detail_actions=1
    if (n ~ /WEATHERSTATUSCOUNTDOWN/ || n ~ /WEATHERSTATUSDIGITCHAR/ || n ~ /WEATHERSTATUSBRUSHINDEX/) has_weather_reset=1
    if (n ~ /REFRESHINTERVALMINUTES/ || n ~ /REFRESHINTERVALSECONDS/) has_refresh_toggle=1
    if (n ~ /BEGINBANNER/ || n ~ /GETBANNERCHAR/ || n ~ /GETBANN/) has_banner_transition=1
    if (n ~ /BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /INITRASTPORT2PENS/ || n ~ /STATUSREFRESHHOLDFLAG/) has_display_rebuild=1
    if (n ~ /OPENFILEWITHMODE/ || n ~ /LVOREAD/ || n ~ /LVOCLOSE/ || n ~ /APPLYRTCBYTESANDPERSIST/) has_clockcmd_read=1
    if (n ~ /DRAWESCMENUHELPTEXT/ || n ~ /DRAWESCMENUBOTTOMHELP/ || n ~ /RESTOREDISPLAYSTATE/) has_restore_state=1
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
    print "HAS_RESTORE_STATE=" has_restore_state
    print "HAS_RTS=" has_rts
}
