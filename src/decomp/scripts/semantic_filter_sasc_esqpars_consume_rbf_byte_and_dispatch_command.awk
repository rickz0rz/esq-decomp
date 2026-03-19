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
    has_parse_digit_label=0
    has_copy_label=0
    has_clear_primary_flags=0
    has_font_command=0
    has_parse_attempts=0
    has_line_errors=0
    has_filter_state=0
    has_banner_dispatch=0
    has_type_record=0
    has_cmd_options=0
    has_cmd_string=0
    has_ppv_command=0
    has_copy_suffix=0
    has_banner_entry=0
    has_boxoff=0
    has_diagnostics=0
    has_bang_path=0
    has_title_table_walk=0
    has_reverse_bits=0
    has_test_bit=0
    has_replace_owned_string=0
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
    if (n ~ /CLEARFLAGS/ || n ~ /PREAMBLE55SEENFLAG/ && n ~ /MOVEW0/) has_clear_flags=1
    if (n ~ /UPDATESTATUSMASKANDREFRESH/ || n ~ /RESETARMEDFLAG/ || n ~ /INTERACTIVETRANSFERARMEDFLAG/) has_status_refresh=1
    if (n ~ /READRBFBYTESWITHXOR/ || n ~ /READRBFBYTESWITHXO/) has_read_rbf_xor=1
    if (n ~ /PARSECOMPACTENTRYRECORD/ || n ~ /PARSECOMPACTENTRYREC/ || n ~ /PARSECOMPACTENTRY/) has_parse_compact=1
    if (n ~ /PARSEPROGRAMINFOCOMMANDRECORD/ || n ~ /PARSEPROGRAMINFOCOMM/ || n ~ /PROGRAMINFOCOMMANDREC/) has_program_info=1
    if (n ~ /PARSEDIGITLABELANDDISPLAY/ || n ~ /PARSEDIGITLABELANDDISP/ || n ~ /PARSEDIGITLABEL/) has_parse_digit_label=1
    if (n ~ /COPYLABELTOGLOBAL/ || n ~ /COPYLABELTOGLOB/) has_copy_label=1
    if (n ~ /CLEARPRIMARYENTRYFLAGS34TO39/ || n ~ /CLEARPRIMARYENTRYFLAGS34TO/ || n ~ /CLEARPRIMARYENTRYFLAGS/) has_clear_primary_flags=1
    if (n ~ /HANDLEFONTCOMMAND/ || n ~ /HANDLEFONTCOMM/) has_font_command=1
    if (n ~ /PARSEATTEMPTCOUNT/) has_parse_attempts=1
    if (n ~ /LINEERRORCOUNT/) has_line_errors=1
    if (n ~ /PARSEFILTERSTATEFROMBUFFER/ || n ~ /PRIMARYFILTERSTATE/ || n ~ /SECONDARYFILTERSTATE/) has_filter_state=1
    if (n ~ /HANDLEBANNERCOMMAND3233/ || n ~ /READSERIALSIZEDTEXTRECORD/ || n ~ /BANNERSUBCOMMANDSET/) has_banner_dispatch=1
    if (n ~ /PARSEANDSTORETYPERECORD/ || n ~ /PTYPEPARSEANDSTORE/) has_type_record=1
    if (n ~ /PARSECOMMANDOPTIONS/) has_cmd_options=1
    if (n ~ /PARSECOMMANDSTRING/) has_cmd_string=1
    if (n ~ /PARSEPPVCOMMAND/) has_ppv_command=1
    if (n ~ /SELECTIONSUFFIXBUFFER/) has_copy_suffix=1
    if (n ~ /PARSEBANNERENTRYDATA/ || n ~ /130/ && n ~ /RECORD/) has_banner_entry=1
    if (n ~ /PERSISTONNEXTBOXOFFFLAG/ || n ~ /NOTB/ && n ~ /44/ || n ~ /UPDATESTATUSMASKANDREFRESH/ && n ~ /MODECLEAR/) has_boxoff=1
    if (n ~ /256/ && n ~ /GENERATEXORCHECKSUMBYTE/ || n ~ /DIAGNOSTICSPACKETBYTES/) has_diagnostics=1
    if (n ~ /READRBFBYTESWITHXOR/ && n ~ /DE/ || n ~ /BANG/ && n ~ /REPLACEOWNEDSTRING/) has_bang_path=1
    if (n ~ /GETENTRYPOINTERBYMODE/ || n ~ /GETENTRYAUXPOINTERBYMODE/ || n ~ /PRIMARYTITLEPTRTABLE/ || n ~ /SECONDARYTITLEPTRTABLE/) has_title_table_walk=1
    if (n ~ /REVERSEBITSIN6BYTES/) has_reverse_bits=1
    if (n ~ /TESTBIT1BASED/) has_test_bit=1
    if (n ~ /REPLACEOWNEDSTRING/) has_replace_owned_string=1
    if (u == "RTS") has_rts=1
}

END {
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
    print "HAS_PARSE_DIGIT_LABEL=" has_parse_digit_label
    print "HAS_COPY_LABEL=" has_copy_label
    print "HAS_CLEAR_PRIMARY_FLAGS=" has_clear_primary_flags
    print "HAS_FONT_COMMAND=" has_font_command
    print "HAS_PARSE_ATTEMPTS=" has_parse_attempts
    print "HAS_LINE_ERRORS=" has_line_errors
    print "HAS_FILTER_STATE_PARSE=" has_filter_state
    print "HAS_BANNER_DISPATCH=" has_banner_dispatch
    print "HAS_TYPE_RECORD_PARSE=" has_type_record
    print "HAS_COMMAND_OPTIONS_PARSE=" has_cmd_options
    print "HAS_COMMAND_STRING_PARSE=" has_cmd_string
    print "HAS_PPV_COMMAND_PARSE=" has_ppv_command
    print "HAS_COPY_SELECTION_SUFFIX=" has_copy_suffix
    print "HAS_BANNER_ENTRY_PARSE=" has_banner_entry
    print "HAS_BOXOFF_PATH=" has_boxoff
    print "HAS_DIAGNOSTICS_PATH=" has_diagnostics
    print "HAS_BANG_PATH=" has_bang_path
    print "HAS_TITLE_TABLE_WALK=" has_title_table_walk
    print "HAS_REVERSE_BITS=" has_reverse_bits
    print "HAS_TEST_BIT=" has_test_bit
    print "HAS_REPLACE_OWNED_STRING=" has_replace_owned_string
    print "HAS_RTS=" has_rts
}
