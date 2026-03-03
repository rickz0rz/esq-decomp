BEGIN {
    has_label = 0
    has_intena = 0
    has_intb_const = 0
    has_vector_ref = 0
    has_setint = 0
    has_dealloc = 0
    has_size = 0
    has_tag = 0
    has_cleanup_label = 0
    has_stack_fix = 0
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

    if (uline ~ /^CLEANUP_CLEARAUD1INTERRUPTVECTOR:/) has_label = 1
    if (uline ~ /INTENA/ && (uline ~ /100/ || uline ~ /0X100/ || uline ~ /256/)) has_intena = 1
    if (uline ~ /#INTB_AUD1/ || uline ~ /#7/) has_intb_const = 1
    if (uline ~ /GLOBAL_REF_INTB_AUD1_INTERRUPT/) has_vector_ref = 1
    if (uline ~ /LVOSETINTVECTOR/) has_setint = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /PEA 22/ || uline ~ /#22/) has_size = 1
    if (uline ~ /PEA 74/ || uline ~ /#74/) has_tag = 1
    if (uline ~ /GLOBAL_STR_CLEANUP_C_2/) has_cleanup_label = 1
    if (uline ~ /LEA 16\(A7\),A7/ || uline ~ /LEA 16\(SP\),SP/) has_stack_fix = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_INTENA=" has_intena
    print "HAS_INTB_CONST=" has_intb_const
    print "HAS_VECTOR_REF=" has_vector_ref
    print "HAS_SETINT=" has_setint
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_SIZE22=" has_size
    print "HAS_TAG74=" has_tag
    print "HAS_CLEANUP_LABEL=" has_cleanup_label
    print "HAS_STACK_FIX=" has_stack_fix
}
