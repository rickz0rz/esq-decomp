function norm(s, t) {
    t = toupper(s)
    sub(/;.*/, "", t)
    gsub(/^[ \t]+|[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^LOCAVAIL_UPDATEFILTERSTATEMACHINE:/ || line ~ /^LOCAVAIL_UPDATEFILTERSTATEMACHIN[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_FILTERMODEFLAG/) has_mode_flag = 1
    if (line ~ /LOCAVAIL_FILTERSTEP/) has_step_global = 1
    if (line ~ /LOCAVAIL_FILTERCLASSID/) has_class_global = 1
    if (line ~ /LOCAVAIL_FILTERPREVCLASSID/) has_prev_class = 1
    if (line ~ /NEWGRID_JMPTBL_MATH_MULU32/) has_mulu = 1
    if (line ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/ || line ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (line ~ /SCRIPT_READHANDSHAKEBIT5MASK/ || line ~ /READCIABBIT5MASK/) has_handshake = 1
    if (line ~ /ED_DIAGVINMODECHAR/) has_vin_mode = 1
    if (line ~ /ED_DIAGGRAPHMODECHAR/) has_graph_mode = 1
    if (line ~ /ESQIFF_GADSBRUSHLISTCOUNT/) has_brush_guard = 1
    if (line ~ /WDISP_HIGHLIGHTACTIVE/) has_highlight_guard = 1

    if (line ~ /MOVEQ(\.L)? #\$?1,D[01]/) saw_one_const = 1
    if (line ~ /MOVEQ(\.L)? #\$?2,D[01]/) saw_two_const = 1
    if (line ~ /MOVEQ(\.L)? #\$?FF,D[0-7]/ || line ~ /MOVEQ(\.L)? #-1,D[0-7]/) saw_neg1_const = 1

    if (line ~ /MOVE\.L .*LOCAVAIL_FILTERCLASSID/ || line ~ /MOVE\.L D5,LOCAVAIL_FILTERCLASSID/) has_stage0_class_store = 1
    if (line ~ /MOVE\.L D[01],LOCAVAIL_FILTERSTEP(\(A4\))?$/ && saw_one_const) has_stage0_step1 = 1
    if (line ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERPREVCLASSID(\(A4\))?$/ && saw_neg1_const) has_prev_class_reset = 1

    if (line ~ /MOVEQ(\.L)? #\$?A,D0/ || line ~ /MOVEQ #10,D0/) saw_ctx10_const = 1
    if (saw_ctx10_const && (line ~ /MOVE\.L D0,20\(A3\)/ || line ~ /MOVE\.L D0,\$14\(A2\)/)) has_case1_ctx10 = 1

    if ((line ~ /MOVEQ(\.L)? #\$?4E,D1/ || line ~ /MOVEQ #78,D1/) && has_graph_mode) has_case2_compare_n = 1

    if (line ~ /MOVE\.L (20\(A3\)|\$14\(A2\)),D[01]/) saw_ctx_mode_load = 1
    if (line ~ /CMPI?\.L #\$?10,D[01]/ || line ~ /MOVEQ(\.L)? #\$?10,D[01]/) saw_ctx16_const = 1
    if (saw_ctx_mode_load && saw_ctx16_const && line ~ /CMP\.L D[01],D[01]/) has_ctx_mode_limit_compare = 1
    if (line ~ /^JMP .*PC,D0\.W\)$/) has_ctx_mode_switch_window = 1

    if (line ~ /MOVE\.W D1,LOCAVAIL_FILTERCOOLDOWNTICKS/ || line ~ /MOVE\.W .*LOCAVAIL_FILTERCOOLDOWNTICKS/) has_cooldown_store = 1
    if (line ~ /MOVE\.W .*LOCAVAIL_FILTERWINDOWHALFSPAN/) has_window_store = 1
    if (line ~ /MOVE\.L D[0-7],(8\(A2\)|\$8\(A0\))$/ && saw_neg1_const) clear_sel_node = 1
    if (line ~ /MOVE\.L D[0-7],(12\(A2\)|\$C\(A0\))$/ && saw_neg1_const) clear_sel_payload = 1
    if (line ~ /MOVE\.L D[01],LOCAVAIL_FILTERSTEP(\(A4\))?$/ && saw_two_const) has_stage1_step2 = 1
    if (line ~ /MOVEQ(\.L)? #\$?4,D0/ || line ~ /MOVEQ #4,D0/) saw_ctx4_const = 1
    if (saw_ctx4_const && (line ~ /MOVE\.L D0,20\(A3\)/ || line ~ /MOVE\.L D0,\$14\(A2\)/)) has_mode4_store = 1
    if (line ~ /^CLR\.L 20\(A3\)$/ || line ~ /^CLR\.L \$14\(A2\)$/ || line ~ /^MOVE\.L D[45],\$14\(A2\)$/) has_ctx_clear = 1
    if (line ~ /^MOVE\.L D[0-7],20\(A3\)$/ ||
        line ~ /^MOVE\.L D[0-7],\$14\(A2\)$/ ||
        line ~ /^CLR\.L 20\(A3\)$/ ||
        line ~ /^CLR\.L \$14\(A2\)$/) ctx_mode_store_count++

    if (line ~ /MOVE\.L LOCAVAIL_FILTERSTEP(\(A4\))?,D[01]/ && saw_two_const) has_stage2_entry = 1
    if (line ~ /MOVE\.L LOCAVAIL_FILTERCLASSID(\(A4\))?,D[12]/ && saw_neg1_const) has_stage2_class_check = 1
    if (line ~ /CMP\.L D[12],D[34]/ && clear_sel_node) has_stage2_index_clear_check = 1

    if (line ~ /MOVEQ(\.L)? #\$?3,D1/ || line ~ /MOVEQ #3,D1/) saw_three_const = 1
    if (line ~ /SUBQ\.L #\$?4,D0/ || line ~ /SUBQ\.L #4,D0/) has_stage34_selector = 1
    if ((line ~ /MOVE\.W #\$?3,24\(A3\)/ || line ~ /MOVE\.W #\$?3,\$18\(A2\)/) && has_class_global) has_value24_store = 1
    if (line ~ /MOVE\.L D[0-7],LOCAVAIL_FILTERCLASSID(\(A4\))?$/ && saw_neg1_const) has_final_class_reset = 1
    if (line ~ /^CLR\.L LOCAVAIL_FILTERSTEP(\(A4\))?$/) has_final_step_clear = 1
    if (line ~ /MOVE\.W #\$?FFFFFFFF,LOCAVAIL_FILTERWINDOWHALFSPAN(\(A4\))?/ || line ~ /MOVE\.W #\(-1\),LOCAVAIL_FILTERWINDOWHALFSPAN(\(A4\))?/) has_final_window_reset = 1

    if (line ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) reset_call_count++
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_FLAG=" has_mode_flag
    print "HAS_STEP_GLOBAL=" has_step_global
    print "HAS_CLASS_GLOBAL=" has_class_global
    print "HAS_PREV_CLASS=" has_prev_class
    print "HAS_MULU=" has_mulu
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_HANDSHAKE=" has_handshake
    print "HAS_VIN_MODE=" has_vin_mode
    print "HAS_GRAPH_MODE=" has_graph_mode
    print "HAS_BRUSH_GUARD=" has_brush_guard
    print "HAS_HIGHLIGHT_GUARD=" has_highlight_guard
    print "HAS_STAGE0_CLASS_STORE=" has_stage0_class_store
    print "HAS_STAGE0_STEP1=" has_stage0_step1
    print "HAS_PREV_CLASS_RESET=" has_prev_class_reset
    print "HAS_CASE1_CTX10=" has_case1_ctx10
    print "HAS_CASE2_COMPARE_N=" has_case2_compare_n
    print "HAS_CTX_MODE_LIMIT_COMPARE=" has_ctx_mode_limit_compare
    print "HAS_CTX_MODE_SWITCH_WINDOW=" has_ctx_mode_switch_window
    print "HAS_COOLDOWN_STORE=" has_cooldown_store
    print "HAS_WINDOW_STORE=" has_window_store
    print "HAS_CLEAR_SEL_NODE=" clear_sel_node
    print "HAS_CLEAR_SEL_PAYLOAD=" clear_sel_payload
    print "HAS_STAGE1_STEP2=" has_stage1_step2
    print "HAS_MODE4_STORE=" has_mode4_store
    print "HAS_CTX_CLEAR=" has_ctx_clear
    print "CTX_MODE_STORE_COUNT=" ctx_mode_store_count
    print "HAS_STAGE2_ENTRY=" has_stage2_entry
    print "HAS_STAGE2_CLASS_CHECK=" has_stage2_class_check
    print "HAS_STAGE2_INDEX_CLEAR_CHECK=" has_stage2_index_clear_check
    print "HAS_STAGE34_SELECTOR=" has_stage34_selector
    print "HAS_VALUE24_STORE=" has_value24_store
    print "HAS_FINAL_CLASS_RESET=" has_final_class_reset
    print "HAS_FINAL_STEP_CLEAR=" has_final_step_clear
    print "HAS_FINAL_WINDOW_RESET=" has_final_window_reset
    print "RESET_CALL_COUNT=" reset_call_count
    print "HAS_RETURN=" has_return
}
