BEGIN {
    has_entry = 0
    has_defaults = 0
    has_copy_pad = 0
    has_parse_long = 0
    has_charclass_ref = 0
    has_parse_hex = 0
    has_find_char = 0
    has_replace_owned = 0
    has_load_ppv_template = 0
    has_workflow_ref = 0
    has_detail_flag_ref = 0
    has_rowspan_ref = 0
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
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0) has_copy_pad = 1
    if (index(u, "ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(u, "ESQPARS_JMPTBL_PARSE_READSIGNE") > 0) has_parse_long = 1

    if (index(u, "WDISP_CHARCLASSTABLE") > 0) has_charclass_ref = 1
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) has_parse_hex = 1

    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHARP") > 0) has_find_char = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) has_replace_owned = 1
    if (index(u, "GCOMMAND_LOADPPVTEMPLATE") > 0) has_load_ppv_template = 1

    if (index(u, "GCOMMAND_PPVSHOWTIMESWORKFLOWMODE") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESWORKF") > 0) has_workflow_ref = 1
    if (index(u, "GCOMMAND_PPVDETAILLAYOUTFLAG") > 0 || index(u, "GCOMMAND_PPVDETAILLAYOUTF") > 0) has_detail_flag_ref = 1
    if (index(u, "GCOMMAND_PPVSHOWTIMESROWSPAN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESROWS") > 0) has_rowspan_ref = 1

    if (index(u, "GCOMMAND_PPVPERIODTEMPLATEPTR") > 0 || index(u, "GCOMMAND_PPVPERIODTEMPL") > 0) has_period_template_ref = 1
    if (index(u, "GCOMMAND_PPVLISTINGSTEMPLATEPTR") > 0 || index(u, "GCOMMAND_PPVLISTINGSTEMPL") > 0) has_listings_template_ref = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_COPY_PAD=" has_copy_pad
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_CHARCLASS_REF=" has_charclass_ref
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_LOAD_PPV_TEMPLATE=" has_load_ppv_template
    print "HAS_WORKFLOW_REF=" has_workflow_ref
    print "HAS_DETAIL_FLAG_REF=" has_detail_flag_ref
    print "HAS_ROWSPAN_REF=" has_rowspan_ref
    print "HAS_PERIOD_TEMPLATE_REF=" has_period_template_ref
    print "HAS_LISTINGS_TEMPLATE_REF=" has_listings_template_ref
    print "HAS_RETURN=" has_return
}
