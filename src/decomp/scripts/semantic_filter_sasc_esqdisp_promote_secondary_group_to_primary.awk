BEGIN {
    has_entry = 0
    has_clear_mode1 = 0
    has_refresh_flag = 0
    has_group_mutation_reset = 0
    saw_secondary_present = 0
    saw_secondary_subq = 0
    saw_move_secondary_entry = 0
    saw_move_primary_entry = 0
    saw_move_secondary_title = 0
    saw_move_primary_title = 0
    saw_move_copy = 0
    saw_move_clear = 0
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

    if (uline ~ /^ESQDISP_PROMOTESECONDARYGROUPTOPRIMARY:/ || uline ~ /^ESQDISP_PROMOTESECONDARYGROUPTO[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS/ || uline ~ /ESQPARS_REMOVEGROUPENTRYANDRELEA/) has_clear_mode1 = 1
    if (uline ~ /MOVE\.L D0,NEWGRID_REFRESHSTATEFLAG/ || uline ~ /MOVE\.L #\$1,NEWGRID_REFRESHSTATEFLAG/ || uline ~ /MOVE\.L D[0-7],NEWGRID_REFRESHSTATEF/) has_refresh_flag = 1
    if (uline ~ /MOVE\.W D0,TEXTDISP_GROUPMUTATIONSTATE/ || uline ~ /CLR\.W TEXTDISP_GROUPMUTATIONSTATE/) has_group_mutation_reset = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPPRESENTFLAG,D1/ || uline ~ /TEXTDISP_SECONDARYGROUPPRESENTFL/) saw_secondary_present = 1
    if (uline ~ /SUBQ\.B #1,D1/ || uline ~ /SUBQ\.B #\$1,D1/ || uline ~ /SUBQ\.B #1,D0/ || uline ~ /SUBQ\.B #\$1,D0/) saw_secondary_subq = 1
    if (uline ~ /^\.LOOP_MOVE_SECONDARY_SLOTS:$/ || uline ~ /LOOP_MOVE_SECONDARY_SLOTS/) has_move_loop = 1
    if (uline ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/) saw_move_secondary_entry = 1
    if (uline ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) saw_move_primary_entry = 1
    if (uline ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/) saw_move_secondary_title = 1
    if (uline ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/) saw_move_primary_title = 1
    if (uline ~ /MOVE\.L \$0\(A0,D0\.L\),\$0\(A1,D0\.L\)/ || uline ~ /MOVE\.L \$0\(A1,D0\.L\),\$0\(A2,D0\.L\)/) saw_move_copy = 1
    if (uline ~ /CLR\.L \$0\(A0,D0\.L\)/ || uline ~ /CLR\.L \$0\(A1,D0\.L\)/) saw_move_clear = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT,TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOU/ && uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN/ && uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/) saw_copy_count = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPRECORDCHECKSUM,TEXTDISP_PRIMARYGROUPRECORDCHECKSUM/ || uline ~ /TEXTDISP_SECONDARYGROUPRECORDCH/ && uline ~ /TEXTDISP_PRIMARYGROUPRECORDCHECKSUM/ || uline ~ /TEXTDISP_SECONDARYGROUPRECORDCHE/ && uline ~ /TEXTDISP_PRIMARYGROUPRECORDCHECK/) saw_copy_checksum = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPHEADERCODE,TEXTDISP_PRIMARYGROUPHEADERCODE/ || uline ~ /TEXTDISP_SECONDARYGROUPHEADERCO/ && uline ~ /TEXTDISP_PRIMARYGROUPHEADERCODE/ || uline ~ /TEXTDISP_SECONDARYGROUPHEADERCOD/ && uline ~ /TEXTDISP_PRIMARYGROUPHEADERCODE/) saw_copy_header = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPRECORDLENGTH,TEXTDISP_PRIMARYGROUPRECORDLENGTH/ || uline ~ /TEXTDISP_SECONDARYGROUPRECORDLE/ && uline ~ /TEXTDISP_PRIMARYGROUPRECORDLENGTH/ || uline ~ /TEXTDISP_SECONDARYGROUPRECORDLEN/ && uline ~ /TEXTDISP_PRIMARYGROUPRECORDLENGT/) saw_copy_length = 1
    if (uline ~ /MOVE\.W D0,TEXTDISP_SECONDARYGROUPENTRYCOUNT/ || uline ~ /CLR\.W TEXTDISP_SECONDARYGROUPENTRYCOUNT/ || uline ~ /CLR\.W TEXTDISP_SECONDARYGROUPENTRYCOUN/) saw_clear_secondary_count = 1
    if (uline ~ /MOVE\.B D1,TEXTDISP_SECONDARYGROUPRECORDCHECKSUM/ || uline ~ /CLR\.B TEXTDISP_SECONDARYGROUPRECORDCHECKSUM/ || uline ~ /CLR\.B TEXTDISP_SECONDARYGROUPRECORDCHE/) saw_clear_secondary_checksum = 1
    if (uline ~ /MOVE\.W D0,TEXTDISP_SECONDARYGROUPRECORDLENGTH/ || uline ~ /CLR\.W TEXTDISP_SECONDARYGROUPRECORDLENGTH/ || uline ~ /CLR\.W TEXTDISP_SECONDARYGROUPRECORDLEN/) saw_clear_secondary_length = 1
    if (uline ~ /MOVE\.B D1,TEXTDISP_SECONDARYGROUPPRESENTFLAG/ || uline ~ /CLR\.B TEXTDISP_SECONDARYGROUPPRESENTFLAG/ || uline ~ /CLR\.B TEXTDISP_SECONDARYGROUPPRESENTFL/) saw_clear_secondary_present = 1
    if (uline ~ /MOVE\.W #3,TEXTDISP_GROUPMUTATIONSTATE/ || uline ~ /MOVE\.W #\$3,TEXTDISP_GROUPMUTATIONSTATE/) has_group_mutation_promote = 1
    if (uline ~ /CTASKS_PENDINGSECONDARYOIDISKID,CTASKS_PENDINGPRIMARYOIDISKID/ || uline ~ /CTASKS_PENDINGSECONDARYOIDISK/ && uline ~ /CTASKS_PENDINGPRIMARYOIDISKID/) saw_task_sync_disk = 1
    if (uline ~ /CTASKS_SECONDARYOIWRITEPENDINGFLAG,CTASKS_PRIMARYOIWRITEPENDINGFLAG/ || uline ~ /CTASKS_SECONDARYOIWRITEPENDI/ && uline ~ /CTASKS_PRIMARYOIWRITEPENDINGFLAG/) saw_task_sync_write = 1
    if (uline ~ /ESQPARS_JMPTBL_NEWGRID_REBUILDINDEXCACHE/ || uline ~ /ESQPARS_JMPTBL_NEWGRID_REBUILDIND/ || uline ~ /ESQPARS_JMPTBL_NEWGRID_REBUILDIN/ || uline ~ /NEWGRID_REBUILDINDEXCACHE/ || uline ~ /NEWGRID_REBUILDINDEXCACH/ || uline ~ /NEWGRID_REBUILDINDEXCA/) has_reindex_call = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_secondary_present_check = (saw_secondary_present && saw_secondary_subq) ? 1 : 0
    if (!has_move_loop && ((saw_move_secondary_entry && saw_move_primary_entry) || (saw_move_secondary_title && saw_move_primary_title)) && saw_move_copy && saw_move_clear) has_move_loop = 1
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
