BEGIN {
    label_pos = 0
    init_record_pos = 0
    init_subentry_pos = 0
    slot_init_pos = 0
    secondary_pending_pos = 0
    primary_pending_pos = 0
    escape_pos = 0
    wildcard_pos = 0
    return1_pos = 0
    return2_pos = 0
    clear_first_pos = 0
    clear_second_pos = 0
    free_first_pos = 0
    free_second_pos = 0
    replace_first_pos = 0
    title_format_pos = 0
    fallback_pos = 0
    null_replace_pos = 0
    parse_first_pos = 0
    parse_second_pos = 0
    entry_length_pos = 0
    alloc_first_pos = 0
    alloc_second_pos = 0
    subentry_text_fallback_pos = 0
    subentry_numeric_fallback_pos = 0
    merge_index_init_pos = 0
    merge_copy_pos = 0
    return0_pos = 0
    rts_pos = 0
    token_seed_count = 0
    token_call_count = 0
    format_call_count = 0
    parse_call_count = 0
    clear_call_count = 0
    free_call_count = 0
    alloc_call_count = 0
    replace_call_count = 0
    record_token_first_pos = 0
    record_token_second_pos = 0
    prev_u = ""
}

function mark_first(v) {
    if (v == 0) {
        return NR
    }
    return v
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^XREF / || u ~ /^XDEF /) {
        next
    }

    if (u ~ /^CLEANUP_PARSEALIGNEDLISTINGBLOCK[A-Z0-9_]*:/) {
        label_pos = mark_first(label_pos)
    }
    if (u ~ /CLEANUP_INITRECORDTOKENTABLE/) {
        init_record_pos = mark_first(init_record_pos)
    }
    if (u ~ /CLEANUP_INITSUBENTRYTOKENTABLE/) {
        init_subentry_pos = mark_first(init_subentry_pos)
    }
    if (slot_init_pos == 0 &&
        (u ~ /MOVE\.W #\(-1\)/ || u ~ /MOVE\.W #\$FFFFFFFF/ || u ~ /MOVE\.W #\$FFFF/)) {
        slot_init_pos = NR
    }
    if (slot_init_pos == 0 &&
        (u ~ /#22/ || u ~ /#\$16/ || u ~ /#23/ || u ~ /#\$17/ ||
         u ~ /#16/ || u ~ /#\$10/ || u ~ /#15/ || u ~ /#\$F/ ||
         u ~ /#6/ || u ~ /#\$6/ || u ~ /#20/ || u ~ /#\$14/)) {
        token_seed_count++
    }
    if (secondary_pending_pos == 0 && u ~ /CTASKS_PENDINGSECONDARYOIDISKID/) {
        secondary_pending_pos = NR
    }
    if (primary_pending_pos == 0 && u ~ /CTASKS_PENDINGPRIMARYOIDISKID/) {
        primary_pending_pos = NR
    }
    if (escape_pos == 0 &&
        (u ~ /COI_COUNTESCAPE14BEFORENULL/ || (u ~ /#49/ || u ~ /#\$31/) && NR < 120)) {
        escape_pos = NR
    }
    if (u ~ /(JSR|BSR).*SCRIPT_BUILDTOKENINDEXMAP/ ||
        u ~ /(JSR|BSR).*GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP/) {
        token_call_count++
        if (record_token_first_pos == 0) {
            record_token_first_pos = NR
        } else if (record_token_second_pos == 0) {
            record_token_second_pos = NR
        }
    }
    if (wildcard_pos == 0 && u ~ /(JSR|BSR).*ESQ_WILDCARDMATCH/) {
        wildcard_pos = NR
    }
    if (return1_pos == 0 && (u ~ /MOVEQ(\.L)? #\$?1,D0/ || u ~ /MOVEQ #1,D0/)) {
        return1_pos = NR
    }
    if (return2_pos == 0 && (u ~ /MOVEQ(\.L)? #\$?2,D0/ || u ~ /MOVEQ #2,D0/)) {
        return2_pos = NR
    }
    if (u ~ /(JSR|BSR).*COI_CLEARANIMOBJECTSTRINGS/) {
        clear_call_count++
        if (clear_first_pos == 0) {
            clear_first_pos = NR
        } else if (clear_second_pos == 0) {
            clear_second_pos = NR
        }
    }
    if (u ~ /(JSR|BSR).*COI_FREESUBENTRYTABLEENTRIES/) {
        free_call_count++
        if (free_first_pos == 0) {
            free_first_pos = NR
        } else if (free_second_pos == 0) {
            free_second_pos = NR
        }
    }
    if (u ~ /(JSR|BSR).*ESQPARS_REPLACEOWNEDSTRING/) {
        replace_call_count++
        replace_first_pos = mark_first(replace_first_pos)
    }
    if (u ~ /(JSR|BSR).*CLEANUP_FORMATENTRYSTRINGTOKENS/) {
        format_call_count++
        title_format_pos = mark_first(title_format_pos)
    }
    if (null_replace_pos == 0 && (u ~ /CLR\.L -\(A7\)/ || u ~ /CLR\.L \(A7\)/)) {
        null_replace_pos = NR
    }
    if (fallback_pos == 0 && u ~ /CLOCK_STR_MISSING_TITLE_TEMPLATE/) {
        fallback_pos = NR
    }
    if (u ~ /(JSR|BSR).*PARSE_READSIGNEDLONGSKIPCLASS3/ ||
        u ~ /(JSR|BSR).*GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3/) {
        parse_call_count++
        if (parse_first_pos == 0) {
            parse_first_pos = NR
        } else if (parse_second_pos == 0) {
            parse_second_pos = NR
        }
    }
    if (u ~ /(JSR|BSR).*COI_ALLOCSUBENTRYTABLE/) {
        alloc_call_count++
        if (alloc_first_pos == 0) {
            alloc_first_pos = NR
        } else if (alloc_second_pos == 0) {
            alloc_second_pos = NR
        }
    }
    if (merge_copy_pos == 0 &&
        (u ~ /(JSR|BSR).*CLEANUP_COPYANIMOBJECT/ || u ~ /MOVE\.B \(A0\),\(A1\)/)) {
        merge_copy_pos = NR
    }
    if (entry_length_pos == 0 &&
        (u ~ /(JSR|BSR).*CLEANUP_STRINGLENGTH/ || u ~ /COUNT_ENTRY_TEXT_LOOP/ || u ~ /SUBA\.L 16\(A1\),A0/)) {
        entry_length_pos = NR
    }
    if (u ~ /MOVE\.L \$18\(A2\),-\(A7\)/ || u ~ /MOVE\.L 24\(A1\),-\(A7\)/) {
        subentry_text_fallback_pos = NR
    }
    if (subentry_numeric_fallback_pos == 0 &&
        (u ~ /MOVE\.L \$20\(A2\),\$1A\(A0\)/ || u ~ /MOVE\.L 32\(A0\),26\(A1\)/)) {
        subentry_numeric_fallback_pos = NR
    }
    if (merge_index_init_pos == 0 &&
        (u ~ /MOVE\.W #\$?1,-32\(A5\)/ ||
         (prev_u ~ /MOVEQ(\.L)? #\$?1,D0/ && u ~ /MOVE\.L D0,\$60\(A7\)/))) {
        merge_index_init_pos = NR
    }
    if (u ~ /MOVEQ(\.L)? #\$?0,D0/ || u ~ /MOVEQ #0,D0/) {
        return0_pos = NR
    }
    if (u == "RTS") {
        rts_pos = NR
    }
    prev_u = u
}

END {
    print "HAS_LABEL=" (label_pos > 0)
    print "INIT_PHASE_ORDER=" (label_pos > 0 &&
        (((init_record_pos > label_pos && init_subentry_pos > init_record_pos) &&
          slot_init_pos > init_subentry_pos) ||
         (token_seed_count >= 7 && slot_init_pos > label_pos)))
    print "DISK_DISPATCH_PHASE=" (secondary_pending_pos > 0 &&
        primary_pending_pos > secondary_pending_pos &&
        return1_pos > primary_pending_pos &&
        escape_pos > return1_pos)
    print "HEADER_PARSE_PHASE=" (escape_pos > 0 &&
        record_token_first_pos > escape_pos &&
        wildcard_pos > record_token_first_pos)
    print "INVALID_DISK_RETURN_PRESENT=" (return1_pos > primary_pending_pos &&
        (return2_pos == 0 || return1_pos < return2_pos))
    print "NO_MATCH_RETURN_PRESENT=" (return2_pos > wildcard_pos)
    print "PRIMARY_ENTRY_PHASE=" (clear_first_pos > return2_pos &&
        free_first_pos > clear_first_pos &&
        replace_first_pos > free_first_pos)
    print "TITLE_FALLBACK_PHASE_PRESENT=" (null_replace_pos > 0 &&
        fallback_pos > 0)
    print "TITLE_PHASE_PRESENT=" ((title_format_pos > replace_first_pos ||
        fallback_pos > replace_first_pos) &&
        alloc_first_pos > title_format_pos &&
        alloc_first_pos > fallback_pos)
    print "ENTRY_OFFSET_ADVANCE_PHASE=" (entry_length_pos > parse_first_pos &&
        alloc_first_pos > entry_length_pos)
    print "SUBENTRY_PHASE_PRESENT=" (alloc_first_pos > 0 &&
        record_token_second_pos > alloc_first_pos &&
        format_call_count >= 2 &&
        parse_call_count >= 2)
    print "SUBENTRY_FALLBACK_PHASE_PRESENT=" (subentry_text_fallback_pos > alloc_first_pos &&
        subentry_numeric_fallback_pos > subentry_text_fallback_pos)
    print "MERGE_STARTS_AT_INDEX1=" (merge_index_init_pos > subentry_numeric_fallback_pos)
    print "MERGE_PHASE_PRESENT=" (alloc_call_count >= 1 &&
        clear_call_count >= 2 &&
        free_call_count >= 2 &&
        clear_second_pos > merge_index_init_pos &&
        free_second_pos > clear_second_pos &&
        merge_copy_pos > free_second_pos)
    print "REPLACE_CALLS_GE12=" (replace_call_count >= 12)
    print "RETURN_PHASE_PRESENT=" (return0_pos > 0 && rts_pos > return0_pos)
}
