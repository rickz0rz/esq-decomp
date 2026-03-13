BEGIN {
    saw_normalize_call = 0
    saw_mulu32_call = 0
    saw_seconds_to_struct_call = 0
    saw_clear_out_field = 0
    saw_return = 0
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

    if (u ~ /DATETIME_NORMALIZESTRUCTTOSECOND/) saw_normalize_call = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_MULU32/ || u ~ /MATH_MULU32/) saw_mulu32_call = 1
    if (u ~ /DATETIME_SECONDSTOSTRUCT/) saw_seconds_to_struct_call = 1
    if (u ~ /CLR\\.W 14\\(A2\\)/ || u ~ /CLR\\.W 14\\(A[0-7]\\)/ || u ~ /^CLR\\.W \\(A0\\)$/ || u ~ /^LEA \\$E\\(A3\\),A0$/) saw_clear_out_field = 1
    if (u ~ /^RTS$/) saw_return = 1
}

END {
    print "HAS_NORMALIZE_CALL=" saw_normalize_call
    print "HAS_MULU32_CALL=" saw_mulu32_call
    print "HAS_SECONDS_TO_STRUCT_CALL=" saw_seconds_to_struct_call
    print "HAS_CLEAR_OUT_FIELD=" saw_clear_out_field
    print "HAS_RTS=" saw_return
}
