BEGIN {
    has_ioerr_clear = 0
    has_negative_check = 0
    has_upper_bound_check = 0
    has_index_scale = 0
    has_entry_flag_test = 0
    has_errcode_set = 0
    has_null_return = 0
    has_ptr_return = 0
    has_rts = 0
}

function trim(s,    t) {
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

    if (u ~ /^CLR\.L .*GLOBAL_DOSIOERR/ || u ~ /^MOVE\.L #0,.*GLOBAL_DOSIOERR/ || u ~ /^MOVE\.L D[0-7],.*GLOBAL_DOSIOERR/) has_ioerr_clear = 1
    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMPI?\.L #0,D[0-7]$/) has_negative_check = 1
    if (u ~ /GLOBAL_HANDLETABLECOUNT/ || u ~ /^CMP\.L .*D[0-7]$/) has_upper_bound_check = 1
    if (u ~ /^ASL\.L #3,D[0-7]$/ || u ~ /^LSL\.L #3,D[0-7]$/ || u ~ /^ADD\.L D[0-7],D[0-7]$/) has_index_scale = 1
    if (u ~ /GLOBAL_HANDLETABLEBASE/ || u ~ /STRUCT_HANDLEENTRY__FLAGS/ || u ~ /^TST\.L .*\(A[0-7],D[0-7]\.L\)$/) has_entry_flag_test = 1
    if ((u ~ /^MOVEQ #9,D[0-7]$/ || u ~ /^MOVE\.L #9,D[0-7]$/ || u ~ /^MOVE\.L #\$9,D[0-7]$/) || u ~ /GLOBAL_APPERRORCODE/) has_errcode_set = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_null_return = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^ADD\.L #_?GLOBAL_HANDLETABLEBASE,D0$/) has_ptr_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_IOERR_CLEAR=" has_ioerr_clear
    print "HAS_NEGATIVE_CHECK=" has_negative_check
    print "HAS_UPPER_BOUND_CHECK=" has_upper_bound_check
    print "HAS_INDEX_SCALE=" has_index_scale
    print "HAS_ENTRY_FLAG_TEST=" has_entry_flag_test
    print "HAS_ERRCODE_SET=" has_errcode_set
    print "HAS_NULL_RETURN=" has_null_return
    print "HAS_PTR_RETURN=" has_ptr_return
    print "HAS_RTS=" has_rts
}
