BEGIN {
    has_entry = 0
    has_defaults = 0
    copy_pad_count = 0
    parse_long_count = 0
    digit_guard_count = 0
    parse_hex_count = 0
    has_find_char = 0
    has_find_substring = 0
    has_empty_cmd_guard = 0
    has_split_nul = 0
    has_tail_clamp_write = 0
    replace_owned_count = 0
    has_load_mplex_file = 0
    has_suffix_s = 0
    has_return = 0
    has_delim_12 = 0
    has_truncate_127 = 0
    has_percent_t_ref = 0
    pending_replace_owned = 0
    pending_split_search = 0
    split_branch_active = 0
    split_branch_seen = 0
    split_at_store_count = 0
    split_listings_store_count = 0
    fallback_at_store_count = 0
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
    if (u ~ /^(XREF|XDEF) / || u == "END") next

    if (u ~ /^GCOMMAND_PARSECOMMANDSTRING[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "FLIB2_LOADDIGITALMPLEXDEFAULTS") > 0) has_defaults = 1
    if (index(u, "GCOMMAND_LOADMPLEXFILE") > 0) has_load_mplex_file = 1
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0 || index(u, "STRING_COPYPADNUL") > 0 || index(u, "STRING_COPYPAD") > 0) copy_pad_count++
    if (index(u, "ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
        index(u, "ESQPARS_JMPTBL_PARSE_READSIGNE") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_A") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCL") > 0) parse_long_count++

    if (index(u, "WDISP_CHARCLASSTABLE") > 0 || index(u, "IS_DECIMAL_DIGIT_CLASS") > 0) digit_guard_count++
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) parse_hex_count++

    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHARP") > 0 || index(u, "STR_FINDCHARPTR") > 0 || index(u, "STR_FINDCHARP") > 0) {
        has_find_char = 1
        pending_split_search = 1
    }
    if (index(u, "GROUP_AS_JMPTBL_ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "GROUP_AS_JMPTBL_ESQ_FINDSUBSTRI") > 0 || index(u, "ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "ESQ_FINDSUBSTRI") > 0) has_find_substring = 1

    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) {
        replace_owned_count++
        pending_replace_owned = 1
    }
    if (index(u, "GCOMMAND_FMT_PCT_T_MPLEXTEMPLATE") > 0) has_percent_t_ref = 1
    if (index(u, "#$12") > 0 || index(u, "($12).W") > 0 || index(u, "#18") > 0) has_delim_12 = 1
    if (index(u, "#$7F") > 0 || index(u, "#127") > 0 || index(u, "$7F(") > 0 || index(u, "127(") > 0) has_truncate_127 = 1
    if (copy_pad_count == 0 && (u ~ /^TST\.B \(A[35]\)$/ || u ~ /^TST\.B \(A0\)$/)) has_empty_cmd_guard = 1
    if (u ~ /^CLR\.B \([AA][0-7]\)\+$/ || u ~ /^CLR\.B \(A[0-7]\)\+$/) {
        has_split_nul = 1
        if (pending_split_search) {
            print "SPLIT_BRANCH_NULL_TERM"
            split_branch_active = 1
            split_branch_seen = 1
            pending_split_search = 0
        }
    }
    if (u ~ /^CLR\.B (\$7F|127)\(A[0-7](,D[0-7]\.L)?\)$/) has_tail_clamp_write = 1

    if (u ~ /^MOVE\.B #\$73,\(A[0-7]\)$/ || u ~ /^MOVE\.B #115,\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$73,1\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$73,\$1\(A[0-7]\)$/ || u ~ /^MOVE\.B #115,1\(A[0-7]\)$/) has_suffix_s = 1

    if (index(u, "GCOMMAND_DIGITALMPLEXENABLEDFLAG") > 0) print "STORE_ENABLE_FLAG"
    if (index(u, "GCOMMAND_MPLEXMODECYCLECOUNT") > 0) print "STORE_MODE_CYCLE_COUNT"
    if (index(u, "GCOMMAND_MPLEXSEARCHROWLIMIT") > 0) print "STORE_SEARCH_ROW_LIMIT"
    if (index(u, "GCOMMAND_MPLEXCLOCKOFFSETMINUTES") > 0) print "STORE_CLOCK_OFFSET"
    if (index(u, "GCOMMAND_MPLEXMESSAGETEXTPEN") > 0) print "STORE_MESSAGE_TEXT_PEN"
    if (index(u, "GCOMMAND_MPLEXMESSAGEFRAMEPEN") > 0) print "STORE_MESSAGE_FRAME_PEN"
    if (index(u, "GCOMMAND_MPLEXEDITORLAYOUTPEN") > 0) print "STORE_EDITOR_LAYOUT_PEN"
    if (index(u, "GCOMMAND_MPLEXEDITORROWPEN") > 0) print "STORE_EDITOR_ROW_PEN"
    if (index(u, "GCOMMAND_MPLEXDETAILLAYOUTPEN") > 0) print "STORE_DETAIL_LAYOUT_PEN"
    if (index(u, "GCOMMAND_MPLEXDETAILINITIALLINEI") > 0) print "STORE_DETAIL_INITIAL_LINE"
    if (index(u, "GCOMMAND_MPLEXDETAILROWPEN") > 0) print "STORE_DETAIL_ROW_PEN"
    if (index(u, "GCOMMAND_MPLEXWORKFLOWMODE") > 0) print "STORE_WORKFLOW_MODE"
    if (index(u, "GCOMMAND_MPLEXDETAILLAYOUTFLAG") > 0) print "STORE_DETAIL_LAYOUT_FLAG"
    if (index(u, "STR_FINDCHARPTR") > 0 || index(u, "STR_FINDCHARP") > 0) print "FIND_TEMPLATE_SPLIT"
    if (pending_replace_owned) {
        if (index(u, "GCOMMAND_MPLEXLISTINGSTEMPLATEPT") > 0 || index(u, "GCOMMAND_MPLEXLISTINGSTEMPLATEPTR") > 0) {
            print "STORE_LISTINGS_TEMPLATE"
            if (split_branch_active) {
                print "STORE_LISTINGS_TEMPLATE_SPLIT"
                split_listings_store_count++
                split_branch_active = 0
            }
            pending_replace_owned = 0
        } else if (index(u, "GCOMMAND_MPLEXATTEMPLATEPT") > 0 || index(u, "GCOMMAND_MPLEXATTEMPLATEPTR") > 0) {
            print "STORE_AT_TEMPLATE"
            if (split_branch_active) {
                print "STORE_AT_TEMPLATE_SPLIT"
                split_at_store_count++
            } else {
                print "STORE_AT_TEMPLATE_FALLBACK"
                fallback_at_store_count++
            }
            pending_replace_owned = 0
        }
    }
    if (index(u, "ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "ESQ_FINDSUBSTRI") > 0) print "FIND_PERCENT_T_TOKEN"
    if (u ~ /^MOVE\.B #\$73,\(A[0-7]\)$/ || u ~ /^MOVE\.B #115,\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$73,1\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$73,\$1\(A[0-7]\)$/ || u ~ /^MOVE\.B #115,1\(A[0-7]\)$/) print "REWRITE_PERCENT_T_TO_S"

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_COPY_PAD=" (copy_pad_count >= 1)
    print "HAS_PARSE_LONG=" (parse_long_count >= 3)
    print "HAS_DIGIT_CLASS_GUARDS=" (digit_guard_count >= 4)
    print "HAS_PARSE_HEX=" (parse_hex_count >= 3)
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_FIND_SUBSTRING=" has_find_substring
    print "HAS_EMPTY_CMD_GUARD=" has_empty_cmd_guard
    print "HAS_SPLIT_NUL=" has_split_nul
    print "HAS_TAIL_CLAMP_WRITE=" has_tail_clamp_write
    print "HAS_REPLACE_OWNED=" (replace_owned_count >= 3)
    print "HAS_LOAD_MPLEX_FILE=" has_load_mplex_file
    print "HAS_DELIM_12=" has_delim_12
    print "HAS_TRUNCATE_127=" has_truncate_127
    print "HAS_PERCENT_T_REF=" has_percent_t_ref
    print "HAS_SUFFIX_S=" has_suffix_s
    print "HAS_SPLIT_BRANCH=" split_branch_seen
    print "HAS_SPLIT_AT_TEMPLATE=" (split_at_store_count >= 1)
    print "HAS_SPLIT_LISTINGS_TEMPLATE=" (split_listings_store_count >= 1)
    print "HAS_FALLBACK_AT_TEMPLATE=" (fallback_at_store_count >= 1)
    print "HAS_RETURN=" has_return
}
