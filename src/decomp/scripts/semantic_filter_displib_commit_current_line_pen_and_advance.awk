BEGIN {
    has_entry = 0
    saw_len_table = 0
    saw_tst_len = 0
    saw_addq_index = 0
    saw_store_index = 0
    saw_load_target = 0
    saw_cmp_target = 0
    saw_pen_table = 0
    saw_pen_store = 0
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
    uline = toupper(line)

    if (uline ~ /^DISPLIB_COMMITCURRENTLINEPENANDADVANCE:/) has_entry = 1
    if (uline ~ /DISPTEXT_LINELENGTHTABLE/) saw_len_table = 1
    if (uline ~ /TST\.W \(A0\)/) saw_tst_len = 1
    if (uline ~ /ADDQ\.W #1,D1/) saw_addq_index = 1
    if (uline ~ /MOVE\.W D1,DISPTEXT_CURRENTLINEINDEX/) saw_store_index = 1
    if (uline ~ /DISPTEXT_TARGETLINEINDEX/) saw_load_target = 1
    if (uline ~ /CMP\.W D1,D0/) saw_cmp_target = 1
    if (uline ~ /DISPTEXT_LINEPENTABLE/) saw_pen_table = 1
    if (uline ~ /MOVE\.L D7,\(A0\)/) saw_pen_store = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_len_check = (saw_len_table && saw_tst_len) ? 1 : 0
    has_index_advance = (saw_addq_index && saw_store_index) ? 1 : 0
    has_target_compare = (saw_load_target && saw_cmp_target) ? 1 : 0
    has_pen_write = (saw_pen_table && saw_pen_store) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_LEN_CHECK=" has_len_check
    print "HAS_INDEX_ADVANCE=" has_index_advance
    print "HAS_TARGET_COMPARE=" has_target_compare
    print "HAS_PEN_WRITE=" has_pen_write
    print "HAS_RETURN=" has_return
}
