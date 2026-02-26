BEGIN {
    has_count_load = 0
    has_index_step = 0
    has_table_base = 0
    has_flag_load = 0
    has_bit4_test = 0
    has_close_call = 0
    has_return_call = 0
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

    if (u ~ /GLOBAL_HANDLETABLECOUNT/) has_count_load = 1
    if (u ~ /^SUBQ\.(W|L) #1,D[0-7]$/ || u ~ /^SUBQ\.(W|L) #1,A[0-7]$/ || u ~ /^SUB\.(W|L) #1,D[0-7]$/) has_index_step = 1
    if (u ~ /GLOBAL_HANDLETABLEBASE/) has_table_base = 1
    if (u ~ /STRUCT_HANDLEENTRY__FLAGS/ || u ~ /^MOVE\.L \(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L \([0-9]+,A[0-7]\),D[0-7]$/) has_flag_load = 1
    if (u ~ /^BTST #4,/ || u ~ /ANDI?\.[WL] #16/ || u ~ /#0X10/ || u ~ /#16/) has_bit4_test = 1
    if (u ~ /JSR .*DOS_CLOSEWITHSIGNALCHECK/ || u ~ /^JSR \(A[0-7]\)$/) has_close_call = 1
    if (u ~ /JSR .*UNKNOWN32_JMPTBL_ESQ_RETURNWITHSTACKCODE/ || u ~ /JSR .*ESQ_RETURNWITHSTACKCODE/) has_return_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_COUNT_LOAD=" has_count_load
    print "HAS_INDEX_STEP=" has_index_step
    print "HAS_TABLE_BASE=" has_table_base
    print "HAS_FLAG_LOAD=" has_flag_load
    print "HAS_BIT4_TEST=" has_bit4_test
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_RETURN_CALL=" has_return_call
    print "HAS_RTS=" has_rts
}
