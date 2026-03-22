BEGIN {
    has_entry = 0
    has_defaults = 0
    copy_pad_count = 0
    parse_long_count = 0
    digit_guard_count = 0
    parse_hex_count = 0
    has_find_char = 0
    has_find_substring = 0
    replace_owned_count = 0
    has_load_mplex_file = 0
    has_workflow_ref = 0
    has_detail_flag_ref = 0
    has_at_template_ref = 0
    has_listings_template_ref = 0
    has_suffix_s = 0
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

    if (u ~ /^GCOMMAND_PARSECOMMANDSTRING[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "FLIB2_LOADDIGITALMPLEXDEFAULTS") > 0) has_defaults = 1
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0 || index(u, "STRING_COPYPADNUL") > 0 || index(u, "STRING_COPYPAD") > 0) copy_pad_count++
    if (index(u, "ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
        index(u, "ESQPARS_JMPTBL_PARSE_READSIGNE") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_A") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCL") > 0) parse_long_count++

    if (index(u, "WDISP_CHARCLASSTABLE") > 0 || index(u, "IS_DECIMAL_DIGIT_CLASS") > 0) digit_guard_count++
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) parse_hex_count++

    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHARP") > 0 || index(u, "STR_FINDCHARPTR") > 0 || index(u, "STR_FINDCHARP") > 0) has_find_char = 1
    if (index(u, "GROUP_AS_JMPTBL_ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "GROUP_AS_JMPTBL_ESQ_FINDSUBSTRI") > 0 || index(u, "ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "ESQ_FINDSUBSTRI") > 0) has_find_substring = 1

    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) replace_owned_count++
    if (index(u, "GCOMMAND_LOADMPLEXFILE") > 0) has_load_mplex_file = 1

    if (index(u, "GCOMMAND_MPLEXWORKFLOWMODE") > 0) has_workflow_ref = 1
    if (index(u, "GCOMMAND_MPLEXDETAILLAYOUTFLAG") > 0) has_detail_flag_ref = 1
    if (index(u, "GCOMMAND_MPLEXATTEMPLATEPTR") > 0 || index(u, "GCOMMAND_MPLEXATTEMPL") > 0) has_at_template_ref = 1
    if (index(u, "GCOMMAND_MPLEXLISTINGSTEMPLATEPTR") > 0 || index(u, "GCOMMAND_MPLEXLISTINGSTEMPL") > 0) has_listings_template_ref = 1

    if (u ~ /^MOVE\.B #\$73,\(A[0-7]\)$/ || u ~ /^MOVE\.B #115,\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$73,1\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$73,\$1\(A[0-7]\)$/ || u ~ /^MOVE\.B #115,1\(A[0-7]\)$/) has_suffix_s = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_COPY_PAD=" (copy_pad_count >= 1)
    print "HAS_PARSE_LONG=" (parse_long_count >= 3)
    print "HAS_DIGIT_CLASS_GUARDS=" (digit_guard_count >= 8)
    print "HAS_PARSE_HEX=" (parse_hex_count >= 3)
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_FIND_SUBSTRING=" has_find_substring
    print "HAS_REPLACE_OWNED=" (replace_owned_count >= 1)
    print "HAS_LOAD_MPLEX_FILE=" has_load_mplex_file
    print "HAS_WORKFLOW_REF=" has_workflow_ref
    print "HAS_DETAIL_FLAG_REF=" has_detail_flag_ref
    print "HAS_AT_TEMPLATE_REF=" has_at_template_ref
    print "HAS_LISTINGS_TEMPLATE_REF=" has_listings_template_ref
    print "HAS_SUFFIX_S=" has_suffix_s
    print "HAS_RETURN=" has_return
}
