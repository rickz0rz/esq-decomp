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
    uline = toupper(line)

    if (uline ~ /^ESQIFF2_PARSEGROUPRECORDANDREFRESH:/) has_entry = 1
    if (uline ~ /^MOVE\.B TEXTDISP_PRIMARYGROUPCODE,D0$/ || uline ~ /^MOVE\.B TEXTDISP_SECONDARYGROUPCODE,D0$/) has_group_gate = 1
    if (uline ~ /^BSR\.W ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS$/) has_remove_group = 1
    if (uline ~ /^MOVE\.B D0,ESQIFF_PARSEFIELD0BUFFER$/ && uline !~ /^;/) has_init_fields = 1
    if (uline ~ /^\.HANDLE_TOKEN_0X01:$/) has_token_01 = 1
    if (uline ~ /^\.HANDLE_TOKEN_0X11:$/) has_token_11 = 1
    if (uline ~ /^\.HANDLE_TOKEN_0X12:$/) has_token_12 = 1
    if (uline ~ /^\.HANDLE_TOKEN_0X14:$/) has_token_14 = 1
    if (uline ~ /^BSR\.W ESQIFF2_VALIDATEFIELDINDEXANDLENGTH$/) has_validate_call = 1
    if (uline ~ /^JSR ESQSHARED_CREATEGROUPENTRYANDTITLE\(PC\)$/) has_create_entry = 1
    if (uline ~ /^BSR\.W ESQIFF2_PADENTRIESTOMAXTITLEWIDTH$/) has_pad_call = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_TEXTDISP_APPLYSOURCECONFIGALLENTRIES\(PC\)$/) has_apply_config = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_NEWGRID_REBUILDINDEXCACHE\(PC\)$/) has_rebuild = 1
    if (uline ~ /^BRA\.[SW] ESQIFF2_PARSEGROUPRECORDANDREFRESH_RETURN$/ || uline ~ /^JMP ESQIFF2_PARSEGROUPRECORDANDREFRESH_RETURN$/) has_return_branch = 1
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
