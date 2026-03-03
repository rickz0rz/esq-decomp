BEGIN {
    has_label = 0
    has_intb_const = 0
    has_struct_ref = 0
    has_remint = 0
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

    if (uline ~ /^CLEANUP_CLEARVERTBINTERRUPTSERVER:/) has_label = 1
    if (uline ~ /#INTB_VERTB/ || uline ~ /#5/) has_intb_const = 1
    if (uline ~ /GLOBAL_REF_INTERRUPT_STRUCT_INTB_VERTB/) has_struct_ref = 1
    if (uline ~ /LVOREMINTSERVER/) has_remint = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /STRUCT_INTERRUPT_SIZE/ || uline ~ /0X0C/ || uline ~ /#\\$0C/ || uline ~ /#12/ || uline ~ /PEA 12/) has_size = 1
    if (uline ~ /#57/ || uline ~ /PEA 57/) has_tag = 1
    if (uline ~ /GLOBAL_STR_CLEANUP_C_1/) has_cleanup_label = 1
    if (uline ~ /LEA 16\(A7\),A7/ || uline ~ /LEA 16\(SP\),SP/ || uline ~ /ADDQ\.W #4,A7/) has_stack_fix = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_INTB_CONST=" has_intb_const
    print "HAS_STRUCT_REF=" has_struct_ref
    print "HAS_REMINT=" has_remint
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_SIZE=" has_size
    print "HAS_TAG57=" has_tag
    print "HAS_CLEANUP_LABEL=" has_cleanup_label
    print "HAS_STACK_FIX=" has_stack_fix
}
