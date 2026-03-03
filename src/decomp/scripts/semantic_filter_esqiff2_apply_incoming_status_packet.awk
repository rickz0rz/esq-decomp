BEGIN {
    has_entry = 0
    has_save = 0
    has_copy_loop = 0
    has_filter_guard = 0
    has_deferred_flag = 0
    has_speed_clamp = 0
    has_banner_queue = 0
    has_banner_draw = 0
    has_seed_thresholds = 0
    has_diag_draw = 0
    has_saved_idx_gate = 0
    has_state_write = 0
    has_return_branch = 0
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

    if (uline ~ /^ESQIFF2_APPLYINCOMINGSTATUSPACKET:/) has_entry = 1
    if (uline ~ /^MOVEM\.L D2\/D6-D7\/A3,-\(A7\)$/) has_save = 1
    if (uline ~ /^MOVE\.B 0\(A3,D7\.W\),\(A0\)$/) has_copy_loop = 1
    if (uline ~ /^TST\.L LOCAVAIL_FILTERMODEFLAG$/) has_filter_guard = 1
    if (uline ~ /^MOVE\.L D0,SCRIPT_RUNTIMEMODEDEFERREDFLAG$/) has_deferred_flag = 1
    if (uline ~ /^MOVE\.B #\$36,ESQ_STR_6$/) has_speed_clamp = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_DST_UPDATEBANNERQUEUE\(PC\)$/) has_banner_queue = 1
    if (uline ~ /^JSR ESQDISP_DRAWSTATUSBANNER\(PC\)$/) has_banner_draw = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_ESQ_SEEDMINUTEEVENTTHRESHOLDS\(PC\)$/) has_seed_thresholds = 1
    if (uline ~ /^JSR ED_DRAWDIAGNOSTICMODETEXT\(PC\)$/) has_diag_draw = 1
    if (uline ~ /^TST\.L ED_SAVEDSCROLLSPEEDINDEX$/) has_saved_idx_gate = 1
    if (uline ~ /^MOVE\.W D7,ESQPARS2_STATEINDEX$/ || uline ~ /^MOVE\.W #4,ESQPARS2_STATEINDEX$/) has_state_write = 1
    if (uline ~ /^BNE\.[SW] ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN$/ || uline ~ /^BRA\.[SW] ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN$/ || uline ~ /^JMP ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_FILTER_GUARD=" has_filter_guard
    print "HAS_DEFERRED_FLAG=" has_deferred_flag
    print "HAS_SPEED_CLAMP=" has_speed_clamp
    print "HAS_BANNER_QUEUE=" has_banner_queue
    print "HAS_BANNER_DRAW=" has_banner_draw
    print "HAS_SEED_THRESHOLDS=" has_seed_thresholds
    print "HAS_DIAG_DRAW=" has_diag_draw
    print "HAS_SAVED_IDX_GATE=" has_saved_idx_gate
    print "HAS_STATE_WRITE=" has_state_write
    print "HAS_RETURN_BRANCH=" has_return_branch
}
