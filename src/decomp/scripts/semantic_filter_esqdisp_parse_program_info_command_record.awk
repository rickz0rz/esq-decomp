BEGIN {
    has_entry = 0
    has_return_entry = 0
    has_secondary_group_select = 0
    has_primary_group_select = 0
    saw_charclass_table = 0
    saw_decimal_digit_test = 0
    has_decimal_digit_parse = 0
    has_decimal_tens_mul = 0
    saw_entrycount_guard = 0
    saw_len_cmp = 0
    saw_len_ret = 0
    has_length_guard = 0
    has_record_marker = 0
    has_attr_marker = 0
    has_scan_limit = 0
    has_attr_text_nul_init = 0
    has_missing_attr_restart = 0
    has_entry_loop = 0
    has_title_match = 0
    has_flag40_bit1 = 0
    has_flag40_bit2 = 0
    has_field41_hex_parse = 0
    has_field41_bounds = 0
    has_field42_hex_parse = 0
    has_field42_bounds = 0
    has_copy_padnul = 0
    has_zero_tag_fallback = 0
    has_field46_bit0 = 0
    has_field46_bit1 = 0
    has_field46_bit2 = 0
    has_field46_bit3 = 0
    has_field46_bit4 = 0
    has_fill_header_call = 0
    has_return = 0
    saw_field41_min = 0
    saw_field41_max = 0
    saw_field41_store = 0
    saw_field42_min = 0
    saw_field42_max = 0
    saw_field42_store = 0
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
    uline = toupper(line)
    nline = uline
    gsub(/[^A-Z0-9]/, "", nline)

    if (uline ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD:/ || uline ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDR:/) has_entry = 1
    if (uline ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD_RETURN:/ || uline ~ /^___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__[0-9]+:/) has_return_entry = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPCODE/ || uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN/ || uline ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/) has_secondary_group_select = 1
    if (uline ~ /TEXTDISP_PRIMARYGROUPCODE/ || uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || uline ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) has_primary_group_select = 1
    if (uline ~ /WDISP_CHARCLASSTABLE/) saw_charclass_table = 1
    if (uline ~ /BTST #2,/ || nline ~ /ESQDISPPARSEOPTIONALDECIMALDIGI/) saw_decimal_digit_test = 1
    if (uline ~ /ESQIFF_JMPTBL_MATH_MULU32/ || uline ~ /PEA \(\$A\)\.W/ || uline ~ /MOVEQ #10,D1/) has_decimal_tens_mul = 1
    if (uline ~ /TST\.L D6/ || uline ~ /TST\.L D7/) saw_entrycount_guard = 1
    if (uline ~ /CMP\.L D0,D5/ || uline ~ /CMP\.L D0,D6/ || uline ~ /MOVEQ\.L #\$6,D0/) saw_len_cmp = 1
    if (uline ~ /BLT\.W ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD_RETURN/ || uline ~ /BLT\.W ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__/ ||
        uline ~ /BLE\.W ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD_RETURN/ || uline ~ /BLE\.W ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__/) saw_len_ret = 1
    if (uline ~ /#\$12/ || uline ~ /#18([^0-9]|$)/) has_record_marker = 1
    if (uline ~ /#\$4([^0-9A-F]|$)/ || uline ~ /#4([^0-9]|$)/) has_attr_marker = 1
    if (uline ~ /#\$6([^0-9A-F]|$)/ || uline ~ /#6([^0-9]|$)/ || uline ~ /CMPI\.L #\$6,/ || uline ~ /^\.LAB_08EC:/) has_scan_limit = 1
    if (uline ~ /CLR\.B -25\(A5\)/ || uline ~ /CLR\.B \$29\(A7\)/) has_attr_text_nul_init = 1
    if (uline ~ /TST\.L -24\(A5\)/ || uline ~ /MOVE\.L A2,D0/) has_missing_attr_restart = 1
    if (uline ~ /BEQ\.S \.LAB_08EB/ || uline ~ /BEQ\.B ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__12/) has_missing_attr_restart = 1
    if (uline ~ /^\.BRANCH:/ || uline ~ /CMP\.L D6,D7/ || uline ~ /CMP\.L D7,D0/) has_entry_loop = 1
    if (uline ~ /^\.LAB_08F0:/ || uline ~ /CMP\.B \(A0\)\+,D0/ || uline ~ /CMP\.B \(A1\)\+,D0/ || nline ~ /ESQDISPTITLEMATCHES/) has_title_match = 1
    if (uline ~ /BSET #1,-28\(A5\)/ || uline ~ /PEA \(\$2\)\.W/) has_flag40_bit1 = 1
    if (uline ~ /BSET #2,-28\(A5\)/ || uline ~ /PEA \(\$4\)\.W/) has_flag40_bit2 = 1
    if (uline ~ /MOVE\.B #\$FF,-29\(A5\)/ || uline ~ /MOVEQ #15,D0/ || uline ~ /PEA \(\$F\)\.W/ || nline ~ /ESQDISPPARSEBOUNDEDHEXDIGIT/) has_field41_hex_parse = 1
    if (uline ~ /MOVEQ #15,D0/ || uline ~ /PEA \(\$F\)\.W/) saw_field41_max = 1
    if (uline ~ /MOVEQ #0,D0/ || uline ~ /CLR\.L -\(A7\)/) saw_field41_min = 1
    if (uline ~ /MOVE\.B D1,-29\(A5\)/ || uline ~ /MOVE\.B #\$FF,-29\(A5\)/ || uline ~ /MOVE\.B D0,\$3D\(A7\)/) saw_field41_store = 1
    if (uline ~ /MOVE\.B #\$FF,-30\(A5\)/ || uline ~ /MOVEQ #3,D0/ || uline ~ /PEA \(\$3\)\.W/ || nline ~ /ESQDISPPARSEBOUNDEDHEXDIGIT/) has_field42_hex_parse = 1
    if (uline ~ /MOVEQ #3,D0/ || uline ~ /PEA \(\$3\)\.W/) saw_field42_max = 1
    if (uline ~ /MOVEQ #1,D0/ || uline ~ /PEA \(\$1\)\.W/) saw_field42_min = 1
    if (uline ~ /MOVE\.B D1,-30\(A5\)/ || uline ~ /MOVE\.B #\$FF,-30\(A5\)/ || uline ~ /MOVE\.B D0,\$24\(A7\)/) saw_field42_store = 1
    if (nline ~ /STRINGCOPYPADNUL/) has_copy_padnul = 1
    if (uline ~ /ESQDISP_PROGRAMINFOZEROTAG/ || (uline ~ /MOVE\.B ESQDISP_PROGRAMINFOZEROTAG/ && uline ~ /\$27\(A7\)|\$28\(A7\)/)) has_zero_tag_fallback = 1
    if (uline ~ /BSET #0,-31\(A5\)/ || uline ~ /ANDI\.L #\$FFFE,D0/ || (nline ~ /ESQDISPPARSEYESNOFLAG/ && uline ~ /PEA \(\$1\)\.W/)) has_field46_bit0 = 1
    if (uline ~ /BSET #1,-31\(A5\)/ || uline ~ /ANDI\.L #\$FFFD,D0/ || (nline ~ /ESQDISPPARSEYESNOFLAG/ && uline ~ /PEA \(\$2\)\.W/)) has_field46_bit1 = 1
    if (uline ~ /BSET #2,-31\(A5\)/ || uline ~ /ANDI\.L #\$FFFB,D0/ || (nline ~ /ESQDISPPARSEYESNOFLAG/ && uline ~ /PEA \(\$4\)\.W/)) has_field46_bit2 = 1
    if (uline ~ /BSET #3,-31\(A5\)/ || uline ~ /ANDI\.L #\$FFF7,D0/ || (nline ~ /ESQDISPPARSEYESNOFLAG/ && uline ~ /PEA \(\$8\)\.W/)) has_field46_bit3 = 1
    if (uline ~ /BSET #4,-31\(A5\)/ || uline ~ /ANDI\.L #\$FFEF,D0/ || (nline ~ /ESQDISPPARSEYESNOFLAG/ && uline ~ /PEA \(\$10\)\.W/)) has_field46_bit4 = 1
    if (uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFIELDS/ || uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFIE/) has_fill_header_call = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_decimal_digit_parse = (saw_decimal_digit_test && saw_charclass_table) ? 1 : 0
    has_length_guard = ((saw_entrycount_guard || saw_len_ret) && saw_len_cmp && saw_len_ret) ? 1 : 0
    has_field41_bounds = (saw_field41_min && saw_field41_max && saw_field41_store) ? 1 : 0
    has_field42_bounds = (saw_field42_min && saw_field42_max && saw_field42_store) ? 1 : 0
    if (has_return != 0 && has_entry != 0) has_return_entry = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN_ENTRY=" has_return_entry
    print "HAS_SECONDARY_GROUP_SELECT=" has_secondary_group_select
    print "HAS_PRIMARY_GROUP_SELECT=" has_primary_group_select
    print "HAS_DECIMAL_DIGIT_PARSE=" has_decimal_digit_parse
    print "HAS_DECIMAL_TENS_MUL=" has_decimal_tens_mul
    print "HAS_LENGTH_GUARD=" has_length_guard
    print "HAS_RECORD_MARKER=" has_record_marker
    print "HAS_ATTR_MARKER=" has_attr_marker
    print "HAS_SCAN_LIMIT=" has_scan_limit
    print "HAS_ATTR_TEXT_NUL_INIT=" has_attr_text_nul_init
    print "HAS_MISSING_ATTR_RESTART=" has_missing_attr_restart
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_TITLE_MATCH=" has_title_match
    print "HAS_FLAG40_BIT1=" has_flag40_bit1
    print "HAS_FLAG40_BIT2=" has_flag40_bit2
    print "HAS_FIELD41_HEX_PARSE=" has_field41_hex_parse
    print "HAS_FIELD41_BOUNDS=" has_field41_bounds
    print "HAS_FIELD42_HEX_PARSE=" has_field42_hex_parse
    print "HAS_FIELD42_BOUNDS=" has_field42_bounds
    print "HAS_COPY_PADNUL=" has_copy_padnul
    print "HAS_ZERO_TAG_FALLBACK=" has_zero_tag_fallback
    print "HAS_FIELD46_BIT0=" has_field46_bit0
    print "HAS_FIELD46_BIT1=" has_field46_bit1
    print "HAS_FIELD46_BIT2=" has_field46_bit2
    print "HAS_FIELD46_BIT3=" has_field46_bit3
    print "HAS_FIELD46_BIT4=" has_field46_bit4
    print "HAS_FILL_HEADER_CALL=" has_fill_header_call
    print "HAS_RETURN=" has_return
}
