BEGIN {
    has_entry = 0
    has_frame = 0
    has_group_match = 0
    has_loop = 0
    has_table_pick = 0
    has_strlen_scan = 0
    has_space_fill = 0
    has_append_call = 0
    has_copy_back = 0
    has_return_branch = 0
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

    if (uline ~ /^ESQIFF2_PADENTRIESTOMAXTITLEWIDTH:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-24$/ && uline !~ /^;/) has_frame = 1
    if (uline ~ /^MOVE\.B TEXTDISP_SECONDARYGROUPCODE,D0$/ || uline ~ /^MOVE\.B TEXTDISP_PRIMARYGROUPCODE,D0$/) has_group_match = 1
    if (uline ~ /^CMP\.W -12\(A5\),D6$/ || uline ~ /^BRA\.[SW] \.LOOP_ENTRIES_FOR_PADDING$/) has_loop = 1
    if (uline ~ /^LEA TEXTDISP_SECONDARYENTRYPTRTABLE,A0$/ || uline ~ /^LEA TEXTDISP_PRIMARYENTRYPTRTABLE,A0$/) has_table_pick = 1
    if (uline ~ /^TST\.B \(A1\)\+$/) has_strlen_scan = 1
    if (uline ~ /^MOVE\.B #\$20,-24\(A5,D5\.W\)$/) has_space_fill = 1
    if (uline ~ /^JSR GROUP_AR_JMPTBL_STRING_APPENDATNULL\(PC\)$/) has_append_call = 1
    if (uline ~ /^MOVE\.B \(A1\)\+,\(A0\)\+$/) has_copy_back = 1
    if (uline ~ /^BRA\.[SW] ESQIFF2_PADENTRIESTOMAXTITLEWIDTH_RETURN$/ || uline ~ /^BGE\.[SW] ESQIFF2_PADENTRIESTOMAXTITLEWIDTH_RETURN$/ || uline ~ /^JMP ESQIFF2_PADENTRIESTOMAXTITLEWIDTH_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FRAME=" has_frame
    print "HAS_GROUP_MATCH=" has_group_match
    print "HAS_LOOP=" has_loop
    print "HAS_TABLE_PICK=" has_table_pick
    print "HAS_STRLEN_SCAN=" has_strlen_scan
    print "HAS_SPACE_FILL=" has_space_fill
    print "HAS_APPEND_CALL=" has_append_call
    print "HAS_COPY_BACK=" has_copy_back
    print "HAS_RETURN_BRANCH=" has_return_branch
}
