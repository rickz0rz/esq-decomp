BEGIN {
    has_entry = 0
    has_clear_mode1 = 0
    has_refresh_flag = 0
    has_group_mutation_reset = 0
    saw_secondary_present = 0
    saw_secondary_subq = 0
    has_move_loop = 0
    saw_copy_count = 0
    saw_copy_checksum = 0
    saw_copy_header = 0
    saw_copy_length = 0
    saw_clear_secondary_count = 0
    saw_clear_secondary_checksum = 0
    saw_clear_secondary_length = 0
    saw_clear_secondary_present = 0
    has_group_mutation_promote = 0
    saw_task_sync_disk = 0
    saw_task_sync_write = 0
    has_reindex_call = 0
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

    if (uline ~ /^ESQDISP_PROMOTESECONDARYGROUPTOPRIMARY:/) has_entry = 1
    if (uline ~ /ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS/) has_clear_mode1 = 1
    if (uline ~ /MOVE\.L D0,NEWGRID_REFRESHSTATEFLAG/) has_refresh_flag = 1
    if (uline ~ /MOVE\.W D0,TEXTDISP_GROUPMUTATIONSTATE/) has_group_mutation_reset = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPPRESENTFLAG,D1/) saw_secondary_present = 1
    if (uline ~ /SUBQ\.B #1,D1/) saw_secondary_subq = 1
    if (uline ~ /^\.LOOP_MOVE_SECONDARY_SLOTS:/ || uline ~ /LOOP_MOVE_SECONDARY_SLOTS/) has_move_loop = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT,TEXTDISP_PRIMARYGROUPENTRYCOUNT/) saw_copy_count = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPRECORDCHECKSUM,TEXTDISP_PRIMARYGROUPRECORDCHECKSUM/) saw_copy_checksum = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPHEADERCODE,TEXTDISP_PRIMARYGROUPHEADERCODE/) saw_copy_header = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPRECORDLENGTH,TEXTDISP_PRIMARYGROUPRECORDLENGTH/) saw_copy_length = 1
    if (uline ~ /MOVE\.W D0,TEXTDISP_SECONDARYGROUPENTRYCOUNT/) saw_clear_secondary_count = 1
    if (uline ~ /MOVE\.B D1,TEXTDISP_SECONDARYGROUPRECORDCHECKSUM/) saw_clear_secondary_checksum = 1
    if (uline ~ /MOVE\.W D0,TEXTDISP_SECONDARYGROUPRECORDLENGTH/) saw_clear_secondary_length = 1
    if (uline ~ /MOVE\.B D1,TEXTDISP_SECONDARYGROUPPRESENTFLAG/) saw_clear_secondary_present = 1
    if (uline ~ /MOVE\.W #3,TEXTDISP_GROUPMUTATIONSTATE/) has_group_mutation_promote = 1
    if (uline ~ /CTASKS_PENDINGSECONDARYOIDISKID,CTASKS_PENDINGPRIMARYOIDISKID/) saw_task_sync_disk = 1
    if (uline ~ /CTASKS_SECONDARYOIWRITEPENDINGFLAG,CTASKS_PRIMARYOIWRITEPENDINGFLAG/) saw_task_sync_write = 1
    if (uline ~ /ESQPARS_JMPTBL_NEWGRID_REBUILDINDEXCACHE/) has_reindex_call = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_secondary_present_check = (saw_secondary_present && saw_secondary_subq) ? 1 : 0
    has_copy_metadata = (saw_copy_count && saw_copy_checksum && saw_copy_header && saw_copy_length) ? 1 : 0
    has_secondary_clears = (saw_clear_secondary_count && saw_clear_secondary_checksum && saw_clear_secondary_length && saw_clear_secondary_present) ? 1 : 0
    has_task_sync = (saw_task_sync_disk && saw_task_sync_write) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_CLEAR_MODE1=" has_clear_mode1
    print "HAS_REFRESH_FLAG=" has_refresh_flag
    print "HAS_GROUP_MUTATION_RESET=" has_group_mutation_reset
    print "HAS_SECONDARY_PRESENT_CHECK=" has_secondary_present_check
    print "HAS_MOVE_LOOP=" has_move_loop
    print "HAS_COPY_METADATA=" has_copy_metadata
    print "HAS_SECONDARY_CLEARS=" has_secondary_clears
    print "HAS_GROUP_MUTATION_PROMOTE=" has_group_mutation_promote
    print "HAS_TASK_SYNC=" has_task_sync
    print "HAS_REINDEX_CALL=" has_reindex_call
    print "HAS_RETURN=" has_return
}
