BEGIN {
    has_entry = 0
    has_test = 0
    has_expected_bit = 0
    has_fmt_call = 0
    has_expected_string = 0
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

    if (line ~ /^BTST / || line ~ /^ANDI\.[BWL] / || line ~ /^AND\.[BWL] / || line ~ /^TST\.[BWL] /) has_test = 1
    if (EXPECTED_BIT != "" && line ~ /^BTST #[\$]?[0-9A-F]+,/ ) {
        bit_line = line
        sub(/^BTST #/, "", bit_line)
        sub(/,.*/, "", bit_line)
        gsub(/\$/, "", bit_line)
        if ((bit_line + 0) == (EXPECTED_BIT + 0)) has_expected_bit = 1
    }
    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRAT/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) has_fmt_call = 1
    if (FORMAT_LABEL_PREFIX != "" && index(line, "PEA " FORMAT_LABEL_PREFIX) == 1) has_expected_string = 1
    if (TARGET_PREFIX != "" && line ~ /^(B[A-Z]+|JMP|JSR)(\.[A-Z]+)? / && index(line, TARGET_PREFIX) > 0) has_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEST=" has_test
    print "HAS_EXPECTED_BIT=" has_expected_bit
    print "HAS_FMT_CALL=" has_fmt_call
    print "HAS_EXPECTED_STRING=" has_expected_string
    print "HAS_TRANSFER=" has_transfer
}
