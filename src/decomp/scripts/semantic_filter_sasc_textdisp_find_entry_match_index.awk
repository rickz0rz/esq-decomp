BEGIN {
    has_entry=0
    has_empty_guard=0
    has_group_mode_dispatch=0
    has_primary_group_setup=0
    has_secondary_group_setup=0
    has_mode_next=0
    has_prev_valid_call=0
    has_prev_before_call=0
    has_blocked_fallback=0
    has_find_control=0
    has_find_quoted=0
    has_slot_scan=0
    has_title_guard=0
    has_mask_check=0
    has_slot_bit_test=0
    has_token_gate=0
    has_quoted_exact_path=0
    has_compare_path=0
    has_substring_len_guard=0
    has_substring_path=0
    has_restore_entry=0
    has_restore_return=0
    has_rts=0
    prev1=""
    prev2=""
    prev3=""
    saw_primary_mode=0
    saw_secondary_mode=0
    saw_slot_increment=0
    saw_prev_call=0
    saw_prev_before_subq=0
    saw_entry_title_load=0
    saw_token_null_test=0
    saw_entry_token_test=0
    saw_input_quotes_test=0
    saw_entry_quotes_test=0
    saw_compare_len_guard=0
    saw_substring_input_unquoted=0
    saw_substring_len_cmp=0
    saw_restore_entry_addr=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_FINDENTRYMATCHINDEX:/ || u ~ /^TEXTDISP_FINDENTRYMATCHINDE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TSTBA0/ || n ~ /TSTBA5/ || n ~ /MOVEBA5D[01]/ || n ~ /MOVEQ(L)?(49|31)D0/) has_empty_guard=1
    if (n ~ /TEXTDISPACTIVEGROUPID/ || n ~ /CLOCKHALFHOURSLOTINDEX/ || n ~ /GETENTRYAUXPOINTERBYMODE/ || n ~ /GETENTRYPOINTERBYMODE/) has_group_mode_dispatch=1
    if (u ~ /PEA 1\.W/ || u ~ /MOVE\.L D5,-\(A7\)/ || u ~ /MOVE\.L \$94\(A7\),-\(A7\)/) saw_primary_mode=1
    if ((u ~ /(JSR|BSR).*GETENTRYAUXPOINTERBYMODE/ || u ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/) && saw_primary_mode) has_primary_group_setup=1
    if (u ~ /PEA 2\.W/ || u ~ /MOVE\.L \$94\(A7\),-\(A7\)/ || u ~ /MOVE\.L \$9C\(A7\),\(A7\)/) saw_secondary_mode=1
    if ((u ~ /(JSR|BSR).*GETENTRYAUXPOINTERBYMODE/ || u ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/) && saw_secondary_mode) has_secondary_group_setup=1
    if ((n ~ /CLOCKHALFHOURSLOTINDEX/ && n ~ /ADDQ(L)?1D[01]/) ||
        ((u ~ /ADDQ\.[LW] #\$1,D[01]/ || u ~ /ADDQ\.[LW] #1,D[01]/) &&
         (prev1 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/ ||
          prev1 ~ /CLOCKHALFHOURSLOTINDEX/ || prev2 ~ /CLOCKHALFHOURSLOTINDEX/))) has_mode_next=1
    if (n ~ /FINDPREVIOUSVALIDENTRYINDEX/ || n ~ /FINDPREVIO/) {
        has_prev_valid_call=1
        saw_prev_call=1
        if (saw_prev_before_subq) has_prev_before_call=1
    }
    if (u ~ /SUBQ\.[LW] #\$1,D[01]/ || u ~ /SUBQ\.[LW] #1,D[01]/) saw_prev_before_subq=1
    if ((n ~ /BTST7/ || (n ~ /ANDB/ && n ~ /80/)) &&
        (prev1 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev3 ~ /CLOCK_HALFHOURSLOTINDEX/ ||
         u ~ /CLOCK_HALFHOURSLOTINDEX/)) has_blocked_fallback=1
    if (n ~ /TEXTDISPFINDCONTROLTOKEN/) has_find_control=1
    if (n ~ /TEXTDISPFINDQUOTEDSPAN/) has_find_quoted=1
    if (n ~ /CMPW49D5/ || n ~ /MOVEQ(L)?(49|31)D0/ || n ~ /CMPWD0D5/ || n ~ /MOVEQL31D1/ || n ~ /CMPLD1D0/ || n ~ /BGEWRESTOREINPUTCHAR/ || n ~ /SLOT49/) has_slot_scan=1
    if (u ~ /ADDQ\.[LW] #\$1,D5/ || u ~ /ADDQ\.[LW] #1,D5/ || u ~ /ADDQ\.L #\$1,\$4C\(A7\)/ || u ~ /ADDQ\.L #1,\$4C\(A7\)/) saw_slot_increment=1
    if ((u ~ /TST\.L 56\(A3,D0\.L\)/ || u ~ /TST\.L \$38\(A3,D1\.L\)/) && saw_slot_increment) has_title_guard=1
    if (n ~ /ANDBD6D0/ || n ~ /CMPBD6D0/ || n ~ /ANDBD5D2/ || n ~ /CMPBD5D2/ || n ~ /ANDBD[0-7]D[0-7]/ || n ~ /CMPBD[0-7]D[0-7]/ || n ~ /AND/ && n ~ /MASK/) has_mask_check=1
    if (n ~ /TESTBIT1BASED/) has_slot_bit_test=1
    if (u ~ /MOVEA\.L -52\(A5\),A0/ || u ~ /MOVE\.L \$70\(A7\),A1/ || u ~ /TST\.L -52\(A5\)/ || u ~ /TST\.L \$70\(A7\)/) saw_token_null_test=1
    if (u ~ /MOVEA\.L D0,A0/ || u ~ /MOVE\.L D0,A0/ || u ~ /MOVE\.L \$64\(A7\),A0/) saw_entry_token_test=1
    if ((u ~ /CMP\.B \(A0\),D1/ || u ~ /CMP\.B \(A1\),D1/ || u ~ /CMP\.B \(A1\),D[01]/) &&
        saw_token_null_test && saw_entry_token_test) has_token_gate=1
    if (u ~ /TST\.L -26\(A5\)/ || u ~ /TST\.L \$5C\(A7\)/) saw_input_quotes_test=1
    if (u ~ /TST\.L -30\(A5\)/ || u ~ /TST\.L \$58\(A7\)/) saw_entry_quotes_test=1
    if (u ~ /CMP\.L D0,D1/ && (prev1 ~ /MOVE\.L -44\(A5\),D1/ || prev1 ~ /MOVE\.L \$54\(A7\),D1/)) saw_compare_len_guard=1
    if ((n ~ /STRINGCOMPARENOCASE/) && saw_input_quotes_test && saw_entry_quotes_test && saw_compare_len_guard) has_quoted_exact_path=1
    if (n ~ /STRINGCOMPARENOCASE/) has_compare_path=1
    if (u ~ /TST\.L -26\(A5\)/ || u ~ /TST\.L \$5C\(A7\)/) saw_substring_input_unquoted=1
    if ((u ~ /CMP\.L D0,D1/ || u ~ /CMP\.L D1,D0/) &&
        (prev1 ~ /MOVE\.L -44\(A5\),D1/ || prev1 ~ /MOVE\.L \$54\(A7\),D1/)) saw_substring_len_cmp=1
    if (saw_substring_len_cmp) has_substring_len_guard=1
    if (n ~ /FINDSUBSTRINGCASEFOLD/ || n ~ /FINDSUBSTRINGC/) has_substring_path=1
    if ((n ~ /FINDSUBSTRINGCASEFOLD/ || n ~ /FINDSUBSTRINGC/) && saw_substring_input_unquoted && saw_substring_len_cmp) has_substring_path=1
    if (u ~ /MOVEA\.L -38\(A5\),A0/ || u ~ /MOVE\.L \$60\(A7\),A0/) saw_restore_entry_addr=1
    if ((u ~ /MOVE\.B -40\(A5\),D0/ || u ~ /MOVE\.B \$38\(A7\),\(A0\)/ || u ~ /MOVE\.B D1,\(A1\)/ || u ~ /MOVE\.B \$40\(A7\),\(A0\)/) && saw_restore_entry_addr) has_restore_entry=1
    if (n ~ /MOVEB39A5D0/ || n ~ /MOVEB1FA7A0/ || n ~ /MOVEB1EA7A0/ || n ~ /MOVEB26A7A0/ || n ~ /MOVEB27A7A0/ || n ~ /MOVEB40A7A0/ || n ~ /MOVEBD0A0/ || n ~ /RETURN/) has_restore_return=1
    if (u == "RTS") has_rts=1

    prev3=prev2
    prev2=prev1
    prev1=u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_EMPTY_GUARD=" has_empty_guard
    print "HAS_GROUP_MODE_DISPATCH=" has_group_mode_dispatch
    print "HAS_PRIMARY_GROUP_SETUP=" has_primary_group_setup
    print "HAS_SECONDARY_GROUP_SETUP=" has_secondary_group_setup
    print "HAS_MODE_NEXT_PATH=" has_mode_next
    print "HAS_PREV_VALID_CALL=" has_prev_valid_call
    print "HAS_PREV_BEFORE_CALL=" has_prev_before_call
    print "HAS_BLOCKED_SLOT_FALLBACK=" has_blocked_fallback
    print "HAS_FIND_CONTROL_CALL=" has_find_control
    print "HAS_FIND_QUOTED_CALL=" has_find_quoted
    print "HAS_SLOT_SCAN=" has_slot_scan
    print "HAS_TITLE_GUARD=" has_title_guard
    print "HAS_MASK_CHECK=" has_mask_check
    print "HAS_SLOT_BIT_TEST=" has_slot_bit_test
    print "HAS_TOKEN_GATE=" has_token_gate
    print "HAS_QUOTED_EXACT_PATH=" has_quoted_exact_path
    print "HAS_COMPARE_PATH=" has_compare_path
    print "HAS_SUBSTRING_LEN_GUARD=" has_substring_len_guard
    print "HAS_SUBSTRING_PATH=" has_substring_path
    print "HAS_RESTORE_ENTRY_CHAR=" has_restore_entry
    print "HAS_RESTORE_RETURN=" has_restore_return
    print "HAS_RTS=" has_rts
}
