BEGIN {
    has_entry = 0
    has_defaults = 0
    copy_pad_count = 0
    parse_long_count = 0
    has_charclass_ref = 0
    parse_hex_count = 0
    has_find_char = 0
    replace_owned_count = 0
    has_load_ppv_template = 0
    has_enabled_flag_ref = 0
    has_mode_cycle_ref = 0
    has_window_ref = 0
    has_tolerance_ref = 0
    has_message_text_pen_ref = 0
    has_message_frame_pen_ref = 0
    has_editor_layout_pen_ref = 0
    has_editor_row_pen_ref = 0
    has_showtimes_layout_pen_ref = 0
    has_showtimes_initial_line_ref = 0
    has_showtimes_row_pen_ref = 0
    has_workflow_ref = 0
    has_detail_flag_ref = 0
    has_rowspan_ref = 0
    has_delim_const = 0
    has_period_template_ref = 0
    has_listings_template_ref = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_PARSEPPVCOMMAND[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "FLIB2_LOADDIGITALPPVDEFAULTS") > 0) has_defaults = 1
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0 || index(u, "STRING_COPYPADNUL") > 0 || index(u, "STRING_COPYPAD") > 0) copy_pad_count++
    if (index(u, "ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(u, "ESQPARS_JMPTBL_PARSE_READSIGNE") > 0 || index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(u, "PARSE_READSIGNEDLONGSKIPCL") > 0) parse_long_count++

    if (index(u, "WDISP_CHARCLASSTABLE") > 0) has_charclass_ref = 1
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) parse_hex_count++

    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHARP") > 0 || index(u, "STR_FINDCHARPTR") > 0 || index(u, "STR_FINDCHARP") > 0) has_find_char = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) replace_owned_count++
    if (index(u, "GCOMMAND_LOADPPVTEMPLATE") > 0) has_load_ppv_template = 1

    if (index(u, "GCOMMAND_DIGITALPPVENABLEDFLAG") > 0 || index(u, "GCOMMAND_DIGITALPPVENABL") > 0) has_enabled_flag_ref = 1
    if (index(u, "GCOMMAND_PPVMODECYCLECOUNT") > 0 || index(u, "GCOMMAND_PPVMODECYCLEC") > 0) has_mode_cycle_ref = 1
    if (index(u, "GCOMMAND_PPVSELECTIONWINDOWMINUTES") > 0 || index(u, "GCOMMAND_PPVSELECTIONWINDOWMINUT") > 0) has_window_ref = 1
    if (index(u, "GCOMMAND_PPVSELECTIONTOLERANCEMINUTES") > 0 || index(u, "GCOMMAND_PPVSELECTIONTOLERANCEMI") > 0) has_tolerance_ref = 1
    if (index(u, "GCOMMAND_PPVMESSAGETEXTPEN") > 0 || index(u, "GCOMMAND_PPVMESSAGETEXTP") > 0) has_message_text_pen_ref = 1
    if (index(u, "GCOMMAND_PPVMESSAGEFRAMEPEN") > 0 || index(u, "GCOMMAND_PPVMESSAGEFRAMEP") > 0) has_message_frame_pen_ref = 1
    if (index(u, "GCOMMAND_PPVEDITORLAYOUTPEN") > 0 || index(u, "GCOMMAND_PPVEDITORLAYOUTP") > 0) has_editor_layout_pen_ref = 1
    if (index(u, "GCOMMAND_PPVEDITORROWPEN") > 0 || index(u, "GCOMMAND_PPVEDITORROWP") > 0) has_editor_row_pen_ref = 1
    if (index(u, "GCOMMAND_PPVSHOWTIMESLAYOUTPEN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESLAYOUTP") > 0) has_showtimes_layout_pen_ref = 1
    if (index(u, "GCOMMAND_PPVSHOWTIMESINITIALLINEINDEX") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESINITIALLINE") > 0) has_showtimes_initial_line_ref = 1
    if (index(u, "GCOMMAND_PPVSHOWTIMESROWPEN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESROWP") > 0) has_showtimes_row_pen_ref = 1
    if (index(u, "GCOMMAND_PPVSHOWTIMESWORKFLOWMODE") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESWORKF") > 0) has_workflow_ref = 1
    if (index(u, "GCOMMAND_PPVDETAILLAYOUTFLAG") > 0 || index(u, "GCOMMAND_PPVDETAILLAYOUTF") > 0) has_detail_flag_ref = 1
    if (index(u, "GCOMMAND_PPVSHOWTIMESROWSPAN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESROWS") > 0) has_rowspan_ref = 1
    if (u ~ /#\$12/ || u ~ /#18\b/) has_delim_const = 1

    if (index(u, "GCOMMAND_PPVPERIODTEMPLATEPTR") > 0 || index(u, "GCOMMAND_PPVPERIODTEMPL") > 0) has_period_template_ref = 1
    if (index(u, "GCOMMAND_PPVLISTINGSTEMPLATEPTR") > 0 || index(u, "GCOMMAND_PPVLISTINGSTEMPL") > 0) has_listings_template_ref = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_COPY_PAD=" (copy_pad_count >= 2)
    print "HAS_PARSE_LONG=" (parse_long_count >= 2)
    print "HAS_CHARCLASS_REF=" has_charclass_ref
    print "HAS_PARSE_HEX=" (parse_hex_count >= 3)
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_REPLACE_OWNED=" (replace_owned_count >= 3)
    print "HAS_LOAD_PPV_TEMPLATE=" has_load_ppv_template
    print "HAS_ENABLED_FLAG_REF=" has_enabled_flag_ref
    print "HAS_MODE_CYCLE_REF=" has_mode_cycle_ref
    print "HAS_WINDOW_REF=" has_window_ref
    print "HAS_TOLERANCE_REF=" has_tolerance_ref
    print "HAS_MESSAGE_TEXT_PEN_REF=" has_message_text_pen_ref
    print "HAS_MESSAGE_FRAME_PEN_REF=" has_message_frame_pen_ref
    print "HAS_EDITOR_LAYOUT_PEN_REF=" has_editor_layout_pen_ref
    print "HAS_EDITOR_ROW_PEN_REF=" has_editor_row_pen_ref
    print "HAS_SHOWTIMES_LAYOUT_PEN_REF=" has_showtimes_layout_pen_ref
    print "HAS_SHOWTIMES_INITIAL_LINE_REF=" has_showtimes_initial_line_ref
    print "HAS_SHOWTIMES_ROW_PEN_REF=" has_showtimes_row_pen_ref
    print "HAS_WORKFLOW_REF=" has_workflow_ref
    print "HAS_DETAIL_FLAG_REF=" has_detail_flag_ref
    print "HAS_ROWSPAN_REF=" has_rowspan_ref
    print "HAS_DELIM_CONST=" has_delim_const
    print "HAS_PERIOD_TEMPLATE_REF=" has_period_template_ref
    print "HAS_LISTINGS_TEMPLATE_REF=" has_listings_template_ref
    print "HAS_RETURN=" has_return
}
