BEGIN {
    has_label = 0
    has_set_cmd = 0
    has_set_data = 0
    has_doio = 0
    has_dealloc = 0
    has_line_127 = 0
    has_size_20 = 0
    has_close_device = 0
    has_cleanup_msgport = 0
    has_iostd_free = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_SHUTDOWNINPUTDEVICES[A-Z0-9_]*:/) has_label = 1
    if (u ~ /#10/ || u ~ /#\$A/ || u ~ /MOVE\.W #10,28\(A0\)/) has_set_cmd = 1
    if (u ~ /40\(A0\)/ || u ~ /GLOBAL_REF_DATA_INPUT_BUFFER/) has_set_data = 1
    if (u ~ /_LVODOIO/) has_doio = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOC/) has_dealloc = 1
    if (u ~ /#127/ || u ~ /#\$7F/ || u ~ /PEA 127\.W/ || u ~ /PEA \(\$7F\)\.W/) has_line_127 = 1
    if (u ~ /STRUCT_INPUTEVENT_SIZE/ || u ~ /#20/ || u ~ /#\$14/ || u ~ /PEA \(\$14\)\.W/ || u ~ /PEA 20\.W/) has_size_20 = 1
    if (u ~ /_LVOCLOSEDEVICE/) has_close_device = 1
    if (u ~ /CLEANUPSIGNALANDMSGPORT/ || u ~ /IOSTDREQ_CLEANUPSIGNALANDMSG/ || u ~ /IOSTDREQ_CLEANUP/) has_cleanup_msgport = 1
    if (u ~ /IOSTDREQ_FREE/ || u ~ /GROUP_AB_JMPTBL_IOSTDREQ_FREE/) has_iostd_free = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SET_CMD=" has_set_cmd
    print "HAS_SET_DATA=" has_set_data
    print "HAS_DOIO=" has_doio
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_LINE_127=" has_line_127
    print "HAS_SIZE_20=" has_size_20
    print "HAS_CLOSE_DEVICE=" has_close_device
    print "HAS_CLEANUP_MSGPORT=" has_cleanup_msgport
    print "HAS_IOSTD_FREE=" has_iostd_free
    print "HAS_RETURN=" has_return
}
