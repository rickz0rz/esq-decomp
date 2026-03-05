BEGIN {
    has_entry = 0
    has_scratch_dec = 0
    has_crlf_check = 0
    has_ptr_inc = 0
    has_store_nul = 0
    has_sentinel = 0
    has_skip_trailing = 0
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

    if (l ~ /^DISKIO_CONSUMELINEFROMWORKBUFFER:/ || l ~ /^DISKIO_CONSUMELINEFROMWORKBUF:/) has_entry = 1
    if (index(l, "GLOBAL_REF_LONG_FILE_SCRATCH") > 0 && (l ~ /^SUBQ\.[LW] #\$?1,/ || l ~ /^SUB\.[LW] #\$?1,/)) has_scratch_dec = 1
    if ((index(l, "#13") > 0 || index(l, "#$D") > 0 || index(l, "#10") > 0 || index(l, "#$A") > 0) && l ~ /^CMP\.B /) has_crlf_check = 1
    if (l ~ /^CMP\.B D[0-7],D[0-7]$/) has_crlf_check = 1
    if (index(l, "GLOBAL_PTR_WORK_BUFFER") > 0 && (l ~ /^ADDQ\.[LW] #\$?1,/ || l ~ /^ADDQ\.[LW] #1,/ || l ~ /^ADD\.[LW] #\$?1,/ || l ~ /^SUBQ\.[LW] #\$?1,/ || l ~ /^MOVE\.L A[0-7],/)) has_ptr_inc = 1
    if (l ~ /^CLR\.B \(A[0-7]\)\+$/ || l ~ /^CLR\.B \(A[0-7]\)$/ || (index(l, "#0,") > 0 && l ~ /^MOVE\.B /)) has_store_nul = 1
    if (l ~ /^MOVEA\.W #\$?FFFF,A[0-7]$/ || l ~ /^MOVEA\.W #\(-1\),A[0-7]$/ || l ~ /^MOVE\.L #\$?0*FFFF,D[0-7]$/ || l ~ /^MOVE\.L #\$?0*FFFF,A[0-7]$/) has_sentinel = 1
    if (index(l, "GLOBAL_REF_LONG_FILE_SCRATCH") > 0 && (l ~ /^SUBQ\.[LW] #\$?1,/ || l ~ /^SUB\.[LW] #\$?1,/)) has_skip_trailing = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SCRATCH_DEC=" has_scratch_dec
    print "HAS_CRLF_CHECK=" has_crlf_check
    print "HAS_PTR_INC=" has_ptr_inc
    print "HAS_STORE_NUL=" has_store_nul
    print "HAS_SENTINEL=" has_sentinel
    print "HAS_SKIP_TRAILING=" has_skip_trailing
    print "HAS_RTS=" has_rts
}
