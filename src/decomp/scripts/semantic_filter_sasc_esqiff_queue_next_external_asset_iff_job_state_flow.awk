BEGIN {
    has_entry = 0
    has_task_done_gate = 0
    has_quota_gate = 0
    has_read_next_path = 0
    has_rewrite_bang = 0
    has_wildcard_lookup = 0
    has_prefix_reject = 0
    has_restore_match_index = 0
    has_logo_poll_limit = 0
    has_gads_poll_limit = 0
    has_snapshot_candidate = 0
    has_load_logo_head = 0
    has_load_gads_head = 0
    has_compare_selected_head_to_logo_head = 0
    has_duplicate_logo_head_path = 0
    has_alloc_pending_brush = 0
    has_store_pending_node = 0
    has_store_pending_descriptor = 0
    has_start_iff_task = 0
    has_process_grid_messages = 0
    has_no_candidate_sentinel = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)
    norm = uline
    gsub(/[^A-Z0-9]/, "", norm)

    if (uline ~ /^ESQIFF_QUEUENEXTEXTERNALASSETIFFJOB:/ || uline ~ /^ESQIFF_QUEUENEXTEXTERNALASSET[A-Z0-9_]*:/) {
        has_entry = 1
    }
    if (norm ~ /CTASKSIFFTASKDONEFLAG/) {
        has_task_done_gate = 1
    }
    if (norm ~ /ESQIFFLOGOBRUSHLISTCOUNT/ || norm ~ /ESQIFFGADSBRUSHLISTCOUNT/) {
        has_quota_gate = 1
    }
    if (norm ~ /ESQIFFREADNEXTEXTERNALASSETPATHENTRY/ || norm ~ /ESQIFFREADNEXTEXTERNALASSETPATH/) {
        has_read_next_path = 1
    }
    if (uline ~ /#\$2A/ || uline ~ /'\*'/ || norm ~ /MOVEB42/) {
        has_rewrite_bang = 1
    }
    if (norm ~ /TEXTDISPFINDENTRYINDEXBYWILDCARD/ || norm ~ /TEXTDISPFINDENTRYINDEXBYWIL/) {
        has_wildcard_lookup = 1
    }
    if (norm ~ /ESQIFFHASREJECTEDASSETPREFIX/ || norm ~ /STRINGCOMPAR/ || norm ~ /ESQIFFPATHDF0COLON/ || norm ~ /ESQIFFPATHRAMCOLONLOGOSSLASH/) {
        has_prefix_reject = 1
    }
    if (norm ~ /TEXTDISPCURRENTMATCHINDEX/ && uline ~ /^MOVE\.W .*TEXTDISP_CURRENTMATCHINDEX/) {
        has_restore_match_index = 1
    }
    if (uline ~ /^MOVE\.L #\$FA00,/ || uline ~ /^MOVE\.L #64000,/) {
        has_logo_poll_limit = 1
    }
    if (uline ~ /^MOVE\.L #\$13880,/ || uline ~ /^MOVE\.L #80000,/) {
        has_gads_poll_limit = 1
    }
    if (norm ~ /ESQIFFCOPYCSTRING/ || uline ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/) {
        has_snapshot_candidate = 1
    }
    if (norm ~ /ESQIFFLOGOBRUSHLISTHEAD/ && norm !~ /CMPLESQIFFLOGOBRUSHLISTHEADA0/ && norm !~ /CMPAESQIFFLOGOBRUSHLISTHEADA0/) {
        has_load_logo_head = 1
    }
    if (norm ~ /ESQIFFGADSBRUSHLISTHEAD/) {
        has_load_gads_head = 1
    }
    if (norm ~ /CMPALESQIFFLOGOBRUSHLISTHEADA0/ || norm ~ /CMPLESQIFFLOGOBRUSHLISTHEADA0/ || norm ~ /CMPLA0A5/ || norm ~ /CMPA0A5/) {
        has_compare_selected_head_to_logo_head = 1
    }
    if (norm ~ /ESQIFFSTRINGEQUALS/ || uline ~ /^CMP\.B \(A1\)\+,D0$/ || uline ~ /^CMP\.B \(A[0-7]\)\+,D0$/) {
        has_duplicate_logo_head_path = 1
    }
    if (norm ~ /BRUSHALLOCBRUSHNODE/) {
        has_alloc_pending_brush = 1
    }
    if (norm ~ /ESQIFFPENDINGEXTERNALBRUSHNODE/) {
        has_store_pending_node = 1
    }
    if (norm ~ /CTASKSPENDINGLOGOBRUSHDESCRIPTOR/ || norm ~ /CTASKSPENDINGLOGOBRUSHDESCRIPTO/ || norm ~ /CTASKSPENDINGGADSBRUSHDESCRIPTOR/ || norm ~ /CTASKSPENDINGGADSBRUSHDESCRIPTO/) {
        has_store_pending_descriptor = 1
    }
    if (norm ~ /CTASKSSTARTIFFTASKPROCESS/) {
        has_start_iff_task = 1
    }
    if (norm ~ /ESQDISPPROCESSGRIDMESSAGESIFIDLE/ || norm ~ /ESQDISPPROCESSGRIDMESSAGESIFIDL/) {
        has_process_grid_messages = 1
    }
    if (uline ~ /^MOVE\.W #\$FFFFFFFF,/ || uline ~ /^MOVEQ(\.L)? #?-?1,D0$/ || norm ~ /CMPWBAA7D0/) {
        has_no_candidate_sentinel = 1
    }
    if (uline == "RTS") {
        has_rts = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TASK_DONE_GATE=" has_task_done_gate
    print "HAS_QUOTA_GATE=" has_quota_gate
    print "HAS_READ_NEXT_PATH=" has_read_next_path
    print "HAS_REWRITE_BANG=" has_rewrite_bang
    print "HAS_WILDCARD_LOOKUP=" has_wildcard_lookup
    print "HAS_PREFIX_REJECT_GATES=" has_prefix_reject
    print "HAS_RESTORE_MATCH_INDEX=" has_restore_match_index
    print "HAS_LOGO_POLL_LIMIT=" has_logo_poll_limit
    print "HAS_GADS_POLL_LIMIT=" has_gads_poll_limit
    print "HAS_SNAPSHOT_CANDIDATE=" has_snapshot_candidate
    print "HAS_LOAD_LOGO_HEAD=" has_load_logo_head
    print "HAS_LOAD_GADS_HEAD=" has_load_gads_head
    print "HAS_COMPARE_SELECTED_HEAD_TO_LOGO_HEAD=" has_compare_selected_head_to_logo_head
    print "HAS_DUPLICATE_LOGO_HEAD_PATH_CHECK=" has_duplicate_logo_head_path
    print "HAS_ALLOC_PENDING_BRUSH=" has_alloc_pending_brush
    print "HAS_STORE_PENDING_NODE=" has_store_pending_node
    print "HAS_STORE_PENDING_DESCRIPTOR=" has_store_pending_descriptor
    print "HAS_START_IFF_TASK=" has_start_iff_task
    print "HAS_PROCESS_GRID_MESSAGES=" has_process_grid_messages
    print "HAS_NO_CANDIDATE_SENTINEL=" has_no_candidate_sentinel
    print "HAS_RTS=" has_rts
}
