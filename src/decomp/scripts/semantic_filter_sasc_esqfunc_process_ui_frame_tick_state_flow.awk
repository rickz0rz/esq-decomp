BEGIN {
    step_count = 0
    prev = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (seen[tag] != 1) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^ESQFUNC_PROCESSUIFRAMETICK[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /DISKIO_PROBEDRIVESANDASSIGNPATHS/ ||
        u ~ /ESQFUNC_JMPTBL_DISKIO_PROBEDRIVE/) {
        mark("DRIVE_PROBE")
    }

    if (u ~ /ESQDISP_POLLINPUTMODEANDREFRESHSELECTION/ ||
        u ~ /ESQDISP_POLLINPUTMODEANDREFRESHS/) {
        mark("DISPLAY_POLL")
    }

    if (u ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDLE/ ||
        u ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDL/) {
        mark("GRID_IDLE")
    }

    if (u ~ /ED_DISPATCHESCMENUSTATE/) {
        mark("ESC_DISPATCH")
    }

    if (u ~ /SCRIPT_HANDLESERIALCTRLCMD/ ||
        u ~ /ESQFUNC_JMPTBL_SCRIPT_HANDLESERI/) {
        mark("SERIAL_CTRL")
    }

    if (u ~ /CLEANUP_PROCESSALERTS/ ||
        u ~ /ESQFUNC_JMPTBL_CLEANUP_PROCESSAL/) {
        mark("PROCESS_ALERTS")
    }

    if (u ~ /CLR\.L ESQDISP_SECONDARYPERSISTREQUESTF/ ||
        u ~ /CLR\.L ESQDISP_SECONDARYPERSISTREQUESTFLAG/) {
        mark("CLEAR_PERSIST_REQUEST")
    }

    if (u ~ /ESQFUNC_COMMITSECONDARYSTATEANDPERSIST/ ||
        u ~ /ESQFUNC_COMMITSECONDARYSTATEANDP/) {
        mark("COMMIT_PERSIST")
    }

    if (u ~ /CTASKS_IFFTASKDONEFLAG/) {
        mark("IFF_DONE_GATE")
    }

    if (u ~ /BTST #\$?1,ESQFUNC_IFFTASKGATEFLAGS/ ||
        u ~ /BTST #\$?1,D0/) {
        mark("GATE1_TEST")
    }

    if ((u ~ /BCLR #\$?1,ESQFUNC_IFFTASKGATEFLAGS/ ||
         u ~ /MOVE\.B D1,ESQFUNC_IFFTASKGATEFLAGS\(A4\)/) &&
        seen["GATE1_TEST"] && !seen["GATE1_CLEAR"]) {
        mark("GATE1_CLEAR")
    }

    if (u ~ /TEXTDISP_RESETSELECTIONANDREFRESH/ ||
        u ~ /TEXTDISP_RESETSELECTIONANDREFRES/) {
        mark("RESET_REFRESH")
    }

    if ((u ~ /^BTST / && u ~ /#\$?0/ && u ~ /ESQFUNC_IFFTASKGATEFLAGS/) ||
        (u ~ /^BTST / && u ~ /#\$?0/ && u ~ /,D0$/)) {
        mark("GATE0_TEST")
    }

    if ((u ~ /BCLR #\$?0,ESQFUNC_IFFTASKGATEFLAGS/ ||
         u ~ /MOVE\.B D1,ESQFUNC_IFFTASKGATEFLAGS\(A4\)/) &&
        seen["GATE0_TEST"] && !seen["GATE0_CLEAR"]) {
        mark("GATE0_CLEAR")
    }

    if ((u ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAME/ ||
         u ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAM/) &&
        (prev ~ /^PEA (1|\(\$1\))\.[Ww]$/ || prev ~ /^PEA #?\$?1$/)) {
        if (!seen["GATE0_TEST"]) {
            mark("GATE0_TEST")
        }
        mark("PLAY_NEXT_FRAME")
    }

    if (u ~ /ANDI\.[WL] #\$FFFD,D[01]/) {
        mark("CLEAR_LOGO_FLAG")
    }

    if (u ~ /ANDI\.[WL] #\$FFFE,D[01]/) {
        mark("CLEAR_GADS_FLAG")
    }

    if (u ~ /ESQIFF_QUEUEIFFBRUSHLOAD/) {
        mark("QUEUE_BRUSH_LOAD")
    }

    if ((u ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/ ||
         u ~ /ESQIFF_SERVICEEXTERNALASSETSOURC/) &&
        prev ~ /^CLR\.L -\(A7\)$/) {
        mark("SERVICE_ASSET0")
    }

    if ((u ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/ ||
         u ~ /ESQIFF_SERVICEEXTERNALASSETSOURC/) &&
        (prev ~ /^PEA (1|\(\$1\))\.[Ww]$/ || prev ~ /^PEA #?\$?1$/)) {
        mark("SERVICE_ASSET1")
    }

    if (u ~ /TEXTDISP_TICKDISPLAYSTATE/ ||
        u ~ /ESQFUNC_JMPTBL_TEXTDISP_TICKDISP/) {
        mark("TICK_DISPLAY")
    }

    if (u ~ /ESQDISP_STATUSREFRESHPENDINGFLAG/) {
        mark("STATUS_PENDING_GATE")
    }

    if (u ~ /GCOMMAND_HIGHLIGHTHOLDOFFTICKCOU/ ||
        u ~ /GCOMMAND_HIGHLIGHTHOLDOFFTICKCOUNT/) {
        mark("HOLDOFF_GATE")
    }

    if (u ~ /ESQDISP_REFRESHSTATUSINDICATORSFROMCURRENTMASK/ ||
        u ~ /ESQDISP_REFRESHSTATUSINDICATORSF/) {
        mark("REFRESH_STATUS")
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev = u
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
