BEGIN {
    has_entry = 0
    has_return_entry = 0
    has_group_select = 0
    saw_charclass_table = 0
    saw_btst2 = 0
    saw_len_cmp = 0
    saw_len_ret = 0
    has_record_marker_scan = 0
    has_entry_loop = 0
    has_name_compare_loop = 0
    has_flag_decode = 0
    has_hex_parse = 0
    has_copy_or_zero_tag = 0
    has_fill_header_call = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD:/ || uline ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDR:/) has_entry = 1
    if (uline ~ /^ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD_RETURN:/ || uline ~ /^___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__[0-9]+:/) has_return_entry = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPCODE/ || uline ~ /TEXTDISP_PRIMARYGROUPCODE/) has_group_select = 1
    if (uline ~ /WDISP_CHARCLASSTABLE/) saw_charclass_table = 1
    if (uline ~ /BTST #2,/ || uline ~ /ESQDISP_PARSEOPTIONALDECIMALDIGI/) saw_btst2 = 1
    if (uline ~ /CMP\.L D0,D5/ || uline ~ /CMP\.L D0,D6/) saw_len_cmp = 1
    if (uline ~ /BLT\.W ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD_RETURN/ || uline ~ /BLT\.W ___ESQDISP_PARSEPROGRAMINFOCOMMANDRECORD__/) saw_len_ret = 1
    if (uline ~ /CMP\.B \(A3\),D0/ || uline ~ /^\.LAB_08EC:/ || uline ~ /MOVE\.L A3,-24\(A5\)/ || uline ~ /MOVE\.L A5,A3/ || uline ~ /SUB\.L A2,A2/) has_record_marker_scan = 1
    if (uline ~ /^\.BRANCH:/ || uline ~ /CMP\.L D6,D7/ || uline ~ /CMP\.L D7,D0/) has_entry_loop = 1
    if (uline ~ /^\.LAB_08F0:/ || uline ~ /CMP\.B \(A0\)\+,D0/ || uline ~ /CMP\.B \(A1\)\+,D0/ || index(uline, "TITLEMATCHES") > 0) has_name_compare_loop = 1
    if (uline ~ /BSET #1,-28\(A5\)/ || uline ~ /BSET #2,-28\(A5\)/ || uline ~ /BSET #0,-31\(A5\)/ || uline ~ /ESQDISP_PARSEYESNOFLAG/ || uline ~ /ANDI\.L #\$FFFE,D0/ || uline ~ /ANDI\.L #\$FFFD,D0/) has_flag_decode = 1
    if (uline ~ /ESQFUNC_JMPTBL_LADFUNC_PARSEHEXDIGIT/ || uline ~ /ESQFUNC_JMPTBL_LADFUNC_PARSEHEXD/) has_hex_parse = 1
    if (uline ~ /ESQFUNC_JMPTBL_STRING_COPYPADNUL/ || uline ~ /ESQDISP_PROGRAMINFOZEROTAG/) has_copy_or_zero_tag = 1
    if (uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFIELDS/ || uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFIE/) has_fill_header_call = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_charclass_digit_parse = (saw_charclass_table && saw_btst2) ? 1 : 0
    has_length_guard = (saw_len_cmp && saw_len_ret) ? 1 : 0
    if (has_return != 0 && has_entry != 0) has_return_entry = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN_ENTRY=" has_return_entry
    print "HAS_GROUP_SELECT=" has_group_select
    print "HAS_CHARCLASS_DIGIT_PARSE=" has_charclass_digit_parse
    print "HAS_LENGTH_GUARD=" has_length_guard
    print "HAS_RECORD_MARKER_SCAN=" has_record_marker_scan
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_NAME_COMPARE_LOOP=" has_name_compare_loop
    print "HAS_FLAG_DECODE=" has_flag_decode
    print "HAS_HEX_PARSE=" has_hex_parse
    print "HAS_COPY_OR_ZERO_TAG=" has_copy_or_zero_tag
    print "HAS_FILL_HEADER_CALL=" has_fill_header_call
    print "HAS_RETURN=" has_return
}
