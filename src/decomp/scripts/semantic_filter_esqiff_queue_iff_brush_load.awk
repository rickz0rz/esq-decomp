BEGIN {
    has_entry = 0
    has_alloc = 0
    has_clone = 0
    has_start_iff = 0
    has_dealloc = 0
    has_overlay = 0
    has_select_label = 0
    has_find_pred = 0
    has_find_type3 = 0
    has_pending_desc = 0
    has_task_state = 0
    has_cursor_advance = 0
    has_rts = 0
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

    if (uline ~ /^ESQIFF_QUEUEIFFBRUSHLOAD:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_ALLOCBRUSHNODE/) has_alloc = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_CLONEBRUSHRECORD/) has_clone = 1
    if (uline ~ /ESQIFF_JMPTBL_CTASKS_STARTIFFTASKPROCESS/) has_start_iff = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /ESQIFF_DRAWWEATHERSTATUSOVERLAYINTOBRUSH/) has_overlay = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHBYLABEL/) has_select_label = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FINDBRUSHBYPREDICATE/) has_find_pred = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FINDTYPE3BRUSH/) has_find_type3 = 1
    if (uline ~ /^MOVE\.L D0,CTASKS_PENDINGIFFBRUSHDESCRIPTOR$/) has_pending_desc = 1
    if (uline ~ /^MOVE\.W #6,CTASKS_IFFTASKSTATE$/) has_task_state = 1
    if (uline ~ /^MOVE\.L 234\(A0\),ESQIFF_BANNERBRUSHRESOURCECURSOR$/) has_cursor_advance = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ALLOC=" has_alloc
    print "HAS_CLONE=" has_clone
    print "HAS_START_IFF=" has_start_iff
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_OVERLAY=" has_overlay
    print "HAS_SELECT_LABEL=" has_select_label
    print "HAS_FIND_PRED=" has_find_pred
    print "HAS_FIND_TYPE3=" has_find_type3
    print "HAS_PENDING_DESC=" has_pending_desc
    print "HAS_TASK_STATE=" has_task_state
    print "HAS_CURSOR_ADVANCE=" has_cursor_advance
    print "HAS_RTS=" has_rts
}
