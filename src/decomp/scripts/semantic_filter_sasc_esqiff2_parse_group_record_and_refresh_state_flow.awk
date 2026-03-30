BEGIN {
    has_entry = 0

    saw_primary_length_ref = 0
    saw_primary_checksum_ref = 0
    saw_primary_entry_count_ref = 0
    saw_secondary_length_ref = 0
    saw_secondary_checksum_ref = 0
    saw_secondary_entry_count_ref = 0
    saw_max_title_len_ref = 0
    has_primary_refresh_path = 0
    has_secondary_refresh_path = 0
    has_primary_refresh_flag = 0

    saw_reset_helper = 0
    saw_field0_reset = 0
    saw_field1_reset = 0
    saw_field2_ff = 0
    saw_field3_reset = 0
    has_parse_reset_flow = 0

    saw_byte_read = 0
    saw_zero_break = 0
    saw_parse_failed_break = 0
    has_loop_guard = 0

    saw_token01 = 0
    saw_token11 = 0
    saw_token12 = 0
    saw_token14 = 0
    has_dispatch_chain = 0

    has_token12_validate = 0
    has_token12_pending_gate = 0
    has_token12_split_gate = 0
    has_token12_copy_loop = 0
    saw_tail_clear = 0
    saw_create_entry = 0
    has_token12_create_flow = 0
    has_display_mode_load = 0

    has_token11_flow = 0
    has_token14_copy6 = 0
    has_token01_split_mark = 0
    saw_length_inc = 0
    saw_append_store = 0
    has_default_append = 0

    saw_pad_call = 0
    saw_apply_config = 0
    saw_rebuild_cache = 0
    has_final_flush_flow = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQIFF2_PARSEGROUPRECORDANDREFRESH:/ ||
        u ~ /^ESQIFF2_PARSEGROUPRECORDANDREF[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /TEXTDISPPRIMARYGROUPRECORDLENG/) {
        saw_primary_length_ref = 1
    }
    if (n ~ /TEXTDISPPRIMARYGROUPRECORDCHECK/) {
        saw_primary_checksum_ref = 1
    }
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/) {
        saw_primary_entry_count_ref = 1
    }
    if (n ~ /TEXTDISPSECONDARYGROUPRECORDLEN/) {
        saw_secondary_length_ref = 1
    }
    if (n ~ /TEXTDISPSECONDARYGROUPRECORDCHE/) {
        saw_secondary_checksum_ref = 1
    }
    if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUN/) {
        saw_secondary_entry_count_ref = 1
    }
    if (n ~ /TEXTDISPMAXENTRYTITLELENGTH/) {
        saw_max_title_len_ref = 1
    }
    if (saw_primary_length_ref && saw_primary_checksum_ref &&
        saw_primary_entry_count_ref && saw_max_title_len_ref) {
        has_primary_refresh_path = 1
    }
    if (saw_secondary_length_ref && saw_secondary_checksum_ref &&
        saw_secondary_entry_count_ref && saw_max_title_len_ref) {
        has_secondary_refresh_path = 1
    }
    if (n ~ /NEWGRIDREFRESHSTATEFLAG/) {
        has_primary_refresh_flag = 1
    }

    if (n ~ /PARSEGROUPRESETPARSEBUFFERS/) {
        saw_reset_helper = 1
    }
    if (n ~ /ESQIFFPARSEFIELD0BUFFER/) {
        saw_field0_reset = 1
    }
    if (n ~ /ESQIFFPARSEFIELD1BUFFER/) {
        saw_field1_reset = 1
    }
    if (u ~ /#\$FF/ || u ~ /#255([^0-9]|$)/ || u ~ /#-1([^0-9]|$)/) {
        saw_field2_ff = 1
    }
    if (n ~ /ESQIFFPARSEFIELD3BUFFER/ && (n ~ /CLRB/ || n ~ /MOVEB0/ || n ~ /CLRBA4/)) {
        saw_field3_reset = 1
    }
    if (saw_reset_helper || (saw_field0_reset && saw_field1_reset && saw_field2_ff && saw_field3_reset)) {
        has_parse_reset_flow = 1
    }

    if (u ~ /^MOVE\.B \(A[35]\)\+,D[0-7]$/ || n ~ /MOVEBA5D0/ || n ~ /MOVEBA3D0/ ||
        n ~ /MOVEBA5D7/ || n ~ /MOVEBA3D6/) {
        saw_byte_read = 1
    }
    if (n ~ /TSTB/ || n ~ /BEQW/ || n ~ /BEQS/ || n ~ /BEQB/) {
        saw_zero_break = 1
    }
    if (n ~ /TSTL12A5/ || n ~ /TSTL28A7/ || n ~ /PARSEFAILED/) {
        saw_parse_failed_break = 1
    }
    if (saw_byte_read && saw_zero_break && saw_parse_failed_break) {
        has_loop_guard = 1
    }
    if (u ~ /#\$1/ || u ~ /#1([^0-9]|$)/) {
        saw_token01 = 1
    }
    if (u ~ /#\$11/ || u ~ /#17([^0-9]|$)/ || u ~ /#\$10/ || u ~ /#16([^0-9]|$)/) {
        saw_token11 = 1
    }
    if (u ~ /#\$12/ || u ~ /#18([^0-9]|$)/) {
        saw_token12 = 1
    }
    if (u ~ /#\$14/ || u ~ /#20([^0-9]|$)/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /#2([^0-9]|$)/) {
        saw_token14 = 1
    }
    if (saw_token01 && saw_token11 && saw_token14 && has_token12_validate) {
        has_dispatch_chain = 1
    }

    if (n ~ /VALIDATEFIELDINDEXANDLEN/ && !has_token12_validate) {
        has_token12_validate = 1
    }
    if (n ~ /TSTL8A5/ || n ~ /TSTL2CA7/ || n ~ /FIRSTENTRYPENDING/) {
        has_token12_pending_gate = 1
    }
    if (n ~ /TSTW14A5/ || n ~ /TSTW26A7/ || n ~ /HASFIELD3SPLIT/) {
        has_token12_split_gate = 1
    }
    if ((n ~ /ESQIFFPARSEFIELD0BUFFER/ && n ~ /ESQIFFPARSEFIELD3BUFFER/) ||
        n ~ /MOVEBA3A2/ || n ~ /BRANCH2/ || n ~ /FIELD0TOFIELD3/) {
        has_token12_copy_loop = 1
    }
    if (n ~ /ESQIFFPARSEFIELD0TAILBUFFER/ || n ~ /ESQIFFPARSEFIELD1TAILBYTE/ ||
        n ~ /ESQIFFPARSEFIELD3TAILBUFFER/) {
        saw_tail_clear = 1
    }
    if (n ~ /ESQSHAREDCREATEGROUPENTRYANDTIT/) {
        saw_create_entry = 1
    }
    if (saw_tail_clear && saw_create_entry) {
        has_token12_create_flow = 1
    }
    if ((u ~ /^MOVE\.B \(A[35]\)\+,D[67]$/ || n ~ /MOVEBA5D7/ || n ~ /MOVEBA3D6/) &&
        (n ~ /DISPLAYMODE/ || n ~ /MOVEB/)) {
        has_display_mode_load = 1
    }

    if (saw_token11 &&
        (n ~ /MOVEQ1D4/ || n ~ /MOVEQL1D6/ || n ~ /MOVEQD40/ || n ~ /FIELDINDEX1/)) {
        has_token11_flow = 1
    }
    if (saw_token14 && n ~ /ESQIFFPARSEFIELD2BUFFER/ &&
        (u ~ /#\$6/ || u ~ /#6([^0-9]|$)/ || n ~ /CMPWD1D0/ || n ~ /MOVEQ6D1/)) {
        has_token14_copy6 = 1
    }
    if (saw_token01 &&
        (n ~ /MOVEQ3D4/ || n ~ /MOVEQL3D6/ || n ~ /MOVEW126A7/ || n ~ /SPLITFLAG/)) {
        has_token01_split_mark = 1
    }
    if (n ~ /ADDQL1D5/ || n ~ /ADDQW1D5/ || n ~ /FIELDLENGTH/) {
        saw_length_inc = 1
    }
    if (n ~ /MOVEB24A7A0/ || n ~ /MOVEB3A5A0/ || n ~ /BYTEVALUE/ ||
        u ~ /^MOVE\.B .*\,\(A0\)$/) {
        saw_append_store = 1
    }
    if (saw_length_inc && saw_append_store) {
        has_default_append = 1
    }

    if (n ~ /ESQIFF2PADENTRIESTOMAXTITLEWIDT/) {
        saw_pad_call = 1
    }
    if (n ~ /TEXTDISPAPPLYSOURCECONFIGALLENT/) {
        saw_apply_config = 1
    }
    if (n ~ /NEWGRIDREBUILDINDEXCACHE/) {
        saw_rebuild_cache = 1
    }
    if (saw_create_entry && saw_pad_call && saw_apply_config && saw_rebuild_cache) {
        has_final_flush_flow = 1
    }

    if (u == "RTS" || n ~ /PARSEGROUPRECORDANDREFRESHRETURN/) {
        has_return = 1
    }
}

