BEGIN {
    has_entry = 0
    has_status_update = 0
    has_display = 0
    has_flush = 0
    has_save_ads = 0
    has_save_config = 0
    has_save_avail = 0
    has_write_qtable = 0
    has_write_error = 0
    has_save_dst = 0
    has_write_promo = 0
    has_load_cmd = 0
    has_load_mplex = 0
    has_load_ppv = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /ESQDISP_UPDATESTATUSMASKANDREFRESH/ || line ~ /ESQDISP_UPDATEST/) has_status_update = 1
    if (line ~ /DISKIO2_DISPLAYSTATUSLINE/) has_display = 1
    if (line ~ /DISKIO2_FLUSHDATAFILESIFNEEDED/ || line ~ /DISKIO2_FLUSHDATAFILESIFNEE/) has_flush = 1
    if (line ~ /LADFUNC_SAVETEXTADSTOFILE/ || line ~ /LADFUNC_SAVETEXTADSTO/) has_save_ads = 1
    if (line ~ /DISKIO_SAVECONFIGTOFILEHANDLE/) has_save_config = 1
    if (line ~ /LOCAVAIL_SAVEAVAILABILITYDATAFILE/ || line ~ /LOCAVAIL_SAVEAVA/) has_save_avail = 1
    if (line ~ /DISKIO2_WRITEQTABLEINIFILE/) has_write_qtable = 1
    if (line ~ /PARSEINI_WRITEERRORLOGENTRY/ || line ~ /PARSEINI_WRITEER/) has_write_error = 1
    if (line ~ /DATETIME_SAVEPAIRTOFILE/) has_save_dst = 1
    if (line ~ /P_TYPE_WRITEPROMOIDDATAFILE/ || line ~ /P_TYPE_WRITEPROM/) has_write_promo = 1
    if (line ~ /GCOMMAND_LOADCOMMANDFILE/ || line ~ /GCOMMAND_LOADCOM/) has_load_cmd = 1
    if (line ~ /GCOMMAND_LOADMPLEXFILE/ || line ~ /GCOMMAND_LOADMPL/) has_load_mplex = 1
    if (line ~ /GCOMMAND_LOADPPVTEMPLATE/ || line ~ /GCOMMAND_LOADPPV/) has_load_ppv = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATUS_UPDATE=" has_status_update
    print "HAS_DISPLAY=" has_display
    print "HAS_FLUSH=" has_flush
    print "HAS_SAVE_ADS=" has_save_ads
    print "HAS_SAVE_CONFIG=" has_save_config
    print "HAS_SAVE_AVAIL=" has_save_avail
    print "HAS_WRITE_QTABLE=" has_write_qtable
    print "HAS_WRITE_ERROR=" has_write_error
    print "HAS_SAVE_DST=" has_save_dst
    print "HAS_WRITE_PROMO=" has_write_promo
    print "HAS_LOAD_CMD=" has_load_cmd
    print "HAS_LOAD_MPLEX=" has_load_mplex
    print "HAS_LOAD_PPV=" has_load_ppv
}
