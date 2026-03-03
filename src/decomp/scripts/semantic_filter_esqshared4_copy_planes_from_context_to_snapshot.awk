BEGIN {
    has_movem_save = 0
    has_a1_offset = 0
    has_dst_ptr_base = 0
    has_copy = 0
    has_count = 0
    has_store_back = 0
    has_movem_restore = 0
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

    if (u ~ /^MOVEM\.L D1\/A1-A4,-\(A7\)$/) has_movem_save = 1
    if (u ~ /^LEA 20\(A1\),A1$/) has_a1_offset = 1
    if (u ~ /ESQPARS2_BANNERSNAPSHOTPLANE0DSTPTR/) has_dst_ptr_base = 1
    if (u ~ /^MOVE\.L \(A3\)\+,\(A4\)\+$/) has_copy = 1
    if (u ~ /^MOVE\.[WL] #\$?2B,D1$/ || u ~ /^MOVE\.[WL] #43,D1$/ || u ~ /^MOVEQ #43,D1$/) has_count = 1
    if (u ~ /^MOVE\.L A3,\(A1\)\+$/) has_store_back = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D1\/A1-A4$/) has_movem_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MOVEM_SAVE=" has_movem_save
    print "HAS_A1_OFFSET=" has_a1_offset
    print "HAS_DST_PTR_BASE=" has_dst_ptr_base
    print "HAS_COPY=" has_copy
    print "HAS_COUNT=" has_count
    print "HAS_STORE_BACK=" has_store_back
    print "HAS_MOVEM_RESTORE=" has_movem_restore
    print "HAS_RTS=" has_rts
}
