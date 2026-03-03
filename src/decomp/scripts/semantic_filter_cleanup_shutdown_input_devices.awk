BEGIN {
    has_label = 0
    has_dio = 0
    has_mem_free = 0
    has_close_device = 0
    has_cleanup_msgport = 0
    has_iostdreq_free = 0
    has_input_ioreq = 0
    has_console_ioreq = 0
    has_input_buffer = 0
    has_tag_127 = 0
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

    if (uline ~ /^CLEANUP_SHUTDOWNINPUTDEVICES:/) has_label = 1
    if (uline ~ /LVODOIO/) has_dio = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_mem_free = 1
    if (uline ~ /LVOCLOSEDEVICE/) has_close_device = 1
    if (uline ~ /GROUP_AG_JMPTBL_IOSTDREQ_CLEANUPSIGNALANDMSGPORT/) has_cleanup_msgport = 1
    if (uline ~ /GROUP_AB_JMPTBL_IOSTDREQ_FREE/) has_iostdreq_free = 1
    if (uline ~ /GLOBAL_REF_IOSTDREQ_STRUCT_INPUT_DEVICE/) has_input_ioreq = 1
    if (uline ~ /GLOBAL_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE/) has_console_ioreq = 1
    if (uline ~ /GLOBAL_REF_DATA_INPUT_BUFFER/) has_input_buffer = 1
    if (uline ~ /PEA 127/ || uline ~ /#127/) has_tag_127 = 1
    if (uline ~ /LEA 16\(A7\),A7/ || uline ~ /LEA 16\(SP\),SP/) has_stack_fix = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_DOIO=" has_dio
    print "HAS_MEM_FREE=" has_mem_free
    print "HAS_CLOSE_DEVICE=" has_close_device
    print "HAS_CLEANUP_MSGPORT=" has_cleanup_msgport
    print "HAS_IOSTDREQ_FREE=" has_iostdreq_free
    print "HAS_INPUT_IOREQ=" has_input_ioreq
    print "HAS_CONSOLE_IOREQ=" has_console_ioreq
    print "HAS_INPUT_BUFFER=" has_input_buffer
    print "HAS_TAG_127=" has_tag_127
    print "HAS_STACK_FIX=" has_stack_fix
}
