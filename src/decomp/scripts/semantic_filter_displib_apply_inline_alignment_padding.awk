BEGIN {
    has_entry = 0
    has_return_entry = 0
    has_textlength_call = 0
    has_space_compute = 0
    saw_mode24 = 0
    saw_mode26 = 0
    saw_mode_branch = 0
    has_div_call = 0
    has_alloc = 0
    has_append_at_null = 0
    has_dealloc = 0
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

    if (uline ~ /^DISPLIB_APPLYINLINEALIGNMENTPADDING:/) has_entry = 1
    if (uline ~ /^DISPLIB_APPLYINLINEALIGNMENTPADDING_RETURN:/) has_return_entry = 1
    if (uline ~ /LVOTEXTLENGTH\(A6\)/) has_textlength_call = 1
    if (uline ~ /MOVE\.L #624,D1/ || uline ~ /SUB\.L D0,D1/) has_space_compute = 1
    if (uline ~ /MOVEQ #24,D0/) saw_mode24 = 1
    if (uline ~ /MOVEQ #26,D0/) saw_mode26 = 1
    if (uline ~ /CMP\.B D0,D7/ || uline ~ /BNE\.S \.LAB_0555/ || uline ~ /BNE\.S \.BRANCH/) saw_mode_branch = 1
    if (uline ~ /GROUP_AG_JMPTBL_MATH_DIVS32/) has_div_call = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/) has_alloc = 1
    if (uline ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/) has_append_at_null = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_align_mode_branch = (saw_mode24 && saw_mode26 && saw_mode_branch) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN_ENTRY=" has_return_entry
    print "HAS_TEXTLENGTH_CALL=" has_textlength_call
    print "HAS_SPACE_COMPUTE=" has_space_compute
    print "HAS_ALIGN_MODE_BRANCH=" has_align_mode_branch
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_ALLOC=" has_alloc
    print "HAS_APPEND_AT_NULL=" has_append_at_null
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RETURN=" has_return
}
