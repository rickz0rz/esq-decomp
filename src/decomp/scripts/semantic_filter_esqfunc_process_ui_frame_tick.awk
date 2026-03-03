BEGIN {
    has_entry = 0
    has_probe = 0
    has_poll = 0
    has_grid = 0
    has_serial = 0
    has_alerts = 0
    has_commit = 0
    has_reset_refresh = 0
    has_next_frame = 0
    has_queue_load = 0
    has_service_asset = 0
    has_tick_display = 0
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
    if (uline ~ /ESQFUNC_JMPTBL_DISKIO_PROBEDRIVESANDASSIGNPATHS/) has_probe = 1
    if (uline ~ /ESQDISP_POLLINPUTMODEANDREFRESHSELECTION/) has_poll = 1
    if (uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDLE/) has_grid = 1
    if (uline ~ /ESQFUNC_JMPTBL_SCRIPT_HANDLESERIALCTRLCMD/) has_serial = 1
    if (uline ~ /ESQFUNC_JMPTBL_CLEANUP_PROCESSALERTS/) has_alerts = 1
    if (uline ~ /ESQFUNC_COMMITSECONDARYSTATEANDPERSIST/) has_commit = 1
    if (uline ~ /ESQFUNC_JMPTBL_TEXTDISP_RESETSELECTIONANDREFRESH/) has_reset_refresh = 1
    if (uline ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAME/) has_next_frame = 1
    if (uline ~ /ESQIFF_QUEUEIFFBRUSHLOAD/) has_queue_load = 1
    if (uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/) has_service_asset = 1
    if (uline ~ /ESQFUNC_JMPTBL_TEXTDISP_TICKDISPLAYSTATE/) has_tick_display = 1
    if (uline ~ /ESQDISP_REFRESHSTATUSINDICATORSFROMCURRENTMASK/) has_refresh_status = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROBE=" has_probe
    print "HAS_POLL=" has_poll
    print "HAS_GRID=" has_grid
    print "HAS_SERIAL=" has_serial
    print "HAS_ALERTS=" has_alerts
    print "HAS_COMMIT=" has_commit
    print "HAS_RESET_REFRESH=" has_reset_refresh
    print "HAS_NEXT_FRAME=" has_next_frame
    print "HAS_QUEUE_LOAD=" has_queue_load
    print "HAS_SERVICE_ASSET=" has_service_asset
    print "HAS_TICK_DISPLAY=" has_tick_display
    print "HAS_REFRESH_STATUS=" has_refresh_status
    print "HAS_RETURN=" has_return
}
