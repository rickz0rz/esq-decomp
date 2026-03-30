BEGIN {
    has_label = 0
    has_slot_init_loop = 0
    count_escape_calls = 0
    token_map_calls = 0
    wildcard_calls = 0
    select_entry_ops = 0
    pending_secondary_ops = 0
    pending_primary_ops = 0
    clear_anim_calls = 0
    free_subentries_calls = 0
    replace_owned_calls = 0
    format_tokens_calls = 0
    parse_signed_calls = 0
    alloc_sub_calls = 0
    merge_loop_ops = 0
    missing_title_fallback = 0
    null_owned_replace_present = 0
    entry_length_scan_present = 0
    subentry_text_fallback_a = 0
    subentry_text_fallback_b = 0
    subentry_numeric_fallback = 0
    copy_anim_calls = 0
    write_oi_calls = 0
    return_code_0 = 0
    return_code_1 = 0
    return_code_2 = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_PARSEALIGNEDLISTINGBLOCK[A-Z0-9_]*:/) has_label = 1
    if (u ~ /INIT_SLOT_TABLE_LOOP/ || u ~ /MOVE.W #\(-1\)/ || u ~ /MOVE.W #\$FFFFFFFF/ || u ~ /DBF/) has_slot_init_loop = 1
    if (u ~ /COI_COUNTESCAPE14BEFORENULL/) count_escape_calls += 1
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKE/ || u ~ /SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /SCRIPT_BUILDTOKENIND/) token_map_calls += 1
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) wildcard_calls += 1
    if (u ~ /CLEANUP_SELECTENTRY/ || u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/ || u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) select_entry_ops += 1
    if (u ~ /CTASKS_PENDINGSECONDARYOIDISKID/ || u ~ /CTASKS_SECONDARYOIWRITEPENDINGFL/) pending_secondary_ops += 1
    if (u ~ /CTASKS_PENDINGPRIMARYOIDISKID/ || u ~ /CTASKS_PRIMARYOIWRITEPENDINGFLAG/) pending_primary_ops += 1
    if (u ~ /COI_CLEARANIMOBJECTSTRINGS/) clear_anim_calls += 1
    if (u ~ /COI_FREESUBENTRYTABLEENTRIES/ || u ~ /COI_FREESUBENTRYTABLENTRIES/) free_subentries_calls += 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ || u ~ /ESQPARS_REPLACEOWNEDSTRING/ || u ~ /ESQPARS_REPLACEOWNEDST/) replace_owned_calls += 1
    if (u ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/) format_tokens_calls += 1
    if (u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLAS/ || u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNED/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_A/ || u ~ /PARSE_READSIGNEDLONGSKIPCL/) parse_signed_calls += 1
    if (u ~ /COI_ALLOCSUBENTRYTABLE/) alloc_sub_calls += 1
    if (u ~ /SUBENTRYCOUNT/ || u ~ /SUBENTRYTABLE/ || u ~ /MERGE_SUBENTRY_LOOP/ || u ~ /SUBENTRY_LOOP/ || u ~ /26\(A[01]\)/) merge_loop_ops += 1
    if (u ~ /CLOCK_STR_MISSING_TITLE_TEMPLATE/) missing_title_fallback = 1
    if (u ~ /CLR\.L -\(A7\)/ || u ~ /CLR\.L \(A7\)/) null_owned_replace_present = 1
    if (u ~ /CLEANUP_STRINGLENGTH/ || u ~ /COUNT_ENTRY_TEXT_LOOP/ || u ~ /SUBA\.L 16\(A1\),A0/) entry_length_scan_present = 1
    if (u ~ /\$18\(A2\)/ || u ~ /24\(A1\)/) subentry_text_fallback_a = 1
    if (u ~ /\$1C\(A2\)/ || u ~ /28\(A1\)/) subentry_text_fallback_b = 1
    if (u ~ /MOVE\.L \$20\(A2\),\$1A\(A0\)/ || u ~ /MOVE\.L 32\(A0\),26\(A1\)/) subentry_numeric_fallback = 1
    if (u ~ /CLEANUP_COPYANIMOBJECT/ || u ~ /MOVE\.B \(A0\),\(A1\)/) copy_anim_calls += 1
    if (u ~ /COI_WRITEOIDATAFILE/) write_oi_calls += 1
    if (u ~ /MOVEQ(\.L)? #\$?0,D0/ || u ~ /MOVEQ #0,D0/) return_code_0 = 1
    if (u ~ /MOVEQ(\.L)? #\$?1,D0/ || u ~ /MOVEQ #1,D0/) return_code_1 = 1
    if (u ~ /MOVEQ(\.L)? #\$?2,D0/ || u ~ /MOVEQ #2,D0/) return_code_2 = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SLOT_INIT_LOOP=" has_slot_init_loop
    print "COUNT_ESCAPE_CALLS_GE1=" (count_escape_calls >= 1)
    print "TOKEN_MAP_CALLS_GE2=" (token_map_calls >= 2)
    print "WILDCARD_CALLS_GE1=" (wildcard_calls >= 1)
    print "SELECT_ENTRY_OPS_GE3=" (select_entry_ops >= 3)
    print "PENDING_SECONDARY_OPS_GE1=" (pending_secondary_ops >= 1)
    print "PENDING_PRIMARY_OPS_GE1=" (pending_primary_ops >= 1)
    print "CLEAR_ANIM_CALLS_GE2=" (clear_anim_calls >= 2)
    print "FREE_SUBENTRIES_CALLS_GE2=" (free_subentries_calls >= 2)
    print "REPLACE_OWNED_CALLS_GE12=" (replace_owned_calls >= 12)
    print "FORMAT_TOKENS_CALLS_GE2=" (format_tokens_calls >= 2)
    print "PARSE_SIGNED_CALLS_GE2=" (parse_signed_calls >= 2)
    print "ALLOC_SUB_CALLS_GE2=" (alloc_sub_calls >= 2)
    print "MERGE_LOOP_OPS_GE4=" (merge_loop_ops >= 4)
    print "MISSING_TITLE_FALLBACK=" missing_title_fallback
    print "NULL_OWNED_REPLACE_PRESENT=" null_owned_replace_present
    print "ENTRY_LENGTH_SCAN_PRESENT=" entry_length_scan_present
    print "SUBENTRY_TEXT_FALLBACK_PRESENT=" (subentry_text_fallback_a && subentry_text_fallback_b)
    print "SUBENTRY_NUMERIC_FALLBACK_PRESENT=" subentry_numeric_fallback
    print "COPY_ANIM_CALLS_GE1=" (copy_anim_calls >= 1)
    print "WRITE_OI_CALLS_EQ0=" (write_oi_calls == 0)
    print "RETURN_CODE_0_PRESENT=" return_code_0
    print "RETURN_CODE_1_PRESENT=" return_code_1
    print "RETURN_CODE_2_PRESENT=" return_code_2
    print "HAS_RETURN=" has_return
}
