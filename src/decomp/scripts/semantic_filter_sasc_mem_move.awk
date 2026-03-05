BEGIN {
    has_entry = 0
    has_arg_loads = 0
    has_len_guard = 0
    has_overlap_cmp = 0
    has_fwd_copy = 0
    has_bwd_copy = 0
    has_counter_dec = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^MEM_MOVE:/) has_entry = 1
    if (l ~ /MOVEA\.L .*A0/ || l ~ /MOVEA\.L .*A1/ || l ~ /MOVE\.L .*D0/) has_arg_loads = 1
    if (l ~ /BLE\./ || l ~ /BGT\./ || l ~ /TST\.L D0/ || l ~ /TST\.L D7/) has_len_guard = 1
    if (l ~ /CMPA\.L A0,A1/ || l ~ /CMP\.L A0,A1/ || l ~ /BCS\./ || l ~ /BHI\./) has_overlap_cmp = 1
    if (l ~ /MOVE\.B \(A0\)\+,\(A1\)\+/ || l ~ /MOVE\.B \(A[0-6]\)\+,\(A[0-6]\)\+/) has_fwd_copy = 1
    if (l ~ /MOVE\.B -\(A0\),-\(A1\)/ || l ~ /MOVE\.B \(A[0-6]\),\(A[0-6]\)/) has_bwd_copy = 1
    if (l ~ /SUBQ\.L #\$?1,D0/ || l ~ /SUBQ\.L #\$?1,D7/ || l ~ /DBF D0/ || l ~ /DBF D7/) has_counter_dec = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ARG_LOADS=" has_arg_loads
    print "HAS_LEN_GUARD=" has_len_guard
    print "HAS_OVERLAP_CMP=" has_overlap_cmp
    print "HAS_FWD_COPY=" has_fwd_copy
    print "HAS_BWD_COPY=" has_bwd_copy
    print "HAS_COUNTER_DEC=" has_counter_dec
    print "HAS_RTS=" has_return
}
