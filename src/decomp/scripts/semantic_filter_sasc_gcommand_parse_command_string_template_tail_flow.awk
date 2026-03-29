BEGIN {
    h_entry = 0
    h_default_reset = 0
    h_prefix_parse = 0
    h_workflow_flag = 0
    h_detail_flag = 0
    h_tail_split_search = 0
    h_tail_clamp = 0
    h_at_template_replace = 0
    h_listings_template_replace = 0
    h_suffix_search = 0
    h_suffix_patch = 0
    h_load_mplex_file = 0
    h_rts = 0

    saw_seed_symbol = 0
    seed_copy_count = 0
    saw_workflow_store = 0
    saw_detail_store = 0
    saw_tail_delim = 0
    saw_tail_find = 0
    saw_at_slot = 0
    saw_listings_slot = 0
    saw_replace_call = 0
    saw_suffix_fmt = 0
    saw_suffix_find = 0
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
        saw_seed_symbol = 1
    }
    if (l ~ /^MOVE\.B / && l ~ /\(A0\)\+/ && l ~ /\(A1\)\+/) {
        seed_copy_count++
    }
    if ((saw_seed_symbol && seed_copy_count >= 4) || l ~ /FLIB2_LOADDIGITALMPLEXDEFAULTS/) {
        h_default_reset = 1
    }

    if (l ~ /STRING_COPYPADNUL/ || l ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/) {
        h_prefix_parse = 1
    }

    if (l ~ /#70,D[0-7]/ || l ~ /#66,D[0-7]/ || l ~ /#76,D[0-7]/ || l ~ /#78,D[0-7]/ ||
        l ~ /#\$46,D[0-7]/ || l ~ /#\$42,D[0-7]/ || l ~ /#\$4C,D[0-7]/ || l ~ /#\$4E,D[0-7]/) {
        saw_workflow_store = 1
    }
    if (saw_workflow_store && l ~ /GCOMMAND_MPLEXWORKFLOWMO/) {
        h_workflow_flag = 1
    }

    if (l ~ /#89,D[0-7]/ || l ~ /#78,D[0-7]/ || l ~ /#\$59,D[0-7]/ || l ~ /#\$4E,D[0-7]/) {
        saw_detail_store = 1
    }
    if (saw_detail_store && l ~ /GCOMMAND_MPLEXDETAILLAYOUTFLA/) {
        h_detail_flag = 1
    }

    if (l ~ /MOVE\.B #\$12/ || l ~ /MOVE\.B #18/ || l ~ /#\$12,-19\(A5\)/ ||
        l ~ /\(\$12\)\.W/ || l ~ /\(18\)\.W/ ||
        l ~ /STR_FINDCHARPTR/ || l ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/) {
        if (l ~ /#\$12/ || l ~ /#18/ || l ~ /-19\(A5\)/ ||
            l ~ /\(\$12\)\.W/ || l ~ /\(18\)\.W/) {
            saw_tail_delim = 1
        }
        if (l ~ /STR_FINDCHARPTR/ || l ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/) {
            saw_tail_find = 1
        }
    }
    if (saw_tail_delim && saw_tail_find) {
        h_tail_split_search = 1
    }

    if (l ~ /#127,D[0-7]/ || l ~ /#\$7F,D[0-7]/ ||
        l ~ /CLR\.B 127\(/ || l ~ /CLR\.B \$7F\(/ || l ~ /\[127\] = 0/) {
        h_tail_clamp = 1
    }

    if (l ~ /GCOMMAND_MPLEXATTEMPLATEPTR/) {
        saw_at_slot = 1
    }
    if (l ~ /GCOMMAND_MPLEXLISTINGSTEMPLATEP/ || l ~ /GCOMMAND_MPLEXLISTINGSTEMPLATEPT/) {
        saw_listings_slot = 1
    }
    if (l ~ /ESQPARS_REPLACEOWNEDSTRING/) {
        saw_replace_call = 1
    }
    if (saw_at_slot && saw_replace_call) {
        h_at_template_replace = 1
    }
    if (saw_listings_slot && saw_replace_call) {
        h_listings_template_replace = 1
    }

    if (l ~ /GCOMMAND_FMT_PCT_T_MPLEXTEMPLATE/) {
        saw_suffix_fmt = 1
    }
    if (l ~ /ESQ_FINDSUBSTRINGCASEFOLD/ || l ~ /GROUP_AS_JMPTBL_ESQ_FINDSUBSTRINGCASEFOLD/) {
        saw_suffix_find = 1
    }
    if (saw_suffix_fmt && saw_suffix_find) {
        h_suffix_search = 1
    }

    if (l ~ /MOVE\.B #\$73,1\(A0\)/ || l ~ /FMTSLOT\[1\] = '\''S'\''/ ||
        l ~ /FMTSLOT\[1\] = 'S'/) {
        h_suffix_patch = 1
    }

    if (l ~ /GCOMMAND_LOADMPLEXFILE/) {
        h_load_mplex_file = 1
    }

    if (l == "RTS") {
        h_rts = 1
    }
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_DEFAULT_RESET=" h_default_reset
    print "HAS_PREFIX_PARSE=" h_prefix_parse
    print "HAS_WORKFLOW_FLAG=" h_workflow_flag
    print "HAS_DETAIL_FLAG=" h_detail_flag
    print "HAS_TAIL_SPLIT_SEARCH=" h_tail_split_search
    print "HAS_TAIL_CLAMP=" h_tail_clamp
    print "HAS_AT_TEMPLATE_REPLACE=" h_at_template_replace
    print "HAS_LISTINGS_TEMPLATE_REPLACE=" h_listings_template_replace
    print "HAS_SUFFIX_SEARCH=" h_suffix_search
    print "HAS_SUFFIX_PATCH=" h_suffix_patch
    print "HAS_LOAD_MPLEX_FILE=" h_load_mplex_file
    print "HAS_RTS=" h_rts
}
