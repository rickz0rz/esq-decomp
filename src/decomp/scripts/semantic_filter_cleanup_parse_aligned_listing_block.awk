BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_slot_init_loop = 0
    has_test_entry_flag = 0
    has_update_entry_flags = 0
    has_build_aligned_status = 0
    has_format_tokens = 0
    has_draw_inset = 0
    has_replace_owned = 0
    has_parse_hex = 0
    has_free_subentries = 0
    has_create_group_entry = 0
    has_write_oi = 0
    has_return_success = 0
    has_return_status = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_PARSEALIGNEDLISTINGBLOCK:/) has_label = 1
    if (uline ~ /LINK.W A5,#-128/) has_link = 1
    if (uline ~ /MOVEM.L D2-D7\/A2-A3\/A6,-\(A7\)/) has_save = 1
    if (uline ~ /\.INIT_SLOT_TABLE_LOOP:/) has_slot_init_loop = 1
    if (uline ~ /CLEANUP_TESTENTRYFLAGYANDBIT1/) has_test_entry_flag = 1
    if (uline ~ /CLEANUP_UPDATEENTRYFLAGBYTES/) has_update_entry_flags = 1
    if (uline ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) has_build_aligned_status = 1
    if (uline ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/) has_format_tokens = 1
    if (uline ~ /CLEANUP_DRAWINSETRECTFRAME/) has_draw_inset = 1
    if (uline ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/) has_replace_owned = 1
    if (uline ~ /GROUP_AE_JMPTBL_LADFUNC_PARSEHEXDIGIT/) has_parse_hex = 1
    if (uline ~ /COI_FREESUBENTRYTABLENTRIES/) has_free_subentries = 1
    if (uline ~ /ESQSHARED_CREATEGROUPENTRYANDTITLE/) has_create_group_entry = 1
    if (uline ~ /COI_WRITEOIDATAFILE/) has_write_oi = 1
    if (uline ~ /\.RETURN_SUCCESS:/) has_return_success = 1
    if (uline ~ /\.RETURN_STATUS:/) has_return_status = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2-D7\/A2-A3\/A6/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_SLOT_INIT_LOOP=" has_slot_init_loop
    print "HAS_TEST_ENTRY_FLAG=" has_test_entry_flag
    print "HAS_UPDATE_ENTRY_FLAGS=" has_update_entry_flags
    print "HAS_BUILD_ALIGNED_STATUS=" has_build_aligned_status
    print "HAS_FORMAT_TOKENS=" has_format_tokens
    print "HAS_DRAW_INSET=" has_draw_inset
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_FREE_SUBENTRIES=" has_free_subentries
    print "HAS_CREATE_GROUP_ENTRY=" has_create_group_entry
    print "HAS_WRITE_OI=" has_write_oi
    print "HAS_RETURN_SUCCESS=" has_return_success
    print "HAS_RETURN_STATUS=" has_return_status
    print "HAS_RESTORE=" has_restore
}
