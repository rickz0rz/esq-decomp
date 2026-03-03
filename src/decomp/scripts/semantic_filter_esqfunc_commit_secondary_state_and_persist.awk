BEGIN {
    has_entry = 0
    has_set_mode = 0
    has_reinit = 0
    has_rebuild_filter = 0
    has_promote_secondary = 0
    has_flush = 0
    has_save_ads = 0
    has_save_avail = 0
    has_save_pair = 0
    has_write_promo = 0
    has_refresh = 0
    has_stack_fixup = 0
    has_restore_mode = 0
    has_restore_d7 = 0
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

    if (uline ~ /^ESQFUNC_COMMITSECONDARYSTATEANDPERSIST:/) has_entry = 1
    if (uline ~ /^MOVE\.W #\$100,ESQPARS2_READMODEFLAGS$/) has_set_mode = 1
    if (uline ~ /^MOVE\.W #1,ESQDISP_PENDINGGRIDREINITFLAG$/) has_reinit = 1
    if (uline ~ /ESQFUNC_JMPTBL_LOCAVAIL_REBUILDFILTERSTATEFROMCURRENTGROUP/) has_rebuild_filter = 1
    if (uline ~ /ESQFUNC_JMPTBL_P_TYPE_PROMOTESECONDARYLIST/) has_promote_secondary = 1
    if (uline ~ /ESQPARS_JMPTBL_DISKIO2_FLUSHDATAFILESIFNEEDED/) has_flush = 1
    if (uline ~ /ESQPARS_JMPTBL_LADFUNC_SAVETEXTADSTOFILE/) has_save_ads = 1
    if (uline ~ /ESQPARS_JMPTBL_LOCAVAIL_SAVEAVAILABILITYDATAFILE/) has_save_avail = 1
    if (uline ~ /DATETIME_SAVEPAIRTOFILE/) has_save_pair = 1
    if (uline ~ /ESQPARS_JMPTBL_P_TYPE_WRITEPROMOIDDATAFILE/) has_write_promo = 1
    if (uline ~ /ESQFUNC_UPDATEDISKWARNINGANDREFRESHTICK/) has_refresh = 1
    if (uline ~ /^LEA 12\(A7\),A7$/) has_stack_fixup = 1
    if (uline ~ /^MOVE\.W D7,ESQPARS2_READMODEFLAGS$/) has_restore_mode = 1
    if (uline ~ /^MOVE\.L \(A7\)\+,D7$/) has_restore_d7 = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SET_MODE=" has_set_mode
    print "HAS_REINIT=" has_reinit
    print "HAS_REBUILD_FILTER=" has_rebuild_filter
    print "HAS_PROMOTE_SECONDARY=" has_promote_secondary
    print "HAS_FLUSH=" has_flush
    print "HAS_SAVE_ADS=" has_save_ads
    print "HAS_SAVE_AVAIL=" has_save_avail
    print "HAS_SAVE_PAIR=" has_save_pair
    print "HAS_WRITE_PROMO=" has_write_promo
    print "HAS_REFRESH=" has_refresh
    print "HAS_STACK_FIXUP=" has_stack_fixup
    print "HAS_RESTORE_MODE=" has_restore_mode
    print "HAS_RESTORE_D7=" has_restore_d7
    print "HAS_RETURN=" has_return
}
