BEGIN {
    has_entry = 0
    msgport_calls = 0
    alloc_calls = 0
    open_device_calls = 0
    doio_calls = 0
    close_device_calls = 0
    free_calls = 0
    cleanup_calls = 0
    check_path_calls = 0
    execute_calls = 0
    has_cmd14 = 0
    has_cmd15 = 0
    has_trackdisk_msgport_ref = 0
    has_trackdisk_ioreq_ref = 0
    has_drive0_assign_flag_ref = 0
    has_drive1_assign_flag_ref = 0
    has_drive0_status_ref = 0
    has_drive1_status_ref = 0
    has_media_status_ref = 0
    has_probe_request_ref = 0
    has_readmode_ref = 0
    has_df1_path_ref = 0
    has_assign_fonts = 0
    has_assign_env = 0
    has_assign_sys = 0
    has_assign_s = 0
    has_assign_c = 0
    has_assign_l = 0
    has_assign_libs = 0
    has_assign_devs = 0
    has_assign_gfx_df1 = 0
    has_assign_gfx_pc1 = 0
    has_rts = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^DISKIO_PROBEDRIVESANDASSIGNPATHS:/ || l ~ /^DISKIO_PROBEDRIVESANDASSIGNPAT/) has_entry = 1
    if ((index(l, "SIGNAL_CREATEMSGPORTWITHSIGNAL") > 0 || index(l, "GROUP_AG_JMPTBL_SIGNAL_CREATEMSG") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) msgport_calls++
    if ((index(l, "STRUCT_ALLOCWITHOWNER") > 0 || index(l, "GROUP_AG_JMPTBL_STRUCT_ALLOCW") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) alloc_calls++
    if (index(l, "_LVOOPENDEVICE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) open_device_calls++
    if (index(l, "_LVODOIO") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) doio_calls++
    if (index(l, "_LVOCLOSEDEVICE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) close_device_calls++
    if ((index(l, "STRUCT_FREEWITHSIZEFIELD") > 0 || index(l, "GROUP_AG_JMPTBL_STRUCT_FREEW") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) free_calls++
    if ((index(l, "IOSTDREQ_CLEANUPSIGNALANDMSGPORT") > 0 || index(l, "GROUP_AG_JMPTBL_IOSTDREQ_CLEANUP") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) cleanup_calls++
    if ((index(l, "SCRIPT_CHECKPATHEXISTS") > 0 || index(l, "GROUP_AG_JMPTBL_SCRIPT_CHECKPATH") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) check_path_calls++
    if (index(l, "_LVOEXECUTE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) execute_calls++
    if (l ~ /MOVE\.W #\$?E[, ]/ || l ~ /MOVE\.W #14[, ]/) has_cmd14 = 1
    if (l ~ /MOVE\.W #\$?F[, ]/ || l ~ /MOVE\.W #15[, ]/) has_cmd15 = 1
    if (index(l, "DISKIO_TRACKDISKMSGPORTPTR") > 0) has_trackdisk_msgport_ref = 1
    if (index(l, "DISKIO_TRACKDISKIOREQPTR") > 0) has_trackdisk_ioreq_ref = 1
    if (index(l, "DISKIO_DRIVE0DH2ASSIGNDONEFLAG") > 0) has_drive0_assign_flag_ref = 1
    if (index(l, "DISKIO_DRIVE1GFXASSIGNDONEFLAG") > 0) has_drive1_assign_flag_ref = 1
    if (index(l, "DISKIO_DRIVE0WRITEPROTECTEDCODE") > 0) has_drive0_status_ref = 1
    if (index(l, "DISKIO_DRIVEWRITEPROTECTSTATUSCODEDRIVE1") > 0 || index(l, "DISKIO_DRIVEWRITEPROTECTSTATUSCO") > 0) has_drive1_status_ref = 1
    if (index(l, "DISKIO_DRIVEMEDIASTATUSCODETABLE") > 0) has_media_status_ref = 1
    if (index(l, "GCOMMAND_DRIVEPROBEREQUESTEDFLAG") > 0) has_probe_request_ref = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0) has_readmode_ref = 1
    if (index(l, "DISKIO_PATH_DF1_G_ADS") > 0) has_df1_path_ref = 1
    if (index(l, "DISKIO_CMD_ASSIGN_FONTS_DH2") > 0) has_assign_fonts = 1
    if (index(l, "DISKIO_CMD_ASSIGN_ENV_DH2") > 0) has_assign_env = 1
    if (index(l, "DISKIO_CMD_ASSIGN_SYS_DH2") > 0) has_assign_sys = 1
    if (index(l, "DISKIO_CMD_ASSIGN_S_DH2") > 0) has_assign_s = 1
    if (index(l, "DISKIO_CMD_ASSIGN_C_DH2") > 0) has_assign_c = 1
    if (index(l, "DISKIO_CMD_ASSIGN_L_DH2") > 0) has_assign_l = 1
    if (index(l, "DISKIO_CMD_ASSIGN_LIBS_DH2") > 0) has_assign_libs = 1
    if (index(l, "DISKIO_CMD_ASSIGN_DEVS_DH2") > 0) has_assign_devs = 1
    if (index(l, "DISKIO_CMD_ASSIGN_GFX_DF1") > 0) has_assign_gfx_df1 = 1
    if (index(l, "DISKIO_CMD_ASSIGN_GFX_PC1") > 0) has_assign_gfx_pc1 = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "MSGPORT_CALLS=" msgport_calls
    print "ALLOC_CALLS=" alloc_calls
    print "OPEN_DEVICE_CALLS=" open_device_calls
    print "DOIO_CALLS=" doio_calls
    print "CLOSE_DEVICE_CALLS=" close_device_calls
    print "FREE_CALLS=" free_calls
    print "CLEANUP_CALLS=" cleanup_calls
    print "CHECK_PATH_CALLS=" check_path_calls
    print "EXECUTE_CALLS=" execute_calls
    print "HAS_CMD14=" has_cmd14
    print "HAS_CMD15=" has_cmd15
    print "HAS_TRACKDISK_MSGPORT_REF=" has_trackdisk_msgport_ref
    print "HAS_TRACKDISK_IOREQ_REF=" has_trackdisk_ioreq_ref
    print "HAS_DRIVE0_ASSIGN_FLAG_REF=" has_drive0_assign_flag_ref
    print "HAS_DRIVE1_ASSIGN_FLAG_REF=" has_drive1_assign_flag_ref
    print "HAS_DRIVE0_STATUS_REF=" has_drive0_status_ref
    print "HAS_DRIVE1_STATUS_REF=" has_drive1_status_ref
    print "HAS_MEDIA_STATUS_REF=" has_media_status_ref
    print "HAS_PROBE_REQUEST_REF=" has_probe_request_ref
    print "HAS_READMODE_REF=" has_readmode_ref
    print "HAS_DF1_PATH_REF=" has_df1_path_ref
    print "HAS_ASSIGN_FONTS=" has_assign_fonts
    print "HAS_ASSIGN_ENV=" has_assign_env
    print "HAS_ASSIGN_SYS=" has_assign_sys
    print "HAS_ASSIGN_S=" has_assign_s
    print "HAS_ASSIGN_C=" has_assign_c
    print "HAS_ASSIGN_L=" has_assign_l
    print "HAS_ASSIGN_LIBS=" has_assign_libs
    print "HAS_ASSIGN_DEVS=" has_assign_devs
    print "HAS_ASSIGN_GFX_DF1=" has_assign_gfx_df1
    print "HAS_ASSIGN_GFX_PC1=" has_assign_gfx_pc1
    print "HAS_RTS=" has_rts
}
