BEGIN {
    has_entry = 0
    has_probe = 0
    has_create_msgport = 0
    create_msgport_calls = 0
    has_alloc_iostdreq = 0
    alloc_iostdreq_calls = 0
    has_open_device = 0
    open_device_calls = 0
    has_alloc_mem = 0
    has_doio = 0
    has_input_buf_ref = 0
    has_state_reset = 0
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
    u = toupper(line)

    if (u ~ /^KYBD_INITIALIZEINPUTDEV[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "GROUP_AV_JMPTBL_DISKIO_PROBEDRIVESANDASSIGNPATHS") > 0 || index(u, "GROUP_AV_JMPTBL_DISKIO_PROBEDR") > 0) has_probe = 1

    if (index(u, "GROUP_AV_JMPTBL_SIGNAL_CREATEMSGPORTWITHSIGNAL") > 0 || index(u, "GROUP_AV_JMPTBL_SIGNAL_CREATEM") > 0) {
        has_create_msgport = 1
        create_msgport_calls += 1
    }

    if (index(u, "GROUP_AV_JMPTBL_ALLOCATE_ALLOCANDINITIALIZEIOSTDREQ") > 0 || index(u, "GROUP_AV_JMPTBL_ALLOCATE_ALLOC") > 0) {
        has_alloc_iostdreq = 1
        alloc_iostdreq_calls += 1
    }

    if (index(u, "_LVOOPENDEVICE") > 0) {
        has_open_device = 1
        open_device_calls += 1
    }

    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCAT") > 0) has_alloc_mem = 1
    if (index(u, "_LVODOIO") > 0) has_doio = 1

    if (index(u, "GLOBAL_REF_DATA_INPUT_BUFFER") > 0) has_input_buf_ref = 1

    if ((index(u, "ED_STATERINGWRITEINDEX") > 0 || index(u, "ED_STATERINGINDEX") > 0) && (u ~ /^MOVE\.L / || u ~ /^CLR\.L /)) has_state_reset = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROBE=" has_probe
    print "HAS_CREATE_MSGPORT=" has_create_msgport
    print "HAS_CREATE_MSGPORT_2=" (create_msgport_calls >= 2 ? 1 : 0)
    print "HAS_ALLOC_IOSTDREQ=" has_alloc_iostdreq
    print "HAS_ALLOC_IOSTDREQ_2=" (alloc_iostdreq_calls >= 2 ? 1 : 0)
    print "HAS_OPEN_DEVICE=" has_open_device
    print "HAS_OPEN_DEVICE_2=" (open_device_calls >= 2 ? 1 : 0)
    print "HAS_ALLOC_MEM=" has_alloc_mem
    print "HAS_DOIO=" has_doio
    print "HAS_INPUT_BUF_REF=" has_input_buf_ref
    print "HAS_STATE_RESET=" has_state_reset
    print "HAS_RETURN=" has_return
}
