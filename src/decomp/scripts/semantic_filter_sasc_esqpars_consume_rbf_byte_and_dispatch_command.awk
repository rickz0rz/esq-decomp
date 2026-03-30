BEGIN {
    has_entry=0
    has_read_serial=0
    has_preamble55_write=0
    has_armed_write=0
    has_sync_55_check=0
    has_sync_aa_check=0
    has_cmd_a_check=0
    has_checksum_call=0
    has_cmd_w_or_w=0
    has_record_length=0
    has_dataerrs=0
    has_selection_match=0
    has_const16=0
    has_clear_flags=0
    has_status_refresh=0
    has_read_rbf_xor=0
    has_parse_compact=0
    has_program_info=0
    has_program_info_command=0
    has_parse_digit_label=0
    has_copy_label=0
    has_clear_primary_flags=0
    has_font_command=0
    has_parse_attempts=0
    has_line_errors=0
    has_filter_state=0
    has_banner_dispatch=0
    has_banner_text_record=0
    has_status_packet_apply=0
    has_clock_packet_apply=0
    has_group_record_parse=0
    has_version_overlay=0
    has_aligned_listing=0
    has_binary_transfer=0
    has_reset_overlay=0
    has_boxoff_commit=0
    has_type_record=0
    has_cmd_options=0
    has_cmd_string=0
    has_ppv_command=0
    has_copy_suffix=0
    has_banner_entry=0
    has_boxoff=0
    has_diagnostics=0
    has_config_parse=0
    has_config_save=0
    has_interactive_transfer=0
    has_bang_path=0
    has_bang_y_normalize=0
    has_bang_slot_flag_write=0
    has_diag_read=0
    has_diag_checksum=0
    has_diag_reset=0
    has_title_table_walk=0
    has_reverse_bits=0
    has_test_bit=0
    has_bitmap_mode_split=0
    has_payload_width_guard=0
    has_attr_writes=0
    has_sparse_payload_count=0
    has_replace_owned_string=0
    has_rts=0
    diag_window_active=0
    prev=""
    prev2=""
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

    if (u ~ /#\$100/ || u ~ /\(\$100\)/ || u ~ /#256([^0-9]|$)/ ||
        u ~ /PEA 256\.W/ || n ~ /256W/) diag_window_active=1

    if (u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAND:/ || u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAN[A-Z0-9_]*:/ || u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /READSERIALRBFBYTE/ || n ~ /READSERIAL/) has_read_serial=1
    if (n ~ /PREAMBLE55SEENFLAG/) has_preamble55_write=1
    if (n ~ /COMMANDPREAMBLEARMEDFLAG/) has_armed_write=1
    if (n ~ /55/ && (n ~ /CMP/ || n ~ /EQ/)) has_sync_55_check=1
    if (n ~ /AA/ && (n ~ /CMP/ || n ~ /EQ/)) has_sync_aa_check=1
    if (n ~ /41/ || n ~ /CMDBYTEA/ || n ~ /CMPB/ && n ~ /D0/) has_cmd_a_check=1
    if (n ~ /GENERATEXORCHECKSUMBYTE/ || n ~ /GENERATEXORCH/ || n ~ /READSERIALRECORDINTOBUFFER/ || n ~ /READSERIALRECORDINTOBUFF/) has_checksum_call=1
    if (n ~ /VERIFYCHECKSUMANDPARSERECORD/ || n ~ /VERIFYCHECKSUMANDPARSELIST/ || n ~ /ESQPROTOVERIFYCH/) has_cmd_w_or_w=1
    if (n ~ /ESQIFFRECORDLENGTH/ || n ~ /ESQIFFRECORDCHECKSUMBYTE/ || n ~ /ESQIFFRECORDBUFFERPTR/) has_record_length=1
    if (n ~ /DATACERRS/) has_dataerrs=1
    if (n ~ /SELECTIONMATCHCODE/ || n ~ /MATCHSELECTIONCODEWITHOPTIONALSUFFIX/) has_selection_match=1
    if (u ~ /#16([^0-9]|$)/ || u ~ /#\$10/ || u ~ /\(\$10\)/ || u ~ /\$10\.[Ww]/) has_const16=1
    if (n ~ /CLEARFLAGS/ ||
        ((n ~ /PREAMBLE55SEENFLAG/ || n ~ /COMMANDPREAMBLEARMEDFLAG/) &&
         (n ~ /MOVEW0/ || n ~ /MOVEWD0/ || n ~ /MOVEWD1/ || n ~ /CLRW/ ||
          prev ~ /MOVEQ #0/ || prev2 ~ /MOVEQ #0/))) has_clear_flags=1
    if (n ~ /UPDATESTATUSMASKANDREFRESH/ || n ~ /RESETARMEDFLAG/ || n ~ /INTERACTIVETRANSFERARMEDFLAG/) has_status_refresh=1
    if (n ~ /READRBFBYTESWITHXOR/ || n ~ /READRBFBYTESWITHXO/) has_read_rbf_xor=1
    if (n ~ /PARSECOMPACTENTRYRECORD/ || n ~ /PARSECOMPACTENTRYREC/ || n ~ /PARSECOMPACTENTRY/) has_parse_compact=1
    if (n ~ /PARSEPROGRAMINFOCOMMANDRECORD/ || n ~ /PARSEPROGRAMINFOCOMM/ || n ~ /PROGRAMINFOCOMMANDREC/) has_program_info=1
    if (n ~ /ESQDISPPARSEPROGRAMINFOCOMMANDRECORD/ || n ~ /PARSEPROGRAMINFOCOMMANDRECORD/ || n ~ /PARSEPROGRAMINFOCOMM/) has_program_info_command=1
    if (n ~ /PARSEDIGITLABELANDDISPLAY/ || n ~ /PARSEDIGITLABELANDDISP/ || n ~ /PARSEDIGITLABEL/) has_parse_digit_label=1
    if (n ~ /COPYLABELTOGLOBAL/ || n ~ /COPYLABELTOGLOB/) has_copy_label=1
    if (n ~ /CLEARPRIMARYENTRYFLAGS34TO39/ || n ~ /CLEARPRIMARYENTRYFLAGS34TO/ || n ~ /CLEARPRIMARYENTRYFLAGS/) has_clear_primary_flags=1
    if (n ~ /HANDLEFONTCOMMAND/ || n ~ /HANDLEFONTCOMM/) has_font_command=1
    if (n ~ /PARSEATTEMPTCOUNT/) has_parse_attempts=1
    if (n ~ /LINEERRORCOUNT/) has_line_errors=1
    if (n ~ /PARSEFILTERSTATEFROMBUFFER/ || n ~ /PRIMARYFILTERSTATE/ || n ~ /SECONDARYFILTERSTATE/) has_filter_state=1
    if (n ~ /HANDLEBANNERCOMMAND3233/ || n ~ /READSERIALSIZEDTEXTRECORD/ || n ~ /BANNERSUBCOMMANDSET/) has_banner_dispatch=1
    if (n ~ /READSERIALSIZEDTEXTRECORD/ || n ~ /READSERIALSIZEDTEXTREC/) has_banner_text_record=1
    if (n ~ /APPLYINCOMINGSTATUSPACKET/ || n ~ /APPLYINCOMINGSTATUSPACK/) has_status_packet_apply=1
    if (n ~ /APPLYRTCBYTESANDPERSIST/ || n ~ /CTASKSSTR1/ && n ~ /50/) has_clock_packet_apply=1
    if (n ~ /PARSEGROUPRECORDANDREFRESH/ || n ~ /STATUSPACKETREADYFLAG/) has_group_record_parse=1
    if (n ~ /SHOWVERSIONMISMATCHOVERLAY/ || n ~ /SHOWVERSIONMISMATCHOVERL/) has_version_overlay=1
    if (n ~ /PARSEALIGNEDLISTINGBLOCK/) has_aligned_listing=1
    if (n ~ /HANDLEINTERACTIVEFILETRANSFER/ || n ~ /HANDLEINTERACTIVEFILETRA/) has_binary_transfer=1
    if (n ~ /GLOBALTICKCOUNTER/ || n ~ /RESETCOMMANDRECEIVED/ || n ~ /DISPLAYTEXTATPOSITION/) has_reset_overlay=1
    if (n ~ /PERSISTSTATEDATAAFTERCOMMAND/ || n ~ /PERSISTSTATEDATAAFTERCOM/ ||
        n ~ /STATUSMODECLEAR/ && n ~ /UPDATESTATUSMASKANDREFRESH/ ||
        n ~ /UPDATESTATUSMASKANDREFRE/) has_boxoff_commit=1
    if (n ~ /PARSEANDSTORETYPERECORD/ || n ~ /PTYPEPARSEANDSTORE/) has_type_record=1
    if (n ~ /PARSECOMMANDOPTIONS/) has_cmd_options=1
    if (n ~ /PARSECOMMANDSTRING/) has_cmd_string=1
    if (n ~ /PARSEPPVCOMMAND/) has_ppv_command=1
    if (n ~ /PARSECONFIGBUFFER/ || n ~ /DISKIOPARSECONFIGBUFFER/) has_config_parse=1
    if (n ~ /SAVECONFIGTOFILEHANDLE/ || n ~ /DISKIOSAVECONFIGTOFILEHANDLE/) has_config_save=1
    if (n ~ /HANDLEINTERACTIVEFILETRANSFER/ || n ~ /HANDLEINTERACTIVEFILETRA/) has_interactive_transfer=1
    if (n ~ /SELECTIONSUFFIXBUFFER/) has_copy_suffix=1
    if (n ~ /PARSEBANNERENTRYDATA/ || n ~ /130/ && n ~ /RECORD/) has_banner_entry=1
    if (n ~ /PERSISTONNEXTBOXOFFFLAG/ || n ~ /NOTB/ && n ~ /44/ || n ~ /UPDATESTATUSMASKANDREFRESH/ && n ~ /MODECLEAR/) has_boxoff=1
    if ((n ~ /READRBFBYTESTOBUFFER/ || n ~ /READRBFBYTESTOBUFF/) && diag_window_active) {
        has_diag_read=1
    }
    if (n ~ /GENERATEXORCHECKSUMBYTE/ && diag_window_active) {
        has_diag_checksum=1
    }
    if (n ~ /RESETARMEDFLAG/ && (n ~ /CLRW/ || n ~ /MOVEW0/)) {
        has_diag_reset=1
    }
    if (n ~ /REPLACEOWNEDSTRING/ || n ~ /89/ && n ~ /30/ || n ~ /59/ && n ~ /30/) has_bang_path=1
    if (n ~ /89/ || n ~ /59/ || n ~ /Y/) has_bang_y_normalize=1
    if (n ~ /SLOTFLAGS/ || n ~ /MOVEB1.*7A0/ || n ~ /MOVEBD2.*7A3/ || n ~ /7A0D0W/ || n ~ /7A3D1L/) has_bang_slot_flag_write=1
    if (n ~ /GETENTRYPOINTERBYMODE/ || n ~ /GETENTRYAUXPOINTERBYMODE/ || n ~ /PRIMARYTITLEPTRTABLE/ || n ~ /SECONDARYTITLEPTRTABLE/) has_title_table_walk=1
    if (n ~ /REVERSEBITSIN6BYTES/) has_reverse_bits=1
    if (n ~ /TESTBIT1BASED/) has_test_bit=1
    if (n ~ /BITMAPHASANYSETBYTES/ || n ~ /TSTB100A7/ || n ~ /224/) has_bitmap_mode_split=1
    if (n ~ /PAYLOADWIDTH/ || n ~ /223A5/ || n ~ /1/ && n ~ /3/ && n ~ /CMP/) has_payload_width_guard=1
    if (n ~ /SLOTATTR252/ || n ~ /SLOTATTR301/ || n ~ /SLOTATTR350/ || n ~ /FC/ || n ~ /12D/ || n ~ /15E/) has_attr_writes=1
    if (n ~ /MATHMULU32/ || n ~ /44A7/ || n ~ /COUNTMARKEDROWS/) has_sparse_payload_count=1
    if (n ~ /REPLACEOWNEDSTRING/) has_replace_owned_string=1
    if (u == "RTS") has_rts=1

    prev2 = prev
    prev = u
}

END {
    has_diagnostics = (has_diag_read && has_diag_checksum && has_diag_reset)
    print "HAS_ENTRY=" has_entry
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_PREAMBLE55_WRITE=" has_preamble55_write
    print "HAS_ARMED_WRITE=" has_armed_write
    print "HAS_SYNC_55_CHECK=" has_sync_55_check
    print "HAS_SYNC_AA_CHECK=" has_sync_aa_check
    print "HAS_CMD_A_CHECK=" has_cmd_a_check
    print "HAS_CHECKSUM_CALL=" has_checksum_call
    print "HAS_CMD_W_OR_W=" has_cmd_w_or_w
    print "HAS_RECORD_LENGTH_STATE=" has_record_length
    print "HAS_DATAERRS=" has_dataerrs
    print "HAS_SELECTION_MATCH=" has_selection_match
    print "HAS_CONST_16=" has_const16
    print "HAS_CLEAR_FLAGS=" has_clear_flags
    print "HAS_STATUS_REFRESH_PATH=" has_status_refresh
    print "HAS_READ_RBF_XOR=" has_read_rbf_xor
    print "HAS_PARSE_COMPACT_ENTRY=" has_parse_compact
    print "HAS_PROGRAM_INFO_PARSE=" has_program_info
    print "HAS_PROGRAM_INFO_COMMAND_PARSE=" has_program_info_command
    print "HAS_PARSE_DIGIT_LABEL=" has_parse_digit_label
    print "HAS_COPY_LABEL=" has_copy_label
    print "HAS_CLEAR_PRIMARY_FLAGS=" has_clear_primary_flags
    print "HAS_FONT_COMMAND=" has_font_command
    print "HAS_PARSE_ATTEMPTS=" has_parse_attempts
    print "HAS_LINE_ERRORS=" has_line_errors
    print "HAS_FILTER_STATE_PARSE=" has_filter_state
    print "HAS_BANNER_DISPATCH=" has_banner_dispatch
    print "HAS_BANNER_TEXT_RECORD=" has_banner_text_record
    print "HAS_STATUS_PACKET_APPLY=" has_status_packet_apply
    print "HAS_CLOCK_PACKET_APPLY=" has_clock_packet_apply
    print "HAS_GROUP_RECORD_PARSE=" has_group_record_parse
    print "HAS_VERSION_OVERLAY=" has_version_overlay
    print "HAS_ALIGNED_LISTING=" has_aligned_listing
    print "HAS_BINARY_TRANSFER=" has_binary_transfer
    print "HAS_RESET_OVERLAY=" has_reset_overlay
    print "HAS_BOXOFF_COMMIT=" has_boxoff_commit
    print "HAS_TYPE_RECORD_PARSE=" has_type_record
    print "HAS_COMMAND_OPTIONS_PARSE=" has_cmd_options
    print "HAS_COMMAND_STRING_PARSE=" has_cmd_string
    print "HAS_PPV_COMMAND_PARSE=" has_ppv_command
    print "HAS_CONFIG_PARSE=" has_config_parse
    print "HAS_CONFIG_SAVE=" has_config_save
    print "HAS_INTERACTIVE_TRANSFER=" has_interactive_transfer
    print "HAS_COPY_SELECTION_SUFFIX=" has_copy_suffix
    print "HAS_BANNER_ENTRY_PARSE=" has_banner_entry
    print "HAS_BOXOFF_PATH=" has_boxoff
    print "HAS_DIAGNOSTICS_PATH=" has_diagnostics
    print "HAS_BANG_PATH=" has_bang_path
    print "HAS_BANG_Y_NORMALIZE=" has_bang_y_normalize
    print "HAS_BANG_SLOT_FLAG_WRITE=" has_bang_slot_flag_write
    print "HAS_TITLE_TABLE_WALK=" has_title_table_walk
    print "HAS_REVERSE_BITS=" has_reverse_bits
    print "HAS_TEST_BIT=" has_test_bit
    print "HAS_BITMAP_MODE_SPLIT=" has_bitmap_mode_split
    print "HAS_PAYLOAD_WIDTH_GUARD=" has_payload_width_guard
    print "HAS_ATTR_WRITES=" has_attr_writes
    print "HAS_SPARSE_PAYLOAD_COUNT=" has_sparse_payload_count
    print "HAS_REPLACE_OWNED_STRING=" has_replace_owned_string
    print "HAS_RTS=" has_rts
}
