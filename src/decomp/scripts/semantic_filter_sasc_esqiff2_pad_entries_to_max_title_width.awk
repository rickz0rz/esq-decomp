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
    has_stack_guard = 0
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
    u = toupper(line)

    if (u ~ /^ESQIFF2_PADENTRIESTOMAXTITLEWIDTH:/ || u ~ /^ESQIFF2_PADENTRIESTOMAXTITLEW[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^LINK\.W A5,#-24$/ || u ~ /^LINK\.W A[0-7],#-[0-9]+$/ || u ~ /^LINK\.W A[0-7],#-\$[0-9A-F]+$/) has_frame = 1
    if (index(u, "__BASE(A4)") > 0 || index(u, "_XCOVF") > 0) has_stack_guard = 1
    if (index(u, "TEXTDISP_SECONDARYGROUPCODE") > 0 || index(u, "TEXTDISP_PRIMARYGROUPCODE") > 0) has_group_match = 1
    if (u ~ /^CMP\.W -12\(A5\),D6$/ || u ~ /^CMP\.W [^,]+,D[0-7]$/ || index(u, "LOOP_ENTRIES_FOR_PADDING") > 0) has_loop = 1
    if (index(u, "TEXTDISP_SECONDARYENTRYPTRTABLE") > 0 || index(u, "TEXTDISP_PRIMARYENTRYPTRTABLE") > 0) has_table_pick = 1
    if (u ~ /^TST\.B \(A1\)\+$/ || u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^TST\.B \(A[0-7]\)$/ || u ~ /^ADDQ\.L #\$1,A[0-7]$/ || u ~ /^ADDQ\.L #1,A[0-7]$/) has_strlen_scan = 1
    if (u ~ /^MOVE\.B #\$20,-24\(A5,D5\.W\)$/ || u ~ /^MOVE\.B #\$20,[^ ]+$/ || u ~ /^MOVE\.B #32,[^ ]+$/) has_space_fill = 1
    if (index(u, "GROUP_AR_JMPTBL_STRING_APPENDATNULL") > 0 || index(u, "APPENDATNULL") > 0 || index(u, "APPENDATN") > 0) has_append_call = 1
    if (u ~ /^MOVE\.B \(A1\)\+,\(A0\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/) has_copy_back = 1
    if (u ~ /^BRA\.[SWB] ESQIFF2_PADENTRIESTOMAXTITLEWIDTH_RETURN$/ || u ~ /^BGE\.[SWB] ESQIFF2_PADENTRIESTOMAXTITLEWIDTH_RETURN$/ || u ~ /^BGE\.[SWB] ___ESQIFF2_PADENTRIESTOMAXTITLEW/ || u ~ /^BRA\.[SWB] ___ESQIFF2_PADENTRIESTOMAXTITLEW/ || u ~ /^JMP ESQIFF2_PADENTRIESTOMAXTITLEWIDTH_RETURN$/) has_return_branch = 1
}

END {
    if (has_stack_guard) has_frame = 1

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
