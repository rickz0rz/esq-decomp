BEGIN {
    has_label = 0
    has_save = 0
    has_wrap_loop = 0
    has_wrap_sub = 0
    has_divs32 = 0
    has_mulu32 = 0
    has_clock_format_table = 0
    has_copy_loop = 0
    has_digit_store3 = 0
    has_digit_store4 = 0
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
    uline = toupper(line)

    if (uline ~ /^CLEANUP_FORMATCLOCKFORMATENTRY:/) has_label = 1
    if (uline ~ /MOVEM.L D6-D7\/A2-A3,-\(A7\)/) has_save = 1
    if (uline ~ /\.WRAP_SLOT_INDEX_LOOP:/) has_wrap_loop = 1
    if (uline ~ /SUB.L D0,D7/) has_wrap_sub = 1
    if (uline ~ /GROUP_AG_JMPTBL_MATH_DIVS32/) has_divs32 = 1
    if (uline ~ /GROUP_AG_JMPTBL_MATH_MULU32/) has_mulu32 = 1
    if (uline ~ /GLOBAL_REF_STR_CLOCK_FORMAT/) has_clock_format_table = 1
    if (uline ~ /\.COPY_FORMAT_LOOP:/) has_copy_loop = 1
    if (uline ~ /MOVE.B D0,3\(A3\)/) has_digit_store3 = 1
    if (uline ~ /MOVE.B D1,4\(A3\)/) has_digit_store4 = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_WRAP_LOOP=" has_wrap_loop
    print "HAS_WRAP_SUB=" has_wrap_sub
    print "HAS_DIVS32=" has_divs32
    print "HAS_MULU32=" has_mulu32
    print "HAS_CLOCK_FORMAT_TABLE=" has_clock_format_table
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_DIGIT_STORE3=" has_digit_store3
    print "HAS_DIGIT_STORE4=" has_digit_store4
}
