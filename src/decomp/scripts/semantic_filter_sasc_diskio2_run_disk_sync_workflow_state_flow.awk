BEGIN {
    step_count = 0
    status_update_count = 0
    saving_label_count = 0
    status_call_count = 0
    done = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!(tag in seen)) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    if (done) {
        next
    }

    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^DISKIO2_RUNDISKSYNCWORKFLOW[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (uline ~ /ESQDISP_UPDATESTATUSMASKANDREFRE/ ||
        uline ~ /GROUP_AH_JMPTBL_ESQDISP_UPDATESTATUSMASKANDREFRE/) {
        status_update_count++
        if (status_update_count == 1) {
            mark("STATUS_BUSY_ON")
        } else if (status_update_count == 2) {
            mark("STATUS_BUSY_OFF")
        }
    }

    if (uline ~ /DISKIO2_STR_SAVING_/) {
        saving_label_count++
    }
    if (uline ~ /DISKIO2_DISPLAYSTATUSLINE/ || uline ~ /DISKIO2_SHOWSTATUSIFENABLED/) {
        status_call_count++
    }

    if (uline ~ /DISKIO2_FLUSHDATAFILESIFNEEDED/ ||
        uline ~ /DISKIO2_FLUSHDATAFILESIFNEE/) {
        mark("FLUSH_PROGRAMMING")
    }

    if (uline ~ /LADFUNC_SAVETEXTADSTOFILE/ || uline ~ /LADFUNC_SAVETEXTADSTO/) {
        mark("SAVE_TEXT_ADS")
    }

    if (uline ~ /DISKIO_SAVECONFIGTOFILEHANDLE/) {
        mark("SAVE_CONFIG")
    }

    if (uline ~ /LOCAVAIL_PRIMARYFILTERSTATE/) {
        mark("AVAIL_PRIMARY_STATE")
    }
    if (uline ~ /LOCAVAIL_SECONDARYFILTERSTATE/) {
        mark("AVAIL_SECONDARY_STATE")
    }
    if (uline ~ /LOCAVAIL_SAVEAVAILABILITYDATAFILE/ ||
        uline ~ /GROUP_AH_JMPTBL_LOCAVAIL_SAVEAVAILABILITYDATAFILE/ ||
        uline ~ /LOCAVAIL_SAVEAVAILABILITYDATAFIL/) {
        mark("SAVE_AVAIL")
    }

    if (uline ~ /DISKIO2_WRITEQTABLEINIFILE/) {
        mark("WRITE_QTABLE")
    }

    if (uline ~ /PARSEINI_WRITEERRORLOGENTRY/ ||
        uline ~ /GROUP_AK_JMPTBL_PARSEINI_WRITEERRORLOGENTRY/ ||
        uline ~ /PARSEINI_WRITEER/) {
        mark("WRITE_ERROR_LOG")
    }

    if (uline ~ /DST_BANNERWINDOWPRIMARY/) {
        mark("DST_PAIR")
    }
    if (uline ~ /DATETIME_SAVEPAIRTOFILE/) {
        mark("SAVE_DST")
    }

    if (uline ~ /P_TYPE_WRITEPROMOIDDATAFILE/ ||
        uline ~ /GROUP_AH_JMPTBL_P_TYPE_WRITEPROMOIDDATAFILE/ ||
        uline ~ /P_TYPE_WRITEPROM/) {
        mark("WRITE_PROMO")
    }

    if (uline ~ /GCOMMAND_LOADCOMMANDFILE/ || uline ~ /GROUP_AH_JMPTBL_GCOMMAND_LOADCOMMANDFILE/ ||
        uline ~ /GCOMMAND_LOADCOM/) {
        mark("LOAD_COMMAND")
    }
    if (uline ~ /GCOMMAND_LOADMPLEXFILE/ || uline ~ /GROUP_AH_JMPTBL_GCOMMAND_LOADMPLEXFILE/ ||
        uline ~ /GCOMMAND_LOADMPL/) {
        mark("LOAD_MPLEX")
    }
    if (uline ~ /GCOMMAND_LOADPPVTEMPLATE/ || uline ~ /GROUP_AH_JMPTBL_GCOMMAND_LOADPPVTEMPLATE/ ||
        uline ~ /GCOMMAND_LOADPPV/) {
        mark("LOAD_PPV")
    }

    if (uline == "RTS") {
        mark("RTS")
        done = 1
    }
}

END {
    print "STATUS_UPDATE_COUNT=" status_update_count
    print "SAVING_LABEL_COUNT=" saving_label_count
    print "STATUS_CALL_COUNT=" status_call_count
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
