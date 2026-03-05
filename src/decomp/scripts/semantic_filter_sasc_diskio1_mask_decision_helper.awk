BEGIN {
    has_entry = 0
    has_condition = 0
    has_fmt_call = 0
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

    if (line ~ /^CMPI\.[BWL] / || line ~ /^CMP\.[BWL] / || line ~ /^TST\.[BWL] /) has_condition = 1
    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) has_fmt_call = 1
    if (TARGET_PREFIX != "" && line ~ /^(B[A-Z]+|JMP|JSR)(\.[A-Z]+)? / && index(line, TARGET_PREFIX) > 0) has_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CONDITION=" has_condition
    print "HAS_FMT_CALL=" has_fmt_call
    print "HAS_TRANSFER=" has_transfer
}
