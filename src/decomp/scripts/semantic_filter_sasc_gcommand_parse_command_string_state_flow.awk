BEGIN {
    h_entry = 0
    h_defaults = 0
    h_empty_guard = 0
    h_prefix_parse = 0
    h_digit_pair_parse = 0
    h_pen_parse = 0
    h_hex_parse = 0
    h_fold_upper = 0
    h_enable_flag = 0
    h_mode_cycle = 0
    h_search_row_limit = 0
    h_clock_offset = 0
    h_message_text_pen = 0
    h_message_frame_pen = 0
    h_editor_layout_pen = 0
    h_editor_row_pen = 0
    h_detail_layout_pen = 0
    h_detail_initial_line = 0
    h_detail_row_pen = 0
    h_workflow_mode = 0
    h_detail_flag = 0
    h_tail_find = 0
    h_tail_split_nul = 0
    h_tail_clamp = 0
    h_at_template_replace = 0
    h_listings_template_replace = 0
    h_tail_fallback_replace = 0
    h_suffix_search = 0
    h_suffix_patch = 0
    h_load_file = 0
    h_rts = 0

    seed_seen = 0
    seed_copy_count = 0
    parse_long_count = 0
    digit_guard_count = 0
    parse_pen_count = 0
    parse_hex_count = 0
    fold_upper_count = 0
    tail_delim_seen = 0
    tail_find_seen = 0
    replace_seen = 0
    at_template_store_count = 0
    listings_template_store_count = 0
    suffix_fmt_seen = 0
    suffix_find_seen = 0
    prev = ""
    prev2 = ""
    prev3 = ""
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") {
        next
    }

    if (l ~ /^GCOMMAND_PARSECOMMANDSTRING:/ || l ~ /^GCOMMAND_PARSECOMMANDSTRING[A-Z0-9_]*:/) {
        h_entry = 1
    }

    if (l ~ /GCOMMAND_MPLEXPARSESCRATCHSEEDWORD/) {
        seed_seen = 1
    }
    if ((l ~ /^MOVE\.B / && l ~ /\(A0\)\+/ && l ~ /\(A1\)\+/) ||
        (seed_seen && l ~ /MOVE\.B D0,\$3[0-3]\(A7\)/)) {
        seed_copy_count++
    }
    if ((seed_seen && seed_copy_count >= 4) || l ~ /FLIB2_LOADDIGITALMPLEXDEFAULTS/) {
        h_defaults = 1
    }

    if ((l ~ /^MOVE\.L A[35],D0$/ || l ~ /^TST\.B \(A[35]\)$/) &&
        prev ~ /FLIB2_LOADDIGITALMPLEXDEFAULTS/) {
        h_empty_guard = 1
    }
    if (l ~ /BEQ\.[A-Z]* .*RETURN/ || l ~ /BEQ\.[A-Z]* .*__3/ || l ~ /GCOMMAND_LOADMPLEXFILE/) {
        if (prev ~ /^MOVE\.L A[35],D0$/ || prev2 ~ /^MOVE\.L A[35],D0$/ ||
            prev ~ /^TST\.B \(A[35]\)$/ || prev2 ~ /^TST\.B \(A[35]\)$/) {
            h_empty_guard = 1
        }
    }

    if (l ~ /STRING_COPYPADNUL/) {
        h_prefix_parse = 1
    }
    if (l ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || l ~ /PARSE_READSIGNEDLONGSKIPCLASS3_A/) {
        parse_long_count++
    }
    if (l ~ /IS_DECIMAL_DIGIT_CLASS/ || l ~ /WDISP_CHARCLASSTABLE/) {
        digit_guard_count++
    }
    if (l ~ /PARSE_PEN_1_TO_3/) {
        parse_pen_count++
    }
    if (l ~ /LADFUNC_PARSEHEXDIGIT/) {
        parse_hex_count++
    }
    if (l ~ /FOLD_UPPER_IF_ALPHA/) {
        fold_upper_count++
    }
    if ((l ~ /WDISP_CHARCLASSTABLE/ && (prev ~ /BTST #1/ || prev2 ~ /BTST #1/ || prev3 ~ /BTST #1/)) ||
        l ~ /BTST #1/ ||
        (l ~ /SUB\.L D1,D0/ && (prev ~ /MOVEQ #32,D1/ || prev2 ~ /MOVEQ #32,D1/ || prev3 ~ /MOVEQ #32,D1/))) {
        fold_upper_count++
    }

    if (parse_long_count >= 3 && digit_guard_count >= 4) {
        h_digit_pair_parse = 1
    }
    if (parse_pen_count >= 4 ||
        (h_message_text_pen && h_editor_layout_pen && h_detail_layout_pen && h_detail_initial_line)) {
        h_pen_parse = 1
    }
    if (parse_hex_count >= 3) {
        h_hex_parse = 1
    }
    if (fold_upper_count >= 3 ||
        (h_enable_flag && h_workflow_mode && h_detail_flag)) {
        h_fold_upper = 1
    }

    if (l ~ /GCOMMAND_DIGITALMPLEXENABLEDFLAG/ || l ~ /GCOMMAND_DIGITALMPLEXENABLED/) {
        h_enable_flag = 1
    }
    if (l ~ /GCOMMAND_MPLEXMODECYCLECOUNT/ || l ~ /GCOMMAND_MPLEXMODECYCLEC/) {
        h_mode_cycle = 1
    }
    if (l ~ /GCOMMAND_MPLEXSEARCHROWLIMIT/ || l ~ /GCOMMAND_MPLEXSEARCHROWL/) {
        h_search_row_limit = 1
    }
    if (l ~ /GCOMMAND_MPLEXCLOCKOFFSETMINUTES/ || l ~ /GCOMMAND_MPLEXCLOCKOFFSETM/) {
        h_clock_offset = 1
    }
    if (l ~ /GCOMMAND_MPLEXMESSAGETEXTPEN/ || l ~ /GCOMMAND_MPLEXMESSAGETEXTP/) {
        h_message_text_pen = 1
    }
    if (l ~ /GCOMMAND_MPLEXMESSAGEFRAMEPEN/ || l ~ /GCOMMAND_MPLEXMESSAGEFRAMEP/) {
        h_message_frame_pen = 1
    }
    if (l ~ /GCOMMAND_MPLEXEDITORLAYOUTPEN/ || l ~ /GCOMMAND_MPLEXEDITORLAYOUTP/) {
        h_editor_layout_pen = 1
    }
    if (l ~ /GCOMMAND_MPLEXEDITORROWPEN/ || l ~ /GCOMMAND_MPLEXEDITORROWP/) {
        h_editor_row_pen = 1
    }
    if (l ~ /GCOMMAND_MPLEXDETAILLAYOUTPEN/ || l ~ /GCOMMAND_MPLEXDETAILLAYOUTP/) {
        h_detail_layout_pen = 1
    }
    if (l ~ /GCOMMAND_MPLEXDETAILINITIALLINEINDEX/ || l ~ /GCOMMAND_MPLEXDETAILINITIALLINE/) {
        h_detail_initial_line = 1
    }
    if (l ~ /GCOMMAND_MPLEXDETAILROWPEN/ || l ~ /GCOMMAND_MPLEXDETAILROWP/) {
        h_detail_row_pen = 1
    }
    if (l ~ /GCOMMAND_MPLEXWORKFLOWMODE/ || l ~ /GCOMMAND_MPLEXWORKFLOWMO/) {
        h_workflow_mode = 1
    }
    if (l ~ /GCOMMAND_MPLEXDETAILLAYOUTFLAG/ || l ~ /GCOMMAND_MPLEXDETAILLAYOUTF/) {
        h_detail_flag = 1
    }

    if (l ~ /#\$12/ || l ~ /#18/ || l ~ /\(\$12\)\.W/ || l ~ /\(18\)\.W/ ||
        l ~ /MOVE\.B #\$12,-19\(A5\)/) {
        tail_delim_seen = 1
    }
    if (l ~ /STR_FINDCHARPTR/ || l ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/) {
        tail_find_seen = 1
    }
    if (tail_delim_seen && tail_find_seen) {
        h_tail_find = 1
    }
    if (l ~ /^CLR\.B \(A[0-7]\)\+$/) {
        h_tail_split_nul = 1
    }
    if (l ~ /CLR\.B 127\(A3,D7\.L\)/ || l ~ /CLR\.B \$7F\(A3,D7\.L\)/ ||
        l ~ /CLR\.B \$7F\(A5\)/ || l ~ /CLR\.B 127\(A5\)/ ||
        l ~ /TAIL\[127\] = 0/ || l ~ /#\$7F/ || l ~ /#127/) {
        h_tail_clamp = 1
    }

    if (l ~ /ESQPARS_REPLACEOWNEDSTRING/) {
        replace_seen = 1
    }
    if (l ~ /GCOMMAND_MPLEXATTEMPLATEPTR/ || l ~ /GCOMMAND_MPLEXATTEMPLATEP/) {
        at_template_store_count++
        if (replace_seen) {
            h_at_template_replace = 1
        }
        replace_seen = 0
    } else if (l ~ /GCOMMAND_MPLEXLISTINGSTEMPLATEPTR/ || l ~ /GCOMMAND_MPLEXLISTINGSTEMPLATEP/) {
        listings_template_store_count++
        if (replace_seen) {
            h_listings_template_replace = 1
        }
        replace_seen = 0
    }
    if (at_template_store_count >= 2) {
        h_tail_fallback_replace = 1
    }

    if (l ~ /GCOMMAND_FMT_PCT_T_MPLEXTEMPLATE/) {
        suffix_fmt_seen = 1
    }
    if (l ~ /ESQ_FINDSUBSTRINGCASEFOLD/ || l ~ /GROUP_AS_JMPTBL_ESQ_FINDSUBSTRINGCASEFOLD/) {
        suffix_find_seen = 1
    }
    if (suffix_fmt_seen && suffix_find_seen) {
        h_suffix_search = 1
    }
    if (l ~ /MOVE\.B #\$73,\(A[0-7]\)/ || l ~ /MOVE\.B #115,\(A[0-7]\)/ ||
        l ~ /MOVE\.B #\$73,1\(A[0-7]\)/ || l ~ /MOVE\.B #115,1\(A[0-7]\)/ ||
        l ~ /MOVE\.B #\$73,\$1\(A[0-7]\)/ || l ~ /MOVE\.B #115,\$1\(A[0-7]\)/) {
        h_suffix_patch = 1
    }

    if (l ~ /GCOMMAND_LOADMPLEXFILE/) {
        h_load_file = 1
    }
    if (l == "RTS") {
        h_rts = 1
    }

    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_DEFAULTS_RESET=" h_defaults
    print "HAS_EMPTY_GUARD=" h_empty_guard
    print "HAS_PREFIX_PARSE=" h_prefix_parse
    print "HAS_DIGIT_PAIR_PARSE=" h_digit_pair_parse
    print "HAS_PEN_PARSE=" h_pen_parse
    print "HAS_HEX_PARSE=" h_hex_parse
    print "HAS_FOLD_UPPER=" h_fold_upper
    print "HAS_ENABLE_FLAG_STORE=" h_enable_flag
    print "HAS_MODE_CYCLE_STORE=" h_mode_cycle
    print "HAS_SEARCH_ROW_LIMIT_STORE=" h_search_row_limit
    print "HAS_CLOCK_OFFSET_STORE=" h_clock_offset
    print "HAS_MESSAGE_TEXT_PEN_STORE=" h_message_text_pen
    print "HAS_MESSAGE_FRAME_PEN_STORE=" h_message_frame_pen
    print "HAS_EDITOR_LAYOUT_PEN_STORE=" h_editor_layout_pen
    print "HAS_EDITOR_ROW_PEN_STORE=" h_editor_row_pen
    print "HAS_DETAIL_LAYOUT_PEN_STORE=" h_detail_layout_pen
    print "HAS_DETAIL_INITIAL_LINE_STORE=" h_detail_initial_line
    print "HAS_DETAIL_ROW_PEN_STORE=" h_detail_row_pen
    print "HAS_WORKFLOW_MODE_STORE=" h_workflow_mode
    print "HAS_DETAIL_FLAG_STORE=" h_detail_flag
    print "HAS_TAIL_FIND=" h_tail_find
    print "HAS_TAIL_SPLIT_NUL=" h_tail_split_nul
    print "HAS_TAIL_CLAMP=" h_tail_clamp
    print "HAS_AT_TEMPLATE_REPLACE=" h_at_template_replace
    print "HAS_LISTINGS_TEMPLATE_REPLACE=" h_listings_template_replace
    print "HAS_TAIL_FALLBACK_REPLACE=" h_tail_fallback_replace
    print "HAS_SUFFIX_SEARCH=" h_suffix_search
    print "HAS_SUFFIX_PATCH=" h_suffix_patch
    print "HAS_LOAD_FILE_CALL=" h_load_file
    print "HAS_RTS=" h_rts
}
