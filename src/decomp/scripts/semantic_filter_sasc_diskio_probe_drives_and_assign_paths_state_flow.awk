BEGIN {
    has_entry = 0
    has_msgport_alloc = 0
    has_ioreq_alloc = 0
    has_four_drive_loop = 0
    has_clear_drive_status = 0
    has_open_device = 0
    has_open_fail_codes = 0
    has_writeprotect_cmd14 = 0
    has_writeprotect_error_gate = 0
    has_writeprotect_actual_gate = 0
    has_writeprotect_226 = 0
    has_media_cmd15 = 0
    has_media_error_gate = 0
    has_media_actual_gate = 0
    has_media_223 = 0
    has_close_device = 0
    has_free_ioreq = 0
    has_cleanup_msgport = 0
    has_ui_tick_gate = 0
    has_clear_probe_flag = 0
    has_dh2_pending_set = 0
    has_gfx_pending_set = 0
    has_dh2_gate = 0
    has_save_mode = 0
    has_set_readmode_100 = 0
    has_dh2_exec_fonts = 0
    has_dh2_exec_env = 0
    has_dh2_exec_sys = 0
    has_dh2_exec_s = 0
    has_dh2_exec_c = 0
    has_dh2_exec_l = 0
    has_dh2_exec_libs = 0
    has_dh2_exec_devs = 0
    has_restore_mode = 0
    has_clear_dh2_pending = 0
    has_gfx_gate = 0
    has_check_path = 0
    has_exec_gfx_df1 = 0
    has_exec_gfx_pc1 = 0
    has_clear_gfx_pending = 0
    has_const_14 = 0
    has_const_15 = 0
    has_const_218 = 0
    has_const_223 = 0
    has_const_226 = 0
    has_const_256 = 0
    has_rts = 0
}

