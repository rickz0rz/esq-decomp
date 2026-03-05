BEGIN {
    has_entry = 0
    has_group_gate = 0
    has_remove_group = 0
    has_init_fields = 0
    has_token_01 = 0
    has_token_11 = 0
    has_token_12 = 0
    has_token_14 = 0
    has_validate_call = 0
    has_create_entry = 0
    has_pad_call = 0
    has_apply_config = 0
    has_rebuild = 0
    has_return_branch = 0
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

    if (u ~ /^ESQIFF2_PARSEGROUPRECORDANDREFRESH:/ || u ~ /^ESQIFF2_PARSEGROUPRECORDANDREF[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_PRIMARYGROUPCODE") > 0 || index(u, "TEXTDISP_SECONDARYGROUPCODE") > 0) has_group_gate = 1
    if (index(u, "REMOVEGROUPENTRYANDRELEASESTRINGS") > 0 || index(u, "REMOVEGROUPENTRYANDRELEA") > 0) has_remove_group = 1
    if (index(u, "ESQIFF_PARSEFIELD0BUFFER") > 0 && index(u, "ESQIFF_PARSEFIELD1BUFFER") > 0) has_init_fields = 1
    if (u ~ /^CMPI\.[WL] #\$1,D[0-7]$/ || u ~ /^CMPI\.[WL] #1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^CASE 0X01$/ || index(u, "HANDLE_TOKEN_0X01") > 0) has_token_01 = 1
    if (u ~ /^CMPI\.[WL] #\$11,D[0-7]$/ || u ~ /^CMPI\.[WL] #17,D[0-7]$/ || u ~ /^MOVEQ\.L #\$10,D[0-7]$/ || u ~ /^MOVEQ\.L #16,D[0-7]$/ || u ~ /^SUBI\.[WL] #16,D[0-7]$/ || u ~ /^CASE 0X11$/ || index(u, "HANDLE_TOKEN_0X11") > 0) has_token_11 = 1
    if (u ~ /^CMPI\.[WL] #\$12,D[0-7]$/ || u ~ /^CMPI\.[WL] #18,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^CASE 0X12$/ || index(u, "HANDLE_TOKEN_0X12") > 0) has_token_12 = 1
    if (u ~ /^CMPI\.[WL] #\$14,D[0-7]$/ || u ~ /^CMPI\.[WL] #20,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$2,D[0-7]$/ || u ~ /^SUBQ\.[WL] #2,D[0-7]$/ || u ~ /^CASE 0X14$/ || index(u, "HANDLE_TOKEN_0X14") > 0) has_token_14 = 1
    if (index(u, "ESQIFF2_VALIDATEFIELDINDEXANDLENGTH") > 0 || index(u, "VALIDATEFIELDINDEXANDLENGTH") > 0 || index(u, "VALIDATEFIELDINDEXANDLEN") > 0) has_validate_call = 1
    if (index(u, "ESQSHARED_CREATEGROUPENTRYANDTITLE") > 0 || index(u, "CREATEGROUPENTRYANDTITLE") > 0 || index(u, "CREATEGROUPENTRYANDTIT") > 0) has_create_entry = 1
    if (index(u, "ESQIFF2_PADENTRIESTOMAXTITLEWIDTH") > 0 || index(u, "PADENTRIESTOMAXTITLEWIDTH") > 0 || index(u, "PADENTRIESTOMAXTITLEWIDT") > 0) has_pad_call = 1
    if (index(u, "TEXTDISP_APPLYSOURCECONFIGALLENTRIES") > 0 || index(u, "APPLYSOURCECONFIGALLENTRIES") > 0 || index(u, "APPLYSOURCECONFIGALLEN") > 0 || index(u, "APPLYSOU") > 0) has_apply_config = 1
    if (index(u, "NEWGRID_REBUILDINDEXCACHE") > 0 || index(u, "REBUILDINDEXCACHE") > 0 || index(u, "REBUILDINDEXCAC") > 0 || index(u, "REBUILDIN") > 0) has_rebuild = 1
    if (u ~ /^BRA\.[SWB] ESQIFF2_PARSEGROUPRECORDANDREFRESH_RETURN$/ || u ~ /^JMP ESQIFF2_PARSEGROUPRECORDANDREFRESH_RETURN$/ || u ~ /^BRA\.[SWB] ___ESQIFF2_PARSEGROUPRECORDANDREF/ || u == "RTS") has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GROUP_GATE=" has_group_gate
    print "HAS_REMOVE_GROUP=" has_remove_group
    print "HAS_INIT_FIELDS=" has_init_fields
    print "HAS_TOKEN_01=" has_token_01
    print "HAS_TOKEN_11=" has_token_11
    print "HAS_TOKEN_12=" has_token_12
    print "HAS_TOKEN_14=" has_token_14
    print "HAS_VALIDATE_CALL=" has_validate_call
    print "HAS_CREATE_ENTRY=" has_create_entry
    print "HAS_PAD_CALL=" has_pad_call
    print "HAS_APPLY_CONFIG=" has_apply_config
    print "HAS_REBUILD=" has_rebuild
    print "HAS_RETURN_BRANCH=" has_return_branch
}
