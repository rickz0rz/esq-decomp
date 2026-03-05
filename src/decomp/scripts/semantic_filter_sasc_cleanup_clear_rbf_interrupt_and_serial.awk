BEGIN {
    has_label = 0
    has_intena = 0
    has_close_device = 0
    has_cleanup_msgport = 0
    has_free_struct = 0
    has_setintvector = 0
    has_dealloc = 0
    has_size_64000 = 0
    has_line_113 = 0
    has_line_118 = 0
    has_size_22 = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_CLEARRBFINTERRUPTANDSERIAL[A-Z0-9_]*:/ || u ~ /^CLEANUP_CLEARRBFINTERRUPTANDSERI[A-Z0-9_]*:/) has_label = 1
    if (u ~ /INTENA/ || u ~ /#\$800/ || u ~ /#2048/) has_intena = 1
    if (u ~ /_LVOCLOSEDEVICE/) has_close_device = 1
    if (u ~ /CLEANUPSIGNALANDMSGPORT/ || u ~ /IOSTDREQ_CLEANUPSIGNALANDMSG/ || u ~ /IOSTDREQ_CLEANUP/) has_cleanup_msgport = 1
    if (u ~ /STRUCT_FREEWITHSIZEFIELD/ || u ~ /STRUCT_FREEWITHSIZEFIEL/ || u ~ /STRUCT_FREEWITHS/) has_free_struct = 1
    if (u ~ /_LVOSETINTVECTOR/) has_setintvector = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOC/) has_dealloc = 1
    if (u ~ /#64000/ || u ~ /#\$FA00/) has_size_64000 = 1
    if (u ~ /#113/ || u ~ /#\$71/ || u ~ /PEA 113\.W/ || u ~ /PEA \(\$71\)\.W/) has_line_113 = 1
    if (u ~ /#118/ || u ~ /#\$76/ || u ~ /PEA 118\.W/ || u ~ /PEA \(\$76\)\.W/) has_line_118 = 1
    if (u ~ /#22/ || u ~ /#\$16/ || u ~ /PEA 22\.W/ || u ~ /PEA \(\$16\)\.W/) has_size_22 = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_INTENA=" has_intena
    print "HAS_CLOSE_DEVICE=" has_close_device
    print "HAS_CLEANUP_MSGPORT=" has_cleanup_msgport
    print "HAS_FREE_STRUCT=" has_free_struct
    print "HAS_SETINTVECTOR=" has_setintvector
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_SIZE_64000=" has_size_64000
    print "HAS_LINE_113=" has_line_113
    print "HAS_LINE_118=" has_line_118
    print "HAS_SIZE_22=" has_size_22
    print "HAS_RETURN=" has_return
}
