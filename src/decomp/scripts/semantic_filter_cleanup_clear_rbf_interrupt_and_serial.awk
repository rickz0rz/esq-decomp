BEGIN {
    has_label = 0
    has_intena = 0
    has_close_device = 0
    has_cleanup_msgport = 0
    has_free_ioreq = 0
    has_set_vector = 0
    has_intb_const = 0
    has_buffer_free = 0
    has_struct_free = 0
    has_tag_113 = 0
    has_tag_118 = 0
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

    if (uline ~ /^CLEANUP_CLEARRBFINTERRUPTANDSERIAL:/) has_label = 1
    if (uline ~ /INTENA/ && (uline ~ /800/ || uline ~ /0X800/ || uline ~ /2048/)) has_intena = 1
    if (uline ~ /LVOCLOSEDEVICE/) has_close_device = 1
    if (uline ~ /GROUP_AG_JMPTBL_IOSTDREQ_CLEANUPSIGNALANDMSGPORT/) has_cleanup_msgport = 1
    if (uline ~ /GROUP_AG_JMPTBL_STRUCT_FREEWITHSIZEFIELD/) has_free_ioreq = 1
    if (uline ~ /LVOSETINTVECTOR/) has_set_vector = 1
    if (uline ~ /#INTB_RBF/ || uline ~ /#11/) has_intb_const = 1
    if (uline ~ /GLOBAL_REF_INTB_RBF_64K_BUFFER/ && uline ~ /DEALLOCATEMEMORY/) has_buffer_free = 1
    if (uline ~ /GLOBAL_REF_INTERRUPT_STRUCT_INTB_RBF/ && uline ~ /DEALLOCATEMEMORY/) has_struct_free = 1
    if (uline ~ /PEA 113/ || uline ~ /#113/) has_tag_113 = 1
    if (uline ~ /PEA 118/ || uline ~ /#118/) has_tag_118 = 1
    if (uline ~ /LEA 32\(A7\),A7/ || uline ~ /LEA 32\(SP\),SP/) has_stack_fix = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_INTENA=" has_intena
    print "HAS_CLOSE_DEVICE=" has_close_device
    print "HAS_CLEANUP_MSGPORT=" has_cleanup_msgport
    print "HAS_FREE_IOREQ=" has_free_ioreq
    print "HAS_SET_VECTOR=" has_set_vector
    print "HAS_INTB_CONST=" has_intb_const
    print "HAS_BUFFER_FREE=" has_buffer_free
    print "HAS_STRUCT_FREE=" has_struct_free
    print "HAS_TAG_113=" has_tag_113
    print "HAS_TAG_118=" has_tag_118
    print "HAS_STACK_FIX=" has_stack_fix
}
