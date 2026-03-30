BEGIN {
    has_label = 0
    has_return = 0

    saw_secondary_group_code = 0
    saw_secondary_present = 0
    saw_secondary_count = 0
    saw_secondary_table = 0
    saw_primary_group_code = 0
    saw_primary_count = 0
    saw_primary_table = 0
    has_group_select_flow = 0

    saw_decimal_parse = 0
    saw_decimal_mul = 0
    saw_decimal_add = 0
    saw_record_advance2 = 0
    record_advance1_count = 0
    saw_entrycount_guard = 0
    saw_length_guard = 0
    has_length_parse_flow = 0

    saw_record_marker = 0
    saw_attr_marker = 0
    saw_scan_limit = 0
    saw_attr_reset = 0
    saw_attr_capture = 0
    saw_attr_skip = 0
    saw_missing_attr_retry = 0
    has_attr_scan_flow = 0

    saw_entry_index_init = 0
    saw_entry_bound = 0
    saw_entry_load = 0
    saw_title_match = 0
    saw_match_continue = 0
    has_entry_match_flow = 0

    saw_flag40_bit1 = 0
    saw_flag40_bit2 = 0
    has_flag40_flow = 0

    has_field41_flow = 0
    has_field42_flow = 0
    saw_field41_max = 0
    saw_field41_min = 0
    saw_field41_call = 0
    saw_field42_max = 0
    saw_field42_min = 0
    saw_field42_call = 0

    has_attr_text_copy = 0
    has_zero_tag_fallback = 0
    has_attr_text_flow = 0

    field46_mask_count = 0
    field46_yesno_masks["1"] = 0
    field46_yesno_masks["2"] = 0
    field46_yesno_masks["4"] = 0
    field46_yesno_masks["8"] = 0
    field46_yesno_masks["10"] = 0
    has_field46_flow = 0

    saw_fill_header = 0
    saw_index_increment = 0
    saw_loop_back = 0
    has_finalize_flow = 0
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

    if (u ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD[A-Z0-9_]*:/) {
        has_label = 1
    }
    if (u ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD_RETURN:/ || u ~ /^RTS$/) {
        has_return = 1
    }

    if (u ~ /TEXTDISP_SECONDARYGROUPCODE/) saw_secondary_group_code = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPPRESENTFL|TEXTDISP_SECONDARYGROUPPRESENTFLAG/) saw_secondary_present = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN|TEXTDISP_SECONDARYGROUPENTRYCOUNT/) saw_secondary_count = 1
    if (u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/) saw_secondary_table = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPCODE/) saw_primary_group_code = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/) saw_primary_count = 1
    if (u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) saw_primary_table = 1
    if (saw_secondary_group_code && saw_secondary_present && saw_secondary_count &&
        saw_secondary_table && saw_primary_group_code && saw_primary_count && saw_primary_table) {
        has_group_select_flow = 1
    }

    if (u ~ /ESQDISP_PARSEOPTIONALDECIMALDIGI|BTST #2,\(A[01]\)/) saw_decimal_parse = 1
    if (u ~ /ESQIFF_JMPTBL_MATH_MULU32|MOVEQ #10,D1|PEA \(\$A\)\.W/) saw_decimal_mul = 1
    if (u ~ /ADD\.L D0,D5|ADD\.L D0,D1|MOVE\.L D1,D6/) saw_decimal_add = 1
    if (u ~ /ADDQ\.L #\$2,A5|ADDQ\.L #2,A3/) saw_record_advance2 = 1
    if (u ~ /ADDQ\.L #1,A3|ADDQ\.L #\$1,A5/) record_advance1_count++
    if (record_advance1_count >= 2) saw_record_advance2 = 1
    if (u ~ /TST\.L D6|TST\.L D7/) saw_entrycount_guard = 1
    if (u ~ /CMP\.L D0,D5|CMP\.L D0,D6|MOVEQ #6,D0|MOVEQ\.L #\$6,D0/) saw_length_guard = 1
    if ((u ~ /#\$12/ || u ~ /#18([^0-9]|$)/) &&
        (u ~ /CMP\.B|MOVEQ #18,D0|MOVEQ\.L #\$12,D1/)) saw_record_marker = 1
    if ((u ~ /#\$4([^0-9A-F]|$)/ || u ~ /#4([^0-9]|$)/) &&
        (u ~ /CMP\.B|SUBQ\.B #\$4,D0|MOVEQ #4,D0/)) saw_attr_marker = 1
    if (u ~ /CMPI?\.L #\$6,|CMP\.L D0,D7|CMP\.L D0,\$2C\(A7\)|MOVEQ #6,D0|MOVEQ\.L #\$6,D0/) saw_scan_limit = 1
    if (u ~ /CLR\.L \$2C\(A7\)|CLR\.L -24\(A5\)|MOVE\.L A3,-20\(A5\)|MOVE\.L A5,A3/) saw_attr_reset = 1
    if (u ~ /CLR\.B \(A[35]\)\+|MOVE\.L A[25],-24\(A5\)|MOVE\.L A[25],A2/) saw_attr_capture = 1
    if (u ~ /ADDA\.L D5,A3|ADD\.L D6,A5/) saw_attr_skip = 1
    if ((u ~ /TST\.L -24\(A5\)|MOVE\.L A2,D0/) ||
        (u ~ /BEQ\.S \.LAB_08EB/ || u ~ /BEQ\.B ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__/)) {
        saw_missing_attr_retry = 1
    }
    if (saw_record_marker && saw_attr_marker && saw_scan_limit && saw_attr_reset &&
        saw_attr_capture && saw_attr_skip && saw_missing_attr_retry) {
        has_attr_scan_flow = 1
    }

    if (u ~ /MOVEQ #0,D7|MOVEQ\.L #\$0,D7|CLR\.L \$30\(A7\)/) saw_entry_index_init = 1
    if (u ~ /CMP\.L D6,D7|CMP\.L D7,D0/) saw_entry_bound = 1
    if (u ~ /MOVEA?\.L -40\(A5\),A0|MOVE\.L \$34\(A7\),A0|MOVEA?\.L 0\(A0,D0\.L\),A0|MOVE\.L \$0\(A0,D1\.L\),\$2C\(A7\)/) {
        saw_entry_load = 1
    }
    if (u ~ /ESQDISP_TITLEMATCHES|CMP\.B \(A0\)\+,D0|CMP\.B \(A1\)\+,D0/) saw_title_match = 1
    if (u ~ /BEQ\.W \.LAB_0918|BEQ\.W ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__|BNE\.W \.LAB_0918|TST\.L D0/) {
        saw_match_continue = 1
    }
    if (saw_entry_index_init && saw_entry_bound && saw_entry_load && saw_title_match && saw_match_continue) {
        has_entry_match_flow = 1
    }

    if (u ~ /BSET #1,-28\(A5\)|BCLR #1,-28\(A5\)|PEA \(\$2\)\.W/) saw_flag40_bit1 = 1
    if (u ~ /BSET #2,-28\(A5\)|BCLR #2,-28\(A5\)|PEA \(\$4\)\.W/) saw_flag40_bit2 = 1
    if (saw_flag40_bit1 && saw_flag40_bit2) has_flag40_flow = 1

    if (u ~ /PEA \(\$F\)\.W|MOVEQ #15,D0|MOVEQ\.L #\$F,D0/) {
        saw_field41_max = 1
    }
    if (u ~ /CLR\.L -\(A7\)|MOVEQ #0,D0|MOVEQ\.L #\$0,D0/) {
        saw_field41_min = 1
    }
    if (u ~ /ESQDISP_PARSEBOUNDEDHEXDIGIT/) {
        saw_field41_call = 1
    }
    if ((saw_field41_max && saw_field41_min && saw_field41_call) ||
        (u ~ /MOVE\.B D1,-29\(A5\)|MOVE\.B D0,\$3D\(A7\)/)) {
        has_field41_flow = 1
    }
    if (u ~ /PEA \(\$3\)\.W|MOVEQ #3,D0|MOVEQ\.L #\$3,D0/) {
        saw_field42_max = 1
    }
    if (u ~ /PEA \(\$1\)\.W|MOVEQ #1,D0|MOVEQ\.L #\$1,D0/) {
        saw_field42_min = 1
    }
    if (u ~ /ESQDISP_PARSEBOUNDEDHEXDIGIT/) {
        saw_field42_call = 1
    }
    if ((saw_field42_max && saw_field42_min && saw_field42_call) ||
        (u ~ /MOVE\.B D1,-30\(A5\)|MOVE\.B D0,\$24\(A7\)/)) {
        has_field42_flow = 1
    }

    if (u ~ /STRING_COPYPADNUL|STRINGCOPYPADNUL/) {
        has_attr_text_copy = 1
    }
    if (u ~ /ESQDISP_PROGRAMINFOZEROTAG/) {
        has_zero_tag_fallback = 1
    }
    if (has_attr_text_copy && has_zero_tag_fallback) {
        has_attr_text_flow = 1
    }

    if (u ~ /ANDI\.L #\$FFFE,D0|ANDI\.L #\$FFFD,D0|ANDI\.L #\$FFFB,D0|ANDI\.L #\$FFF7,D0|ANDI\.L #\$FFEF,D0/) {
        field46_mask_count++
    }
    if (u ~ /BSET #0,-31\(A5\)|BCLR #0,-31\(A5\)|PEA \(\$1\)\.W/) field46_yesno_masks["1"] = 1
    if (u ~ /BSET #1,-31\(A5\)|BCLR #1,-31\(A5\)|PEA \(\$2\)\.W/) field46_yesno_masks["2"] = 1
    if (u ~ /BSET #2,-31\(A5\)|BCLR #2,-31\(A5\)|PEA \(\$4\)\.W/) field46_yesno_masks["4"] = 1
    if (u ~ /BSET #3,-31\(A5\)|BCLR #3,-31\(A5\)|PEA \(\$8\)\.W/) field46_yesno_masks["8"] = 1
    if (u ~ /BSET #4,-31\(A5\)|BCLR #4,-31\(A5\)|PEA \(\$10\)\.W/) field46_yesno_masks["10"] = 1
    if (field46_yesno_masks["1"] && field46_yesno_masks["2"] && field46_yesno_masks["4"] &&
        field46_yesno_masks["8"] && field46_yesno_masks["10"]) {
        field46_mask_count = 5
    }
    if (field46_mask_count >= 5) {
        has_field46_flow = 1
    }

    if (u ~ /ESQDISP_FILLPROGRAMINFOHEADERFIE|ESQDISP_FILLPROGRAMINFOHEADERFIELDS/) saw_fill_header = 1
    if (u ~ /ADDQ\.L #\$1,D7|ADDQ\.L #1,D7|ADDQ\.L #\$1,\$30\(A7\)/) saw_index_increment = 1
    if (u ~ /BRA\.W \.BRANCH|BRA\.W ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__/) saw_loop_back = 1
    if (saw_fill_header && saw_index_increment && saw_loop_back) {
        has_finalize_flow = 1
    }
}

END {
    if (saw_decimal_parse && saw_decimal_mul && saw_decimal_add && saw_record_advance2 &&
        saw_entrycount_guard && saw_length_guard) {
        has_length_parse_flow = 1
    }

    print "HAS_LABEL=" has_label
    print "HAS_GROUP_SELECT_FLOW=" has_group_select_flow
    print "HAS_LENGTH_PARSE_FLOW=" has_length_parse_flow
    print "HAS_ATTR_SCAN_FLOW=" has_attr_scan_flow
    print "HAS_ENTRY_MATCH_FLOW=" has_entry_match_flow
    print "HAS_FLAG40_FLOW=" has_flag40_flow
    print "HAS_FIELD41_FLOW=" has_field41_flow
    print "HAS_FIELD42_FLOW=" has_field42_flow
    print "HAS_ATTR_TEXT_FLOW=" has_attr_text_flow
    print "HAS_FIELD46_FLOW=" has_field46_flow
    print "HAS_FINALIZE_FLOW=" has_finalize_flow
    print "HAS_RETURN=" has_return
}
