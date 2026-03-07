BEGIN {
    has_entry=0
    has_task_gate=0
    has_mode_one=0
    has_diag_check=0
    has_drive1_check=0
    has_forbid=0
    has_permit=0
    has_free_gads=0
    has_open_gads=0
    has_size_gads=0
    has_alloc_gads=0
    has_read_gads=0
    has_close_gads=0
    has_flag_or1=0
    has_mode_zero=0
    has_drive0_check=0
    has_free_logo=0
    has_open_logo=0
    has_size_logo=0
    has_alloc_logo=0
    has_read_logo=0
    has_close_logo=0
    has_flag_or2=0
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

    if (u ~ /^ESQIFF_RELOADEXTERNALASSETCATALOGBUFFERS:/ || u ~ /^ESQIFF_RELOADEXTERNALASSETCATALO[A-Z0-9_]*:/) has_entry=1
    if (n ~ /CTASKSIFFTASKDONEFLAG/) has_task_gate=1
    if (u ~ /CMP\.L #\$1,D7/ || n ~ /CMPL1D7/) has_mode_one=1
    if (n ~ /EDDIAGGRAPHMODECHAR/ && (u ~ /#78/ || u ~ /'N'/ || u ~ /#\$4E/)) has_diag_check=1
    if (n ~ /DISKIODRIVEWRITEPROTECTSTATUSCODEDRIVE1/ || n ~ /DISKIODRIVEWRITEPROTECTSTATUSCO/) has_drive1_check=1
    if (n ~ /LVOFORBID/) has_forbid=1
    if (n ~ /LVOPERMIT/) has_permit=1
    if (n ~ /FREEBRUSHLIST/ && n ~ /GADS/) has_free_gads=1
    if (n ~ /OPENFILEWITHMODE/ && n ~ /GFXGADS/) has_open_gads=1
    if (n ~ /GETFILESIZEFROMHANDLE/ && n ~ /GFXGADSFILESIZE/) has_size_gads=1
    if (n ~ /ALLOCATEMEMORY/ && (u ~ /898/ || n ~ /ESQIFFC4/)) has_alloc_gads=1
    if (n ~ /LVOREAD/) has_read_gads=1
    if (n ~ /LVOCLOSE/) has_close_gads=1
    if (u ~ /ORI\.W #1/ || u ~ /ORI\.W #\$1/ || n ~ /ORIW1D0/) has_flag_or1=1
    if (n ~ /TSTLD7/ || n ~ /MODE/ && n ~ /D7/) has_mode_zero=1
    if (n ~ /DISKIODRIVE0WRITEPROTECTEDCODE/) has_drive0_check=1
    if (n ~ /FREEBRUSHLIST/ && n ~ /LOGO/) has_free_logo=1
    if (n ~ /OPENFILEWITHMODE/ && n ~ /DF0LOGOLST/) has_open_logo=1
    if (n ~ /GETFILESIZEFROMHANDLE/ && n ~ /DF0LOGOLSTFILESIZE/) has_size_logo=1
    if (n ~ /ALLOCATEMEMORY/ && (u ~ /979/ || n ~ /ESQIFFC6/)) has_alloc_logo=1
    if (n ~ /LVOREAD/ && n ~ /DF0LOGOLST/) has_read_logo=1
    if (n ~ /LVOCLOSE/ && n ~ /DF0LOGOLST/) has_close_logo=1
    if (u ~ /ORI\.W #2/ || u ~ /ORI\.W #\$2/ || n ~ /ORIW2D0/) has_flag_or2=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TASK_GATE=" has_task_gate
    print "HAS_MODE_ONE_CHECK=" has_mode_one
    print "HAS_DIAG_CHECK=" has_diag_check
    print "HAS_DRIVE1_CHECK=" has_drive1_check
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_FREE_GADS=" has_free_gads
    print "HAS_OPEN_GADS=" has_open_gads
    print "HAS_SIZE_GADS=" has_size_gads
    print "HAS_ALLOC_GADS=" has_alloc_gads
    print "HAS_READ_GADS=" has_read_gads
    print "HAS_CLOSE_GADS=" has_close_gads
    print "HAS_OR_FLAG_1=" has_flag_or1
    print "HAS_MODE_ZERO_CHECK=" has_mode_zero
    print "HAS_DRIVE0_CHECK=" has_drive0_check
    print "HAS_FREE_LOGO=" has_free_logo
    print "HAS_OPEN_LOGO=" has_open_logo
    print "HAS_SIZE_LOGO=" has_size_logo
    print "HAS_ALLOC_LOGO=" has_alloc_logo
    print "HAS_READ_LOGO=" has_read_logo
    print "HAS_CLOSE_LOGO=" has_close_logo
    print "HAS_OR_FLAG_2=" has_flag_or2
    print "HAS_RTS=" has_rts
}
