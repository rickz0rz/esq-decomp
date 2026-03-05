BEGIN {
    has_entry = 0
    has_mask_fmt = 0
    has_fmt_call = 0
    has_sum_reset = 0
    has_index_reset = 0
    has_transfer = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (FMT_PREFIX != "" && index(line, FMT_PREFIX) > 0) has_mask_fmt = 1
    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) has_fmt_call = 1
    if (line ~ /^MOVEQ(\.[BWL])? #\$?0,D5/ || line ~ /^CLR\.[BWL] .*MASKDECISIONSUM/ || line ~ /^MOVE\.[BWL] #\$?0,.*MASKDECISIONSUM/ || line ~ /^CLR\.[BWL] __MERGEDBSS\+\$C\(A4\)$/) has_sum_reset = 1
    if (line ~ /^MOVEQ(\.[BWL])? #\$?0,D6/ || line ~ /^CLR\.[BWL] .*MASKARRAYINDEX/ || line ~ /^MOVE\.[BWL] #\$?0,.*MASKARRAYINDEX/ || line ~ /^CLR\.[BWL] __MERGEDBSS\+\$10\(A4\)$/) has_index_reset = 1
    if (TARGET_PREFIX != "" && line ~ /^(B[A-Z]+|JMP|JSR)(\.[A-Z]+)? / && index(line, TARGET_PREFIX) > 0) has_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MASK_FMT=" has_mask_fmt
    print "HAS_FMT_CALL=" has_fmt_call
    print "HAS_SUM_RESET=" has_sum_reset
    print "HAS_INDEX_RESET=" has_index_reset
    print "HAS_TRANSFER=" has_transfer
}
