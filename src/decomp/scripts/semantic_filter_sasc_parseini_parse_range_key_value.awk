BEGIN {
    has_entry = 0
    has_find_eq = 0
    has_table_done_validate = 0
    has_color_index_reset = 0
    has_range_len_adjust = 0
    has_range_assign_bounds = 0
    has_parse_hex = 0
    has_range_assign_store = 0
    has_return = 0
    count_skip_class3 = 0
    count_find_any_char = 0
    count_compare_nocase_n = 0
    count_parse_signed = 0
    saw_tag_table = 0
    saw_tag_done = 0
    saw_validate = 0
    saw_range_index_write = 0
    saw_minus_one = 0
    saw_range_guard_compare = 0
    saw_range_guard_test = 0
    saw_guard_branch = 0
    saw_shift7 = 0
    saw_slot_scale = 0
    saw_store_word = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^PARSEINI_PARSERANGEKEYVALUE:/ || u ~ /^PARSEINI_PARSERANGEKEYVALU[A-Z0-9_]*:/) has_entry = 1

    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || n ~ /STRFINDCHARPTR/ || u ~ /PEA 61\.W/ || u ~ /PEA \(\$3D\)\.W/) has_find_eq = 1

    if (n ~ /STRSKIPCLASS3CHARS/ || n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHARS/) count_skip_class3++
    if (n ~ /STRFINDANYCHARPTR/ || n ~ /PARSEINIJMPTBLSTRFINDANYCHARPTR/) count_find_any_char++
    if (n ~ /STRINGCOMPARENOCASEN/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASEN/) count_compare_nocase_n++
    if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) count_parse_signed++

    if (n ~ /PARSEINITAGTABLE/) saw_tag_table = 1
    if (n ~ /PARSEINITAGDONE/) saw_tag_done = 1
    if (n ~ /GCOMMANDVALIDATEPRESETTABLE/) saw_validate = 1

    if (n ~ /PARSEINICURRENTRANGETABLEINDEX/) saw_range_index_write = 1
    if (u ~ /MOVEQ #?-1,D[0-7]/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) saw_minus_one = 1

    if ((u ~ /CMP\.[WL] .*#1/ || u ~ /CMP\.[WL] #1,/ || u ~ /CMP\.[WL] .*#\$1/ || u ~ /CMP\.[WL] #\$1,/) &&
        (u ~ /CMP\.[WL] .*#63/ || u ~ /CMP\.[WL] .*#\$3F/ || u ~ /CMP\.[WL] #63,/ || u ~ /CMP\.[WL] #\$3F,/) ||
        u ~ /ADDQ\.[WL] #1,D[0-7]/ || u ~ /ADDQ\.L #\$1,D[0-7]/) has_range_len_adjust = 1

    if (u ~ /CMP\.[WL] .*#16/ || u ~ /CMP\.[WL] .*#\$10/ || u ~ /CMP\.[WL] .*#\$1000/) saw_range_guard_compare = 1
    if (u ~ /TST\.[WL] D[0-7]/ || u ~ /MOVE\.W .*0\(A[0-7],D[0-7]\.L\)/) saw_range_guard_test = 1
    if (u ~ /BGE\./ || u ~ /BLE\./ || u ~ /BLT\./ || u ~ /BMI\./) saw_guard_branch = 1

    if (n ~ /PARSEINIPARSEHEXVALUEFROMSTRING/ || n ~ /PARSEINIPARSEHEXVALUEFROMSTRIN/) has_parse_hex = 1

    if (u ~ /ASL\.L #7/ || u ~ /ASL\.L #\$7/) saw_shift7 = 1
    if (u ~ /ADD\.L D[0-7],D[0-7]/ || u ~ /ADD\.L D[0-7],A0/ || u ~ /ADDA\.L D[0-7],A0/) saw_slot_scale = 1
    if (u ~ /LEA \$20\(A[0-7]\),A1/ || u ~ /MOVE\.W .*32\(A[0-7]\)/ || u ~ /^MOVE\.W D[0-7],\(A1\)$/) saw_store_word = 1

    if (u == "RTS") has_return = 1
}

END {
    if (saw_tag_table && saw_tag_done && saw_validate) has_table_done_validate = 1
    if (saw_range_index_write && saw_minus_one) has_color_index_reset = 1
    if (saw_range_index_write && saw_range_guard_test && (saw_range_guard_compare || saw_guard_branch)) has_range_assign_bounds = 1
    if (saw_shift7 && saw_slot_scale && saw_store_word) has_range_assign_store = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_FIND_EQ=" has_find_eq
    print "COUNT_SKIP_CLASS3=" count_skip_class3
    print "COUNT_FIND_ANY_CHAR=" count_find_any_char
    print "COUNT_COMPARE_NOCASE_N=" count_compare_nocase_n
    print "COUNT_PARSE_SIGNED=" count_parse_signed
    print "HAS_TABLE_DONE_VALIDATE=" has_table_done_validate
    print "HAS_COLOR_INDEX_RESET=" has_color_index_reset
    print "HAS_RANGE_LEN_ADJUST=" has_range_len_adjust
    print "HAS_RANGE_ASSIGN_BOUNDS=" has_range_assign_bounds
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_RANGE_ASSIGN_STORE=" has_range_assign_store
    print "HAS_RETURN=" has_return
}
