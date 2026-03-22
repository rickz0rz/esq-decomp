BEGIN {
    has_entry = 0
    has_primary_group_gate = 0
    has_secondary_group_gate = 0
    has_token_01 = 0
    has_token_11 = 0
    has_token_12 = 0
    has_token_14 = 0
    has_return_branch = 0
    validate_call_count = 0
    create_entry_count = 0
    remove_group_count = 0
    refresh_flag_write_count = 0
    tail_clear_count = 0
    pad_call_count = 0
    apply_config_count = 0
    rebuild_count = 0
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
    if (u ~ /^XREF / || u ~ /^XDEF / || u == "END" || u == "__CONST:") next

    if (u ~ /^ESQIFF2_PARSEGROUPRECORDANDREFRESH:/ || u ~ /^ESQIFF2_PARSEGROUPRECORDANDREF[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_PRIMARYGROUPCODE") > 0) has_primary_group_gate = 1
    if (index(u, "TEXTDISP_SECONDARYGROUPCODE") > 0) has_secondary_group_gate = 1
    if (u ~ /^CMPI\.[WL] #\$1,D[0-7]$/ || u ~ /^CMPI\.[WL] #1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^CASE 0X01$/ || index(u, "HANDLE_TOKEN_0X01") > 0) has_token_01 = 1
    if (u ~ /^CMPI\.[WL] #\$11,D[0-7]$/ || u ~ /^CMPI\.[WL] #17,D[0-7]$/ || u ~ /^MOVEQ\.L #\$10,D[0-7]$/ || u ~ /^MOVEQ\.L #16,D[0-7]$/ || u ~ /^SUBI\.[WL] #16,D[0-7]$/ || u ~ /^CASE 0X11$/ || index(u, "HANDLE_TOKEN_0X11") > 0) has_token_11 = 1
    if (u ~ /^CMPI\.[WL] #\$12,D[0-7]$/ || u ~ /^CMPI\.[WL] #18,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^CASE 0X12$/ || index(u, "HANDLE_TOKEN_0X12") > 0) has_token_12 = 1
    if (u ~ /^CMPI\.[WL] #\$14,D[0-7]$/ || u ~ /^CMPI\.[WL] #20,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$2,D[0-7]$/ || u ~ /^SUBQ\.[WL] #2,D[0-7]$/ || u ~ /^CASE 0X14$/ || index(u, "HANDLE_TOKEN_0X14") > 0) has_token_14 = 1
    if (index(u, "ESQIFF2_VALIDATEFIELDINDEXANDLENGTH") > 0 || index(u, "VALIDATEFIELDINDEXANDLENGTH") > 0 || index(u, "VALIDATEFIELDINDEXANDLEN") > 0) validate_call_count++
    if (index(u, "ESQSHARED_CREATEGROUPENTRYANDTITLE") > 0 || index(u, "CREATEGROUPENTRYANDTITLE") > 0 || index(u, "CREATEGROUPENTRYANDTIT") > 0) create_entry_count++
    if (index(u, "REMOVEGROUPENTRYANDRELEASESTRINGS") > 0 || index(u, "REMOVEGROUPENTRYANDRELEA") > 0) remove_group_count++
    if (index(u, "NEWGRID_REFRESHSTATEFLAG") > 0) refresh_flag_write_count++
    if (index(u, "ESQIFF_PARSEFIELD0TAILBUFFER") > 0 || index(u, "ESQIFF_PARSEFIELD1TAILBYTE") > 0 || index(u, "ESQIFF_PARSEFIELD3TAILBUFFER") > 0) tail_clear_count++
    if (index(u, "ESQIFF2_PADENTRIESTOMAXTITLEWIDTH") > 0 || index(u, "PADENTRIESTOMAXTITLEWIDTH") > 0 || index(u, "PADENTRIESTOMAXTITLEWIDT") > 0) pad_call_count++
    if (index(u, "TEXTDISP_APPLYSOURCECONFIGALLENTRIES") > 0 || index(u, "APPLYSOURCECONFIGALLENTRIES") > 0 || index(u, "APPLYSOURCECONFIGALLEN") > 0 || index(u, "APPLYSOU") > 0) apply_config_count++
    if (index(u, "NEWGRID_REBUILDINDEXCACHE") > 0 || index(u, "REBUILDINDEXCACHE") > 0 || index(u, "REBUILDINDEXCAC") > 0 || index(u, "REBUILDIN") > 0) rebuild_count++
    if (u ~ /^BRA\.[SWB] ESQIFF2_PARSEGROUPRECORDANDREFRESH_RETURN$/ || u ~ /^JMP ESQIFF2_PARSEGROUPRECORDANDREFRESH_RETURN$/ || u ~ /^BRA\.[SWB] ___ESQIFF2_PARSEGROUPRECORDANDREF/ || u == "RTS") has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PRIMARY_GROUP_GATE=" has_primary_group_gate
    print "HAS_SECONDARY_GROUP_GATE=" has_secondary_group_gate
    print "HAS_TOKEN_01=" has_token_01
    print "HAS_TOKEN_11=" has_token_11
    print "HAS_TOKEN_12=" has_token_12
    print "HAS_TOKEN_14=" has_token_14
    print "VALIDATE_CALL_COUNT=" validate_call_count
    print "CREATE_ENTRY_COUNT=" create_entry_count
    print "REMOVE_GROUP_COUNT=" remove_group_count
    print "REFRESH_FLAG_WRITE_COUNT=" refresh_flag_write_count
    print "TAIL_CLEAR_COUNT=" tail_clear_count
    print "PAD_CALL_COUNT=" pad_call_count
    print "APPLY_CONFIG_COUNT=" apply_config_count
    print "REBUILD_COUNT=" rebuild_count
    print "HAS_RETURN_BRANCH=" has_return_branch
}
