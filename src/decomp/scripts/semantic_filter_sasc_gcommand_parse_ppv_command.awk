BEGIN {
    has_entry = 0
    has_defaults = 0
    has_seed_ref = 0
    copy_pad_count = 0
    parse_long_count = 0
    digit_guard_count = 0
    parse_hex_count = 0
    has_find_char = 0
    has_empty_cmd_guard = 0
    has_split_nul = 0
    has_tail_clamp_write = 0
    replace_owned_count = 0
    has_load_ppv_template = 0
    has_delim_12 = 0
    has_truncate_127 = 0
    pending_replace_owned = 0
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
    if (u ~ /^(XREF|XDEF) / || u == "END") next

    if (u ~ /^GCOMMAND_PARSEPPVCOMMAND[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "FLIB2_LOADDIGITALPPVDEFAULTS") > 0) has_defaults = 1
    if (index(u, "GCOMMAND_PPVPARSESCRATCHSEEDLONG") > 0) has_seed_ref = 1
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 ||
        index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0 ||
        index(u, "STRING_COPYPADNUL") > 0 ||
        index(u, "STRING_COPYPAD") > 0) copy_pad_count++
    if (index(u, "ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
        index(u, "ESQPARS_JMPTBL_PARSE_READSIGNE") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_A") > 0 ||
        index(u, "PARSE_READSIGNEDLONGSKIPCL") > 0 ||
        index(u, "PARSE_VALID_DIGITS_VALUE") > 0) parse_long_count++

    if (index(u, "WDISP_CHARCLASSTABLE") > 0 || index(u, "PARSE_VALID_DIGITS_VALUE") > 0) digit_guard_count++
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) parse_hex_count++

    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 ||
        index(u, "GROUP_AS_JMPTBL_STR_FINDCHARP") > 0 ||
        index(u, "STR_FINDCHARPTR") > 0 ||
        index(u, "STR_FINDCHARP") > 0) {
        has_find_char = 1
        print "FIND_TEMPLATE_SPLIT"
    }
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) {
        replace_owned_count++
        pending_replace_owned = 1
    }
    if (index(u, "GCOMMAND_LOADPPVTEMPLATE") > 0) has_load_ppv_template = 1
    if (index(u, "#$12") > 0 || index(u, "($12).W") > 0 || index(u, "#18") > 0) has_delim_12 = 1
    if (index(u, "#$7F") > 0 || index(u, "#127") > 0 || index(u, "$7F(") > 0 || index(u, "127(") > 0) has_truncate_127 = 1
    if (copy_pad_count == 0 && (u ~ /^TST\.B \(A[035]\)$/ || u ~ /^TST\.B \(A0\)$/)) has_empty_cmd_guard = 1
    if (u ~ /^CLR\.B \(A[0-7]\)\+$/) has_split_nul = 1
    if (u ~ /^CLR\.B (\$7F|127)\(A[0-7](,D[0-7]\.L)?\)$/) has_tail_clamp_write = 1

    if (index(u, "GCOMMAND_DIGITALPPVENABLEDFLAG") > 0 || index(u, "GCOMMAND_DIGITALPPVENABL") > 0) print "STORE_ENABLE_FLAG"
    if (index(u, "GCOMMAND_PPVMODECYCLECOUNT") > 0 || index(u, "GCOMMAND_PPVMODECYCLEC") > 0) print "STORE_MODE_CYCLE_COUNT"
    if (index(u, "GCOMMAND_PPVSELECTIONWINDOWMINUTES") > 0 || index(u, "GCOMMAND_PPVSELECTIONWINDOWMINUT") > 0) print "STORE_SELECTION_WINDOW"
    if (index(u, "GCOMMAND_PPVSELECTIONTOLERANCEMINUTES") > 0 || index(u, "GCOMMAND_PPVSELECTIONTOLERANCEMI") > 0) print "STORE_SELECTION_TOLERANCE"
    if (index(u, "GCOMMAND_PPVMESSAGETEXTPEN") > 0 || index(u, "GCOMMAND_PPVMESSAGETEXTP") > 0) print "STORE_MESSAGE_TEXT_PEN"
    if (index(u, "GCOMMAND_PPVMESSAGEFRAMEPEN") > 0 || index(u, "GCOMMAND_PPVMESSAGEFRAMEP") > 0) print "STORE_MESSAGE_FRAME_PEN"
    if (index(u, "GCOMMAND_PPVEDITORLAYOUTPEN") > 0 || index(u, "GCOMMAND_PPVEDITORLAYOUTP") > 0) print "STORE_EDITOR_LAYOUT_PEN"
    if (index(u, "GCOMMAND_PPVEDITORROWPEN") > 0 || index(u, "GCOMMAND_PPVEDITORROWP") > 0) print "STORE_EDITOR_ROW_PEN"
    if (index(u, "GCOMMAND_PPVSHOWTIMESLAYOUTPEN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESLAYOUTP") > 0) print "STORE_SHOWTIMES_LAYOUT_PEN"
    if (index(u, "GCOMMAND_PPVSHOWTIMESINITIALLINEINDEX") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESINITIALLINE") > 0) print "STORE_SHOWTIMES_INITIAL_LINE"
    if (index(u, "GCOMMAND_PPVSHOWTIMESROWPEN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESROWP") > 0) print "STORE_SHOWTIMES_ROW_PEN"
    if (index(u, "GCOMMAND_PPVSHOWTIMESWORKFLOWMODE") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESWORKF") > 0) print "STORE_WORKFLOW_MODE"
    if (index(u, "GCOMMAND_PPVDETAILLAYOUTFLAG") > 0 || index(u, "GCOMMAND_PPVDETAILLAYOUTF") > 0) print "STORE_DETAIL_LAYOUT_FLAG"
    if (index(u, "GCOMMAND_PPVSHOWTIMESROWSPAN") > 0 || index(u, "GCOMMAND_PPVSHOWTIMESROWS") > 0) print "STORE_SHOWTIMES_ROWSPAN"
    if (pending_replace_owned) {
        if (index(u, "GCOMMAND_PPVLISTINGSTEMPLATEPTR") > 0 || index(u, "GCOMMAND_PPVLISTINGSTEMPL") > 0) {
            print "STORE_LISTINGS_TEMPLATE"
            pending_replace_owned = 0
        } else if (index(u, "GCOMMAND_PPVPERIODTEMPLATEPTR") > 0 || index(u, "GCOMMAND_PPVPERIODTEMPL") > 0) {
            print "STORE_PERIOD_TEMPLATE"
            pending_replace_owned = 0
        }
    }

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_SEED_REF=" has_seed_ref
    print "HAS_COPY_PAD=" (copy_pad_count >= 2)
    print "HAS_PARSE_LONG=" (parse_long_count >= 4)
    print "HAS_DIGIT_CLASS_GUARDS=" (digit_guard_count >= 2)
    print "HAS_PARSE_HEX=" (parse_hex_count >= 3)
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_EMPTY_CMD_GUARD=" has_empty_cmd_guard
    print "HAS_SPLIT_NUL=" has_split_nul
    print "HAS_TAIL_CLAMP_WRITE=" has_tail_clamp_write
    print "HAS_REPLACE_OWNED=" (replace_owned_count >= 3)
    print "HAS_LOAD_PPV_TEMPLATE=" has_load_ppv_template
    print "HAS_DELIM_12=" has_delim_12
    print "HAS_TRUNCATE_127=" has_truncate_127
    print "HAS_RETURN=" has_return
}
