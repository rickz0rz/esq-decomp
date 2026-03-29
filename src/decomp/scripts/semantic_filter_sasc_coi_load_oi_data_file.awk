BEGIN {
    has_label = 0
    has_div_call = 0
    has_div_remainder_store = 0
    has_load_call = 0
    sprintf_call_count = 0
    has_path_index_arg = 0
    has_header_tab_scan = 0
    has_seen_flag_clear_loop = 0
    secondary_group_code_refs = 0
    secondary_group_present_refs = 0
    secondary_group_entry_count_refs = 0
    primary_group_code_refs = 0
    primary_group_entry_count_refs = 0
    secondary_entry_table_refs = 0
    primary_entry_table_refs = 0
    find_char_call_count = 0
    parse_call_count = 0
    token_call_count = 0
    replace_call_count = 0
    format_pair_call_count = 0
    default_template_ref_count = 0
    subentry_count_format_ref_count = 0
    alloc_call_count = 0
    wildcard_call_count = 0
    dealloc_call_count = 0
    has_return = 0
    path_arg_pending = 0
}

function trim(s,t) {
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

    if (u ~ /^(XREF|XDEF|END) / || u == "END") next

    if (u ~ /^COI_LOADOIDATAFILE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/) has_div_call = 1
    if (has_div_call && u ~ /^MOVE\.W D1,/) has_div_remainder_store = 1
    if (u ~ /DISKIO_LOADFILETOWORKBUFFER/ || u ~ /DISKIO_LOADFILETOWORKBUFF/) has_load_call = 1
    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || u ~ /WDISP_SPRINTF\(/ || u ~ /BSR\.W WDISP_SPRINTF/) sprintf_call_count++
    if (u ~ /^MOVE\.L D1,-\(A7\)$/) path_arg_pending = 3
    if (path_arg_pending > 0 &&
        (u ~ /GLOBAL_STR_DF0_OI_PERCENT_2_LX_D/ ||
         u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ ||
         u ~ /WDISP_SPRINTF\(/ || u ~ /BSR\.W WDISP_SPRINTF/)) {
        has_path_index_arg = 1
    }
    if (path_arg_pending > 0) path_arg_pending--
    if (u ~ /PEA 9\.W/ || u ~ /\(\$9\)\.W/) has_header_tab_scan = 1
    if (u ~ /MOVE\.W #\$12D,D0/ || u ~ /MOVE\.W #\$12D,\$[0-9A-F]+\([A-Z][0-9]\)/) has_seen_flag_clear_loop = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPCODE/) secondary_group_code_refs++
    if (u ~ /TEXTDISP_SECONDARYGROUPPRESENTFLAG/ || u ~ /TEXTDISP_SECONDARYGROUPPRESENTFL/) secondary_group_present_refs++
    if (u ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/ || u ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN/) secondary_group_entry_count_refs++
    if (u ~ /TEXTDISP_PRIMARYGROUPCODE/) primary_group_code_refs++
    if (u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/) primary_group_entry_count_refs++
    if (u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/ || u ~ /TEXTDISP_SECONDARYENTRYPTRTAB/) secondary_entry_table_refs++
    if (u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/ || u ~ /TEXTDISP_PRIMARYENTRYPTRTAB/) primary_entry_table_refs++
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/) find_char_call_count++
    if (u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNED/) parse_call_count++
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEX/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKE/) token_call_count++
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/) replace_call_count++
    if (u ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/ || u ~ /COI_REPLACEFORMATTEDPAIR/) format_pair_call_count++
    if (u ~ /COI_STR_DEFAULT_TOKEN_TEMPLATE_A/) default_template_ref_count++
    if (u ~ /GLOBAL_STR_PERCENT_S_1/) subentry_count_format_ref_count++
    if (u ~ /COI_ALLOCSUBENTRYTABLE/) alloc_call_count++
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) wildcard_call_count++
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) dealloc_call_count++
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_DIV_REMAINDER_STORE=" has_div_remainder_store
    print "HAS_LOAD_CALL=" has_load_call
    print "SPRINTF_CALL_COUNT=" sprintf_call_count
    print "HAS_PATH_INDEX_ARG=" has_path_index_arg
    print "HAS_HEADER_TAB_SCAN=" has_header_tab_scan
    print "HAS_SEEN_FLAG_CLEAR_LOOP=" has_seen_flag_clear_loop
    print "SECONDARY_GROUP_CODE_REFS=" secondary_group_code_refs
    print "SECONDARY_GROUP_PRESENT_REFS=" secondary_group_present_refs
    print "SECONDARY_GROUP_ENTRY_COUNT_REFS=" secondary_group_entry_count_refs
    print "PRIMARY_GROUP_CODE_REFS=" primary_group_code_refs
    print "PRIMARY_GROUP_ENTRY_COUNT_REFS=" primary_group_entry_count_refs
    print "SECONDARY_ENTRY_TABLE_REFS=" secondary_entry_table_refs
    print "PRIMARY_ENTRY_TABLE_REFS=" primary_entry_table_refs
    print "FIND_CHAR_CALL_COUNT=" find_char_call_count
    print "PARSE_CALL_COUNT=" parse_call_count
    print "TOKEN_CALL_COUNT=" token_call_count
    print "REPLACE_CALL_COUNT=" replace_call_count
    print "FORMAT_PAIR_CALL_COUNT=" format_pair_call_count
    print "DEFAULT_TEMPLATE_REF_COUNT=" default_template_ref_count
    print "SUBENTRY_COUNT_FORMAT_REF_COUNT=" subentry_count_format_ref_count
    print "ALLOC_CALL_COUNT=" alloc_call_count
    print "WILDCARD_CALL_COUNT=" wildcard_call_count
    print "DEALLOC_CALL_COUNT=" dealloc_call_count
    print "HAS_RETURN=" has_return
}
