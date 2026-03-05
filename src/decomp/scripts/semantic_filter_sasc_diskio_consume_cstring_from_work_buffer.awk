BEGIN {
    has_entry = 0
    has_scratch_dec = 0
    has_ptr_load = 0
    has_ptr_store = 0
    has_zero_check = 0
    has_sentinel = 0
    has_rts = 0
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

    if (l ~ /^DISKIO_CONSUMECSTRINGFROMWORKBUFFER:/ || l ~ /^DISKIO_CONSUMECSTRINGFROMWORKBUF/) has_entry = 1
    if (index(l, "GLOBAL_REF_LONG_FILE_SCRATCH") > 0 && (l ~ /^SUBQ\.[LW] #\$?1,/ || l ~ /^SUB\.[LW] #\$?1,/)) has_scratch_dec = 1
    if (index(l, "GLOBAL_PTR_WORK_BUFFER") > 0 && (l ~ /^MOVEA\.L / || l ~ /^MOVE\.L /) && l ~ /,A[0-7]$/) has_ptr_load = 1
    if (index(l, "GLOBAL_PTR_WORK_BUFFER") > 0 && (l ~ /^MOVE\.L A[0-7],/ || l ~ /^MOVEA\.L A[0-7],/)) has_ptr_store = 1
    if (l ~ /^TST\.B D[0-7]$/ || l ~ /^TST\.B \(A[0-7]\)$/ || l ~ /^CMP\.B #0,D[0-7]$/ || l ~ /^BEQ(\.[A-Z]+)? / || l ~ /^BNE(\.[A-Z]+)? /) has_zero_check = 1
    if (l ~ /^MOVEA\.W #\$?FFFF,A[0-7]$/ || l ~ /^MOVE\.L #\$?FFFF,D[0-7]$/ || l ~ /^MOVE\.L #\$?0000FFFF,D[0-7]$/ || l ~ /^MOVE\.L #\$?FFFF,A[0-7]$/ || l ~ /^MOVE\.L #\$?0000FFFF,A[0-7]$/) has_sentinel = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SCRATCH_DEC=" has_scratch_dec
    print "HAS_PTR_LOAD=" has_ptr_load
    print "HAS_PTR_STORE=" has_ptr_store
    print "HAS_ZERO_CHECK=" has_zero_check
    print "HAS_SENTINEL=" has_sentinel
    print "HAS_RTS=" has_rts
}
