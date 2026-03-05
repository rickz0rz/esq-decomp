BEGIN {
    has_entry = 0
    has_index_compare = 0
    has_prev_index_ref = 0
    has_curr_index_ref = 0
    has_prev_ptr_extract = 0
    has_curr_tail_store = 0
    has_prev_97_check = 0
    has_prev_restore_store = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_UPDATEBANNERROWPOINTERS:/) has_entry = 1
    if (index(u, "GCOMMAND_BANNERROWINDEXPREVIOUS") > 0) has_prev_index_ref = 1
    if (index(u, "GCOMMAND_BANNERROWINDEXCURRENT") > 0) has_curr_index_ref = 1
    if (u ~ /^LEA [0-9]+\(A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.L A[0-7],D[0-7]$/ || u ~ /^SWAP D[0-7]$/) has_prev_ptr_extract = 1
    if (u ~ /^ADDI\.[LW] #\$2FA,D[0-7]$/ || u ~ /^ADDI\.[LW] #\$2FE,D[0-7]$/ || u ~ /^LEA \$2FA\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2FE\(A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.W D[0-7],0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/) has_curr_tail_store = 1
    if (u ~ /^MOVEQ(\.L)? #\$61,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #97,D[0-7]$/) has_prev_97_check = 1
    if (u ~ /^MOVE\.W D[0-7],0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.W D[0-7],\$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/) has_prev_restore_store = 1
    if (u == "RTS") has_return = 1
}

END {
    if (has_prev_index_ref && has_curr_index_ref) has_index_compare = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_COMPARE=" has_index_compare
    print "HAS_PREV_PTR_EXTRACT=" has_prev_ptr_extract
    print "HAS_CURR_TAIL_STORE=" has_curr_tail_store
    print "HAS_PREV_97_CHECK=" has_prev_97_check
    print "HAS_PREV_RESTORE_STORE=" has_prev_restore_store
    print "HAS_RETURN=" has_return
}
