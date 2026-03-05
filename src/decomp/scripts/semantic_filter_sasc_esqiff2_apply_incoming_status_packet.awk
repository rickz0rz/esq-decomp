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
    u = toupper(line)

    if (u ~ /^ESQIFF2_APPLYINCOMINGSTATUSPACKET:/ || u ~ /^ESQIFF2_APPLYINCOMINGSTATUSP[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEM\.L D2\/D6-D7\/A3,-\(A7\)$/ || u ~ /^MOVEM\.L [DA][0-7].*,-\(A7\)$/) has_save = 1
    if (u ~ /^MOVE\.B 0\(A3,D7\.W\),\(A0\)$/ || u ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.[WL]\),\(A[0-7]\)$/ || u ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.[WL]\),\$0\(A[0-7],D[0-7]\.[WL]\)$/) has_copy_loop = 1
    if (index(u, "LOCAVAIL_FILTERMODEFLAG") > 0) has_filter_guard = 1
    if (index(u, "SCRIPT_RUNTIMEMODEDEFERREDFLAG") > 0 || index(u, "RUNTIMEMODEDEFERRED") > 0) has_deferred_flag = 1
    if (index(u, "MOVE.B #$36,ESQ_STR_6") > 0 || index(u, "ESQ_STR_6") > 0) has_speed_clamp = 1
    if (index(u, "ESQPARS_JMPTBL_DST_UPDATEBANNERQUEUE") > 0 || index(u, "UPDATEBANNERQUEUE") > 0 || index(u, "UPDATEBANNERQ") > 0) has_banner_queue = 1
    if (index(u, "ESQDISP_DRAWSTATUSBANNER") > 0 || index(u, "DRAWSTATUSBANNER") > 0) has_banner_draw = 1
    if (index(u, "ESQPARS_JMPTBL_ESQ_SEEDMINUTEEVENTTHRESHOLDS") > 0 || index(u, "SEEDMINUTEEVENTTHRESHOLDS") > 0 || index(u, "SEEDMINUTEEVE") > 0) has_seed_thresholds = 1
    if (index(u, "ED_DRAWDIAGNOSTICMODETEXT") > 0 || index(u, "DRAWDIAGNOSTICMODETEXT") > 0) has_diag_draw = 1
    if (index(u, "ED_SAVEDSCROLLSPEEDINDEX") > 0 || index(u, "SAVEDSCROLLSPEEDINDEX") > 0) has_saved_idx_gate = 1
    if (index(u, "ESQPARS2_STATEINDEX") > 0) has_state_write = 1
    if (u ~ /^BNE\.[SWB] ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN$/ || u ~ /^BRA\.[SWB] ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN$/ || u ~ /^JMP ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN$/ || u ~ /^BNE\.[SWB] ___ESQIFF2_APPLYINCOMINGSTATUSP/ || u ~ /^BEQ\.[SWB] ___ESQIFF2_APPLYINCOMINGSTATUSP/ || u == "RTS") has_return_branch = 1
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
