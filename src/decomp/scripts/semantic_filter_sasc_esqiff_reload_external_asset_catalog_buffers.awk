BEGIN {
    has_entry = 0
    has_task_gate = 0
    has_mode_one_gate = 0
    has_diag_n_gate = 0
    has_drive1_gate = 0
    has_gads_reset = 0
    has_gads_dealloc = 0
    has_gads_zero = 0
    has_gads_open = 0
    has_gads_size_store = 0
    has_gads_alloc = 0
    has_gads_read_compare = 0
    has_gads_flag_or = 0
    has_gads_cursor_update = 0
    has_mode_zero_gate = 0
    has_drive0_gate = 0
    has_logo_reset = 0
    has_logo_dealloc = 0
    has_logo_zero = 0
    has_logo_open = 0
    has_logo_size_store = 0
    has_logo_alloc = 0
    has_logo_read_compare = 0
    has_logo_flag_or = 0
    has_rts = 0

    forbid_count = 0
    permit_count = 0
    read_count = 0
    close_count = 0

    saw_mode_one_const = 0
    saw_mode_d7_copy = 0
    saw_diag_char = 0
    saw_gads_data_test = 0
    saw_gads_size_test = 0
    saw_gads_dealloc_tag = 0
    saw_gads_open_path = 0
    saw_gads_size_call = 0
    saw_gads_alloc_tag = 0
    saw_gads_read = 0
    saw_logo_data_test = 0
    saw_logo_size_test = 0
    saw_logo_dealloc_tag = 0
    saw_logo_open_path = 0
    saw_logo_size_call = 0
    saw_logo_alloc_tag = 0
    saw_logo_read = 0
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQIFF_RELOADEXTERNALASSETCATALOGBUFFERS:/ ||
        u ~ /^ESQIFF_RELOADEXTERNALASSETCATALO[A-Z0-9_]*:/) has_entry = 1

    if (n ~ /CTASKSIFFTASKDONEFLAG/) has_task_gate = 1

    if (u ~ /MOVEQ #1,D0/ || u ~ /MOVEQ\.L #\$1,D0/ || u ~ /MOVEQ\.L #1,D0/) {
        saw_mode_one_const = 1
    }
    if (u ~ /MOVE\.L D7,D0/) {
        saw_mode_d7_copy = 1
    }
    if ((u ~ /CMP\.L D0,D7/ && saw_mode_one_const) ||
        (u ~ /SUBQ\.L #\$1,D0/ && saw_mode_d7_copy) ||
        n ~ /CMPLD0D7/ || n ~ /SUBQL1D0/) {
        has_mode_one_gate = 1
    }

    if (n ~ /EDDIAGGRAPHMODECHAR/) saw_diag_char = 1
    if ((saw_diag_char && (u ~ /MOVEQ #78,D1/ || u ~ /MOVEQ\.L #\$4E,D1/ || u ~ /CMP\.B D1,D0/)) ||
        (n ~ /EDDIAGGRAPHMODECHAR/ && (u ~ /'N'/ || u ~ /#78/ || u ~ /#\$4E/))) {
        has_diag_n_gate = 1
    }

    if (n ~ /DISKIODRIVEWRITEPROTECTSTATUSCODEDRIVE1/ ||
        n ~ /DISKIODRIVEWRITEPROTECTSTATUSCO/) has_drive1_gate = 1

    if (n ~ /LVOFORBID/) forbid_count++
    if (n ~ /LVOPERMIT/) permit_count++
    if (n ~ /LVOREAD/) read_count++
    if (n ~ /LVOCLOSE/) close_count++

    if (n ~ /FREEBRUSHLIST/ && n ~ /GADSBRUSHLISTHEAD/) has_gads_reset = 1
    if (n ~ /ESQIFFGADSBRUSHLISTCOUNT/) has_gads_reset = 1
    if (n ~ /ESQIFFGADSLISTLINEINDEX/ && (u ~ /CLR\.W/ || u ~ /MOVE\.W #\$1/ || u ~ /MOVE\.W #1/)) has_gads_reset = 1

    if ((n ~ /GLOBALREFLONGGFXGADSDATA/ && (u ~ /TST\.L/ || u ~ /MOVE\.L/)) ||
        n ~ /GLOBALREFLONGGFXGADSFILESI/) {
        if (n ~ /GLOBALREFLONGGFXGADSDATA/) saw_gads_data_test = 1
        if (n ~ /GLOBALREFLONGGFXGADSFILESI/ || n ~ /GLOBALREFLONGGFXGADSFILESIZE/) saw_gads_size_test = 1
    }
    if (u ~ /\$372/ || u ~ /882/ || n ~ /ESQIFFC3/) saw_gads_dealloc_tag = 1
    if ((saw_gads_dealloc_tag && n ~ /DEALLOCATEM/) ||
        (saw_gads_data_test && saw_gads_size_test && n ~ /DEALLOCATEM/)) {
        has_gads_dealloc = 1
    }

    if (n ~ /GLOBALREFLONGGFXGADSDATA/ && u ~ /CLR\.L/) has_gads_zero = 1
    if (n ~ /GLOBALREFLONGGFXGADSFILESI/ && u ~ /CLR\.L/) has_gads_zero = 1

    if (n ~ /GLOBALPTRSTRGFXGADS/) saw_gads_open_path = 1
    if (saw_gads_open_path && n ~ /OPENFILEWITHMODE/) has_gads_open = 1
    if (n ~ /GETFILESIZE/ || n ~ /GETFILESIZEFROMHANDLE/) saw_gads_size_call = 1
    if (saw_gads_size_call &&
        (n ~ /GLOBALREFLONGGFXGADSFILESI/ || n ~ /GLOBALREFLONGGFXGADSFILESIZE/)) {
        has_gads_size_store = 1
    }
    if (u ~ /\$382/ || u ~ /898/ || n ~ /ESQIFFC4/) saw_gads_alloc_tag = 1
    if (saw_gads_alloc_tag && n ~ /ALLOCATEMEM/) has_gads_alloc = 1

    if (n ~ /LVOREAD/) saw_gads_read = 1
    if (saw_gads_read &&
        u ~ /CMP\.L/ &&
        (n ~ /GLOBALREFLONGGFXGADSFILESI/ || n ~ /GLOBALREFLONGGFXGADSFILESIZE/ || n ~ /CMPLD5D0/)) {
        has_gads_read_compare = 1
    }
    if (u ~ /ORI\.W #1,D0/ || u ~ /ORI\.W #\$1,D0/) has_gads_flag_or = 1
    if (n ~ /SCRIPTCTRLINTERFACEENABLEDFLAG/ || (n ~ /ESQIFFGADSLISTLINEINDEX/ && u ~ /MOVE\.W #\$1/)) {
        has_gads_cursor_update = 1
    }

    if (u ~ /TST\.L D7/ || n ~ /TSTLD7/) has_mode_zero_gate = 1
    if (n ~ /DISKIODRIVE0WRITEPROTECTEDCODE/) has_drive0_gate = 1

    if (n ~ /FREEBRUSHLIST/ && n ~ /LOGOBRUSHLISTHEAD/) has_logo_reset = 1
    if (n ~ /ESQIFFLOGOBRUSHLISTCOUNT/) has_logo_reset = 1
    if (n ~ /ESQIFFLOGOLISTLINEINDEX/ && u ~ /CLR\.W/) has_logo_reset = 1

    if ((n ~ /GLOBALREFLONGDF0LOGOLSTDAT/ && (u ~ /TST\.L/ || u ~ /MOVE\.L/)) ||
        n ~ /GLOBALREFLONGDF0LOGOLSTFIL/) {
        if (n ~ /GLOBALREFLONGDF0LOGOLSTDAT/) saw_logo_data_test = 1
        if (n ~ /GLOBALREFLONGDF0LOGOLSTFIL/ || n ~ /GLOBALREFLONGDF0LOGOLSTFILESIZE/) saw_logo_size_test = 1
    }
    if (u ~ /\$3C3/ || u ~ /963/ || n ~ /ESQIFFC5/) saw_logo_dealloc_tag = 1
    if ((saw_logo_dealloc_tag && n ~ /DEALLOCATEM/) ||
        (saw_logo_data_test && saw_logo_size_test && n ~ /DEALLOCATEM/)) {
        has_logo_dealloc = 1
    }

    if (n ~ /GLOBALREFLONGDF0LOGOLSTDAT/ && u ~ /CLR\.L/) has_logo_zero = 1
    if (n ~ /GLOBALREFLONGDF0LOGOLSTFIL/ && u ~ /CLR\.L/) has_logo_zero = 1

    if (n ~ /GLOBALPTRSTRDF0LOGOLST/) saw_logo_open_path = 1
    if (saw_logo_open_path && n ~ /OPENFILEWITHMODE/) has_logo_open = 1
    if (n ~ /GETFILESIZE/ || n ~ /GETFILESIZEFROMHANDLE/) saw_logo_size_call = 1
    if (saw_logo_size_call &&
        (n ~ /GLOBALREFLONGDF0LOGOLSTFIL/ || n ~ /GLOBALREFLONGDF0LOGOLSTFILESIZE/)) {
        has_logo_size_store = 1
    }
    if (u ~ /\$3D3/ || u ~ /979/ || n ~ /ESQIFFC6/) saw_logo_alloc_tag = 1
    if (saw_logo_alloc_tag && n ~ /ALLOCATEMEM/) has_logo_alloc = 1

    if (n ~ /LVOREAD/) saw_logo_read = 1
    if (saw_logo_read &&
        u ~ /CMP\.L/ &&
        (n ~ /GLOBALREFLONGDF0LOGOLSTFIL/ || n ~ /GLOBALREFLONGDF0LOGOLSTFILESIZE/ || n ~ /CMPLD5D0/)) {
        has_logo_read_compare = 1
    }
    if (u ~ /ORI\.W #2,D0/ || u ~ /ORI\.W #\$2,D0/) has_logo_flag_or = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TASK_GATE=" has_task_gate
    print "HAS_MODE_ONE_GATE=" has_mode_one_gate
    print "HAS_DIAG_N_GATE=" has_diag_n_gate
    print "HAS_DRIVE1_GATE=" has_drive1_gate
    print "FORBID_COUNT=" forbid_count
    print "PERMIT_COUNT=" permit_count
    print "HAS_GADS_RESET=" has_gads_reset
    print "HAS_GADS_DEALLOC=" has_gads_dealloc
    print "HAS_GADS_ZERO=" has_gads_zero
    print "HAS_GADS_OPEN=" has_gads_open
    print "HAS_GADS_SIZE_STORE=" has_gads_size_store
    print "HAS_GADS_ALLOC=" has_gads_alloc
    print "HAS_GADS_READ_COMPARE=" has_gads_read_compare
    print "HAS_GADS_FLAG_OR=" has_gads_flag_or
    print "HAS_GADS_CURSOR_UPDATE=" has_gads_cursor_update
    print "HAS_MODE_ZERO_GATE=" has_mode_zero_gate
    print "HAS_DRIVE0_GATE=" has_drive0_gate
    print "HAS_LOGO_RESET=" has_logo_reset
    print "HAS_LOGO_DEALLOC=" has_logo_dealloc
    print "HAS_LOGO_ZERO=" has_logo_zero
    print "HAS_LOGO_OPEN=" has_logo_open
    print "HAS_LOGO_SIZE_STORE=" has_logo_size_store
    print "HAS_LOGO_ALLOC=" has_logo_alloc
    print "HAS_LOGO_READ_COMPARE=" has_logo_read_compare
    print "HAS_LOGO_FLAG_OR=" has_logo_flag_or
    print "READ_COUNT=" read_count
    print "CLOSE_COUNT=" close_count
    print "HAS_RTS=" has_rts
}