END {
    if (saw_reset_helper || (saw_field0_reset && saw_field1_reset && saw_field2_ff && saw_field3_reset)) {
        has_parse_reset_flow = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_PRIMARY_REFRESH_PATH=" has_primary_refresh_path
    print "HAS_SECONDARY_REFRESH_PATH=" has_secondary_refresh_path
    print "HAS_PRIMARY_REFRESH_FLAG=" has_primary_refresh_flag
    print "HAS_PARSE_RESET_FLOW=" has_parse_reset_flow
    print "HAS_LOOP_GUARD=" has_loop_guard
    print "HAS_DISPATCH_CHAIN=" has_dispatch_chain
    print "HAS_TOKEN12_VALIDATE=" has_token12_validate
    print "HAS_TOKEN12_PENDING_GATE=" has_token12_pending_gate
    print "HAS_TOKEN12_SPLIT_GATE=" has_token12_split_gate
    print "HAS_TOKEN12_COPY_LOOP=" has_token12_copy_loop
    print "HAS_TOKEN12_CREATE_FLOW=" has_token12_create_flow
    print "HAS_DISPLAY_MODE_LOAD=" has_display_mode_load
    print "HAS_TOKEN11_FLOW=" has_token11_flow
    print "HAS_TOKEN14_COPY6=" has_token14_copy6
    print "HAS_TOKEN01_SPLIT_MARK=" has_token01_split_mark
    print "HAS_DEFAULT_APPEND=" has_default_append
    print "HAS_FINAL_FLUSH_FLOW=" has_final_flush_flow
    print "HAS_RETURN=" has_return
}
