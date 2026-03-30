BEGIN {
    has_entry = 0
    has_filter_mode_guard = 0
    has_stage0_gate = 0
    has_stage0_node_lookup = 0
    has_stage0_class_store = 0
    has_stage0_step1_store = 0
    has_stage0_prev_reset = 0

    has_case1_find_char = 0
    has_case1_handshake = 0
    has_case1_ctx10 = 0
    has_case1_reset = 0

    has_case2_graph_guard = 0
    has_case2_brush_guard = 0
    has_case2_reset = 0

    has_case3_highlight_guard = 0
    has_case3_reset = 0
    has_default_reset = 0

    has_stage1_gate = 0
    has_stage1_mode_limit = 0
    has_stage1_dispatch = 0
    has_stage1_duration_load = 0
    has_stage1_window_store = 0
    has_stage1_cooldown_store = 0
    has_stage1_clear_sel_node = 0
    has_stage1_clear_sel_payload = 0
    has_stage1_step2_store = 0
    has_stage1_class23_mode4 = 0
    has_stage1_case4_clear = 0

    has_stage2_clear_ctx = 0

    has_stage34_gate = 0
    has_stage34_mode_limit = 0
    has_stage34_dispatch = 0
    has_stage34_class1_value24 = 0
    has_stage34_class_reset = 0
    has_stage34_step_reset = 0
    has_stage34_window_reset = 0
    has_stage34_case4_clear = 0

    reset_call_count = 0
    has_return = 0

    saw_step0 = 0
    saw_step1 = 0
    saw_step2 = 0
    saw_step3 = 0
    saw_step4 = 0
    saw_neg1 = 0
    saw_mode10 = 0
    saw_mode4 = 0
    saw_duration = 0
    saw_class_cmp_2 = 0
    saw_class_cmp_3 = 0
    prev1 = ""
    prev2 = ""
    prev3 = ""
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^LOCAVAIL_UPDATEFILTERSTATEMACHINE:/ || u ~ /^LOCAVAIL_UPDATEFILTERSTATEMACHIN[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (u ~ /LOCAVAIL_FILTERMODEFLAG/) {
        has_filter_mode_guard = 1
    }

    if (u ~ /MOVEQ(\.L)? #\$?FF,D[0-7]/ || u ~ /MOVEQ(\.L)? #-1,D[0-7]/) {
        saw_neg1 = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$?A,D[0-7]/ || u ~ /MOVEQ(\.L)? #10,D[0-7]/) {
        saw_mode10 = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$?4,D[0-7]/ || u ~ /MOVEQ(\.L)? #4,D[0-7]/) {
        saw_mode4 = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$?2,D[0-7]/ || u ~ /MOVEQ(\.L)? #2,D[0-7]/) {
        saw_class_cmp_2 = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$?3,D[0-7]/ || u ~ /MOVEQ(\.L)? #3,D[0-7]/) {
        saw_class_cmp_3 = 1
    }

    if (u ~ /TST\.L LOCAVAIL_FILTERSTEP/ || u ~ /MOVE\.L LOCAVAIL_FILTERSTEP\(A4\),D0/) {
        saw_step0 = 1
        has_stage0_gate = 1
    }
    if ((u ~ /CMP\.L LOCAVAIL_FILTERSTEP,D[0-7]/ || u ~ /CMP\.L LOCAVAIL_FILTERSTEP\(A4\),D[0-7]/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$?1,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #1,D[0-7]/)) {
        saw_step1 = 1
        has_stage1_gate = 1
    }
    if ((u ~ /CMP\.L D[0-7],D[0-7]/ || u ~ /CMP\.L LOCAVAIL_FILTERSTEP,D[0-7]/ || u ~ /CMP\.L LOCAVAIL_FILTERSTEP\(A4\),D[0-7]/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$?2,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #2,D[0-7]/)) {
        saw_step2 = 1
    }
    if ((u ~ /CMP\.L D[0-7],D[0-7]/ || u ~ /CMP\.L LOCAVAIL_FILTERSTEP,D[0-7]/ || u ~ /CMP\.L LOCAVAIL_FILTERSTEP\(A4\),D[0-7]/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$?3,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #3,D[0-7]/)) {
        saw_step3 = 1
        has_stage34_gate = 1
    }
    if ((u ~ /SUBQ\.L #\$?4,D0/ || u ~ /SUBQ\.L #4,D0/) &&
        (saw_step3 || prev1 ~ /CMP\.L LOCAVAIL_FILTERSTEP/ || prev2 ~ /CMP\.L LOCAVAIL_FILTERSTEP/)) {
        saw_step4 = 1
        has_stage34_gate = 1
    }

    if ((u ~ /NEWGRID_JMPTBL_MATH_MULU32/ || u ~ /MATH_MULU32/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$?A,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #10,D[0-7]/ ||
         prev2 ~ /PEA \(\$A\)\.W/ || prev2 ~ /PEA 10\.W/ || prev1 ~ /PEA \(\$A\)\.W/ || prev1 ~ /PEA 10\.W/)) {
        has_stage0_node_lookup = 1
    }
    if (u ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERCLASSID(\(A4\))?$/) {
        has_stage0_class_store = 1
    }
    if (u ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERSTEP(\(A4\))?$/ &&
        (prev1 ~ /MOVEQ(\.L)? #\$?1,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #1,D[0-7]/)) {
        has_stage0_step1_store = 1
    }
    if (u ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERPREVCLASSID(\(A4\))?$/ && saw_neg1) {
        has_stage0_prev_reset = 1
    }

    if (u ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/ || u ~ /STR_FINDCHARPTR/) {
        has_case1_find_char = 1
    }
    if (u ~ /SCRIPT_READHANDSHAKEBIT5MASK/ || u ~ /READCIABBIT5MASK/) {
        has_case1_handshake = 1
    }
    if ((u ~ /MOVE\.L D[0-7],20\(A[23]\)/ || u ~ /MOVE\.L D[0-7],\$14\(A[23]\)/) && saw_mode10) {
        has_case1_ctx10 = 1
    }
    if ((u ~ /LOCAVAIL_RESETFILTERCURSORSTATE/ || prev1 ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) &&
        (has_case1_find_char || has_case1_handshake || has_case1_ctx10)) {
        has_case1_reset = 1
    }

    if (u ~ /ED_DIAGGRAPHMODECHAR/) {
        has_case2_graph_guard = 1
    }
    if (u ~ /ESQIFF_GADSBRUSHLISTCOUNT/) {
        has_case2_brush_guard = 1
    }
    if ((u ~ /LOCAVAIL_RESETFILTERCURSORSTATE/ || prev1 ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) &&
        (has_case2_graph_guard || has_case2_brush_guard)) {
        has_case2_reset = 1
    }

    if (u ~ /WDISP_HIGHLIGHTACTIVE/) {
        has_case3_highlight_guard = 1
    }
    if ((u ~ /LOCAVAIL_RESETFILTERCURSORSTATE/ || prev1 ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) &&
        has_case3_highlight_guard) {
        has_case3_reset = 1
    }

    if (u ~ /CMPI?\.L #\$?10,D[0-7]/ || u ~ /CMPI?\.L #16,D[0-7]/ ||
        ((u ~ /CMP\.L D[0-7],D[0-7]/) &&
         (prev1 ~ /MOVEQ(\.L)? #\$?10,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #16,D[0-7]/ ||
          prev2 ~ /MOVEQ(\.L)? #\$?10,D[0-7]/ || prev2 ~ /MOVEQ(\.L)? #16,D[0-7]/))) {
        has_stage1_mode_limit = 1
        has_stage34_mode_limit = 1
    }
    if ((u ~ /JMP .*PC,D0\.W/ || u ~ /JMP \$4\(PC,D0\.W\)/) &&
        (prev1 ~ /MOVE\.W .*PC,D0\.W\),D0/ || prev1 ~ /MOVE\.W \$6\(PC,D0\.W\),D0/ ||
         prev2 ~ /MOVE\.W .*PC,D0\.W\),D0/ || prev2 ~ /MOVE\.W \$6\(PC,D0\.W\),D0/)) {
        if (saw_step1) {
            has_stage1_dispatch = 1
        }
        if (saw_step3 || saw_step4) {
            has_stage34_dispatch = 1
        }
    }

    if (u ~ /MOVE\.W [^,]*\$2\(A0\),D0/ || u ~ /MOVE\.W 2\(A0\),D0/) {
        saw_duration = 1
        has_stage1_duration_load = 1
    }
    if (u ~ /MOVE\.W .*LOCAVAIL_FILTERCOOLDOWNTICKS/) {
        has_stage1_cooldown_store = 1
    }
    if (u ~ /MOVE\.W .*LOCAVAIL_FILTERWINDOWHALFSPAN/) {
        has_stage1_window_store = 1
    }
    if (u ~ /MOVE\.L D[0-7],(8\(A[023]\)|\$8\(A[023]\))$/ && saw_neg1) {
        has_stage1_clear_sel_node = 1
    }
    if (u ~ /MOVE\.L D[0-7],(12\(A[023]\)|\$C\(A[023]\))$/ && saw_neg1) {
        has_stage1_clear_sel_payload = 1
    }
    if (u ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERSTEP(\(A4\))?$/ &&
        (prev1 ~ /MOVEQ(\.L)? #\$?2,D[0-7]/ || prev1 ~ /MOVEQ(\.L)? #2,D[0-7]/)) {
        has_stage1_step2_store = 1
    }
    if ((u ~ /CMP\.L D[0-7],D[0-7]/ || u ~ /SUBQ\.L #\$?3,D0/ || u ~ /SUBQ\.L #3,D0/) &&
        (saw_class_cmp_2 || saw_class_cmp_3 || prev1 ~ /LOCAVAIL_FILTERCLASSID/ || prev2 ~ /LOCAVAIL_FILTERCLASSID/)) {
        has_stage1_class23_mode4 = 1
    }
    if ((u ~ /^CLR\.L 20\(A[23]\)$/ || u ~ /^CLR\.L \$14\(A[23]\)$/) && saw_step1) {
        has_stage1_case4_clear = 1
    }

    if ((u ~ /^CLR\.L 20\(A[23]\)$/ || u ~ /^CLR\.L \$14\(A[23]\)$/) && saw_step2) {
        has_stage2_clear_ctx = 1
    }

    if ((u ~ /MOVE\.W #\$?3,24\(A[23]\)/ || u ~ /MOVE\.W #3,24\(A[23]\)/ ||
         u ~ /MOVE\.W #\$?3,\$18\(A[23]\)/ || u ~ /MOVE\.W #3,\$18\(A[23]\)/) &&
        (prev1 ~ /CMP\.L LOCAVAIL_FILTERCLASSID/ || prev1 ~ /MOVEQ(\.L)? #\$?1,D[0-7]/ ||
         prev2 ~ /CMP\.L LOCAVAIL_FILTERCLASSID/ || prev2 ~ /MOVEQ(\.L)? #\$?1,D[0-7]/)) {
        has_stage34_class1_value24 = 1
    }
    if (u ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERCLASSID(\(A4\))?$/ && saw_neg1) {
        has_stage34_class_reset = 1
    }
    if (u ~ /^CLR\.L LOCAVAIL_FILTERSTEP(\(A4\))?$/) {
        has_stage34_step_reset = 1
    }
    if (u ~ /MOVE\.W #\(-1\),LOCAVAIL_FILTERWINDOWHALFSPAN(\(A4\))?/ ||
        u ~ /MOVE\.W #\$?FFFFFFFF,LOCAVAIL_FILTERWINDOWHALFSPAN(\(A4\))?/) {
        has_stage34_window_reset = 1
    }
    if ((u ~ /^CLR\.L 20\(A[23]\)$/ || u ~ /^CLR\.L \$14\(A[23]\)$/) && (saw_step3 || saw_step4)) {
        has_stage34_case4_clear = 1
    }

    if (u ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) {
        reset_call_count++
    }
    if ((u ~ /LOCAVAIL_RESETFILTERCURSORSTATE/ || prev1 ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) &&
        !(has_case1_find_char || has_case2_graph_guard || has_case3_highlight_guard)) {
        has_default_reset = 1
    }

    if (u == "RTS") {
        has_return = 1
    }

    prev3 = prev2
    prev2 = prev1
    prev1 = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FILTER_MODE_GUARD=" has_filter_mode_guard
    print "HAS_STAGE0_GATE=" has_stage0_gate
    print "HAS_STAGE0_NODE_LOOKUP=" has_stage0_node_lookup
    print "HAS_STAGE0_CLASS_STORE=" has_stage0_class_store
    print "HAS_STAGE0_STEP1_STORE=" has_stage0_step1_store
    print "HAS_STAGE0_PREV_RESET=" has_stage0_prev_reset
    print "HAS_CASE1_FIND_CHAR=" has_case1_find_char
    print "HAS_CASE1_HANDSHAKE=" has_case1_handshake
    print "HAS_CASE1_CTX10=" has_case1_ctx10
    print "HAS_CASE1_RESET=" has_case1_reset
    print "HAS_CASE2_GRAPH_GUARD=" has_case2_graph_guard
    print "HAS_CASE2_BRUSH_GUARD=" has_case2_brush_guard
    print "HAS_CASE2_RESET=" has_case2_reset
    print "HAS_CASE3_HIGHLIGHT_GUARD=" has_case3_highlight_guard
    print "HAS_CASE3_RESET=" has_case3_reset
    print "HAS_DEFAULT_RESET=" has_default_reset
    print "HAS_STAGE1_GATE=" has_stage1_gate
    print "HAS_STAGE1_MODE_LIMIT=" has_stage1_mode_limit
    print "HAS_STAGE1_DISPATCH=" has_stage1_dispatch
    print "HAS_STAGE1_DURATION_LOAD=" has_stage1_duration_load
    print "HAS_STAGE1_WINDOW_STORE=" has_stage1_window_store
    print "HAS_STAGE1_COOLDOWN_STORE=" has_stage1_cooldown_store
    print "HAS_STAGE1_CLEAR_SEL_NODE=" has_stage1_clear_sel_node
    print "HAS_STAGE1_CLEAR_SEL_PAYLOAD=" has_stage1_clear_sel_payload
    print "HAS_STAGE1_STEP2_STORE=" has_stage1_step2_store
    print "HAS_STAGE1_CLASS23_MODE4=" has_stage1_class23_mode4
    print "HAS_STAGE1_CASE4_CLEAR=" has_stage1_case4_clear
    print "HAS_STAGE2_CLEAR_CTX=" has_stage2_clear_ctx
    print "HAS_STAGE34_GATE=" has_stage34_gate
    print "HAS_STAGE34_MODE_LIMIT=" has_stage34_mode_limit
    print "HAS_STAGE34_DISPATCH=" has_stage34_dispatch
    print "HAS_STAGE34_CLASS1_VALUE24=" has_stage34_class1_value24
    print "HAS_STAGE34_CLASS_RESET=" has_stage34_class_reset
    print "HAS_STAGE34_STEP_RESET=" has_stage34_step_reset
    print "HAS_STAGE34_WINDOW_RESET=" has_stage34_window_reset
    print "HAS_STAGE34_CASE4_CLEAR=" has_stage34_case4_clear
    print "RESET_CALL_COUNT=" reset_call_count
    print "HAS_RETURN=" has_return
}
