BEGIN {
    has_label = 0
    has_wait_loop = 0
    has_find_task = 0
    has_state_logic = 0
    has_alloc = 0
    has_cleanup_store = 0
    has_seg_bptr = 0
    has_create_proc = 0
    has_rts = 0
}
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CTASKS_STARTIFFTASKPROCESS[A-Z0-9_]*:/) has_label = 1
    if (u ~ /WAIT_FOR_PRIOR_IFF_TASK/ || u ~ /BNE\.[BWS]? .*CTASKS_STARTIFFTASKPROCESS/ || u ~ /BNE\.[BWS]? .*__CTASKS_STARTIFFTASKPROCESS/) has_wait_loop = 1
    if (u ~ /_LVOFINDTASK/) has_find_task = 1
    if (u ~ /CTASKS_IFFTASKSTATE/ || u ~ /ESQIFF_ASSETSOURCESELECT/) has_state_logic = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_alloc = 1
    if (u ~ /CTASKS_IFFTASKCLEANUP/ || u ~ /MOVE\.L A0,10\(A1\)/) has_cleanup_store = 1
    if (u ~ /CTASKS_IFFTASKSEGLISTBPTR/) has_seg_bptr = 1
    if (u ~ /_LVOCREATEPROC/) has_create_proc = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_WAIT_LOOP=" has_wait_loop
    print "HAS_FIND_TASK=" has_find_task
    print "HAS_STATE_LOGIC=" has_state_logic
    print "HAS_ALLOC=" has_alloc
    print "HAS_CLEANUP_STORE=" has_cleanup_store
    print "HAS_SEG_BPTR=" has_seg_bptr
    print "HAS_CREATE_PROC=" has_create_proc
    print "HAS_RTS=" has_rts
}