function trim(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    u = trim($0)
    if (u == "") next
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^DISKIO_PROBEDRIVESANDASSIGNPATHS:/ || u ~ /^DISKIO_PROBEDRIVESANDASSIGNPAT[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /CREATEMSGPORTWITHSIGNAL/ || n ~ /GROUPAGJMPTBLSIGNALCREATEMSG/) has_msgport_alloc = 1
    if (n ~ /ALLOCWITHOWNER/ || n ~ /GROUPAGJMPTBLSTRUCTALLOCWITH/) has_ioreq_alloc = 1
    if (u ~ /MOVEQ(\.L)? #4,D0/ || u ~ /MOVEQ(\.L)? #\$4,D0/ || n ~ /CMPLD0D7/) has_four_drive_loop = 1
    if (n ~ /DISKIODRIVE0WRITEPROTECTEDCODE/ || n ~ /DISKIODRIVEMEDIASTATUSCODETABLE/) {
        if (n ~ /CLRL/ || n ~ /MOVEQ0D0/ || n ~ /MOVELD0/) has_clear_drive_status = 1
    }
    if (n ~ /LVOOPENDEVICE/ || (n ~ /DISKIOSTRTRACKDISKDEVICE/ && n ~ /ABSEXECBASE/)) has_open_device = 1
    if (u ~ /#218/ || u ~ /#\$DA/ || u ~ /#223/ || u ~ /#\$DF/) has_open_fail_codes = 1
    if (u ~ /MOVE\.W #14,28\(A0\)/ || u ~ /MOVE\.W #\$E,\$1C\(A0\)/) has_writeprotect_cmd14 = 1
    if (n ~ /TSTB31A0/ || n ~ /MOVEB1FA0D0/ || n ~ /IOERROR/) has_writeprotect_error_gate = 1
    if (n ~ /TSTL32A0/ || n ~ /TSTL20A0/ || n ~ /IOACTUAL/) has_writeprotect_actual_gate = 1
    if (n ~ /DISKIODRIVE0WRITEPROTECTEDCODE/ && (u ~ /#226/ || u ~ /#\$E2/)) has_writeprotect_226 = 1
    if (u ~ /MOVE\.W #15,28\(A0\)/ || u ~ /MOVE\.W #\$F,\$1C\(A0\)/) has_media_cmd15 = 1
    if ((n ~ /TSTB31A0/ || n ~ /MOVEB1FA0D0/ || n ~ /IOERROR/) && has_media_cmd15) has_media_error_gate = 1
    if ((n ~ /TSTL32A0/ || n ~ /TSTL20A0/ || n ~ /IOACTUAL/) && has_media_cmd15) has_media_actual_gate = 1
    if (n ~ /DISKIODRIVEMEDIASTATUSCODETABLE/ && (u ~ /#223/ || u ~ /#\$DF/ || n ~ /NOTBD0/)) has_media_223 = 1
    if (n ~ /LVOCLOSEDEVICE/) has_close_device = 1
    if (n ~ /FREEWITHSIZEFIELD/ || n ~ /GROUPAGJMPTBLSTRUCTFREEWITHS/) has_free_ioreq = 1
    if (n ~ /CLEANUPSIGNALANDMSGPORT/ || n ~ /GROUPAGJMPTBLIOSTDREQCLEANUP/) has_cleanup_msgport = 1
    if ((n ~ /ESQMAINLOOPUITICKENABLEDFLAG/ && n ~ /MOVEW/ ) || (n ~ /TSTWESQMAINLOOPUITICKENABLEDFLAG/) || (n ~ /ESQMAINLOOPUITICKENABLEDFLAG/ && n ~ /BEQ/)) has_ui_tick_gate = 1
    if (n ~ /CLRWGCOMMANDDRIVEPROBEREQUESTEDFLAG/ || (n ~ /GCOMMANDDRIVEPROBEREQUESTEDFLAG/ && u ~ /#0/)) has_clear_probe_flag = 1
    if (n ~ /DISKIODRIVE0DH2ASSIGNDONEFLAG/ && (u ~ /#1/ || u ~ /#\$1/ || n ~ /MOVELD0/ || n ~ /MOVELD1/)) has_dh2_pending_set = 1
    if (n ~ /DISKIODRIVE1GFXASSIGNDONEFLAG/ && (u ~ /#1/ || u ~ /#\$1/ || n ~ /MOVELD0/ || n ~ /MOVELD1/)) has_gfx_pending_set = 1
    if ((n ~ /TSTLDISKIODRIVE0DH2ASSIGNDONEFLAG/ || n ~ /DISKIODRIVE0DH2ASSIGNDONEFLAGA4D0/) || (n ~ /TSTLDISKIODRIVE0WRITEPROTECTEDCODE/)) has_dh2_gate = 1
    if (n ~ /MOVEWESQPARS2READMODEFLAGSD5/ || n ~ /MOVEWESQPARS2READMODEFLAGSA4D5/) has_save_mode = 1
    if (n ~ /ESQPARS2READMODEFLAGS/ && (u ~ /#\$100/ || u ~ /#256/)) has_set_readmode_100 = 1
    if (n ~ /DISKIOCMDASSIGNFONTSDH2/) has_dh2_exec_fonts = 1
    if (n ~ /DISKIOCMDASSIGNENVDH2/) has_dh2_exec_env = 1
    if (n ~ /DISKIOCMDASSIGNSYSDH2/) has_dh2_exec_sys = 1
    if (n ~ /DISKIOCMDASSIGNSDH2/) has_dh2_exec_s = 1
    if (n ~ /DISKIOCMDASSIGNCDH2/) has_dh2_exec_c = 1
    if (n ~ /DISKIOCMDASSIGNLDH2/) has_dh2_exec_l = 1
    if (n ~ /DISKIOCMDASSIGNLIBSDH2/) has_dh2_exec_libs = 1
    if (n ~ /DISKIOCMDASSIGNDEVSDH2/) has_dh2_exec_devs = 1
    if (n ~ /ESQPARS2READMODEFLAGS/ && (n ~ /MOVEWD5ESQPARS2READMODEFLAGS/ || n ~ /SAVEDREADMODEFLAGS/)) has_restore_mode = 1
    if (n ~ /CLRLDISKIODRIVE0DH2ASSIGNDONEFLAG/ || n ~ /MOVELD2DISKIODRIVE0DH2ASSIGNDONEFLAG/) has_clear_dh2_pending = 1
    if ((n ~ /TSTLDISKIODRIVE1GFXASSIGNDONEFLAG/ || n ~ /DISKIODRIVE1GFXASSIGNDONEFLAGA4D0/) || n ~ /DISKIODRIVEWRITEPROTECTSTATUSCODEDRIVE1/) has_gfx_gate = 1
    if (n ~ /CHECKPATHEXISTS/ || n ~ /GROUPAGJMPTBLSCRIPTCHECKPATH/ || n ~ /DISKIOPATHDF1GADS/) has_check_path = 1
    if (n ~ /DISKIOCMDASSIGNGFXDF1/) has_exec_gfx_df1 = 1
    if (n ~ /DISKIOCMDASSIGNGFXPC1/) has_exec_gfx_pc1 = 1
    if (n ~ /CLRLDISKIODRIVE1GFXASSIGNDONEFLAG/ || n ~ /MOVELD2DISKIODRIVE1GFXASSIGNDONEFLAG/) has_clear_gfx_pending = 1
    if (u ~ /#14([^0-9]|$)/ || u ~ /#\$E([^0-9A-F]|$)/) has_const_14 = 1
    if (u ~ /#15([^0-9]|$)/ || u ~ /#\$F([^0-9A-F]|$)/) has_const_15 = 1
    if (u ~ /#218([^0-9]|$)/ || u ~ /#\$DA([^0-9A-F]|$)/) has_const_218 = 1
    if (u ~ /#223([^0-9]|$)/ || u ~ /#\$DF([^0-9A-F]|$)/) has_const_223 = 1
    if (u ~ /#226([^0-9]|$)/ || u ~ /#\$E2([^0-9A-F]|$)/) has_const_226 = 1
    if (u ~ /#256([^0-9]|$)/ || u ~ /#\$100([^0-9A-F]|$)/) has_const_256 = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MSGPORT_ALLOC=" has_msgport_alloc
    print "HAS_IOREQ_ALLOC=" has_ioreq_alloc
    print "HAS_FOUR_DRIVE_LOOP=" has_four_drive_loop
    print "HAS_CLEAR_DRIVE_STATUS=" has_clear_drive_status
    print "HAS_OPEN_DEVICE=" has_open_device
    print "HAS_OPEN_FAIL_CODES=" has_open_fail_codes
    print "HAS_WRITEPROTECT_CMD14=" has_writeprotect_cmd14
    print "HAS_WRITEPROTECT_ERROR_GATE=" has_writeprotect_error_gate
    print "HAS_WRITEPROTECT_ACTUAL_GATE=" has_writeprotect_actual_gate
    print "HAS_WRITEPROTECT_226=" has_writeprotect_226
    print "HAS_MEDIA_CMD15=" has_media_cmd15
    print "HAS_MEDIA_ERROR_GATE=" has_media_error_gate
    print "HAS_MEDIA_ACTUAL_GATE=" has_media_actual_gate
    print "HAS_MEDIA_223=" has_media_223
    print "HAS_CLOSE_DEVICE=" has_close_device
    print "HAS_FREE_IOREQ=" has_free_ioreq
    print "HAS_CLEANUP_MSGPORT=" has_cleanup_msgport
    print "HAS_UI_TICK_GATE=" has_ui_tick_gate
    print "HAS_CLEAR_PROBE_FLAG=" has_clear_probe_flag
    print "HAS_DH2_PENDING_SET=" has_dh2_pending_set
    print "HAS_GFX_PENDING_SET=" has_gfx_pending_set
    print "HAS_DH2_GATE=" has_dh2_gate
    print "HAS_SAVE_MODE=" has_save_mode
    print "HAS_SET_READMODE_100=" has_set_readmode_100
    print "HAS_DH2_EXEC_FONTS=" has_dh2_exec_fonts
    print "HAS_DH2_EXEC_ENV=" has_dh2_exec_env
    print "HAS_DH2_EXEC_SYS=" has_dh2_exec_sys
    print "HAS_DH2_EXEC_S=" has_dh2_exec_s
    print "HAS_DH2_EXEC_C=" has_dh2_exec_c
    print "HAS_DH2_EXEC_L=" has_dh2_exec_l
    print "HAS_DH2_EXEC_LIBS=" has_dh2_exec_libs
    print "HAS_DH2_EXEC_DEVS=" has_dh2_exec_devs
    print "HAS_RESTORE_MODE=" has_restore_mode
    print "HAS_CLEAR_DH2_PENDING=" has_clear_dh2_pending
    print "HAS_GFX_GATE=" has_gfx_gate
    print "HAS_CHECK_PATH=" has_check_path
    print "HAS_EXEC_GFX_DF1=" has_exec_gfx_df1
    print "HAS_EXEC_GFX_PC1=" has_exec_gfx_pc1
    print "HAS_CLEAR_GFX_PENDING=" has_clear_gfx_pending
    print "HAS_CONST_14=" has_const_14
    print "HAS_CONST_15=" has_const_15
    print "HAS_CONST_218=" has_const_218
    print "HAS_CONST_223=" has_const_223
    print "HAS_CONST_226=" has_const_226
    print "HAS_CONST_256=" has_const_256
    print "HAS_RTS=" has_rts
}
