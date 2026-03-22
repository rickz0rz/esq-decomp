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

    if (line ~ /MOVE\.L .*LOCAVAIL_FILTERCLASSID/ || line ~ /MOVE\.L D5,LOCAVAIL_FILTERCLASSID/) has_stage0_class_store = 1
    if (line ~ /MOVE\.L .*LOCAVAIL_FILTERSTEP/ && line ~ /#\$?1|#1/) has_stage0_step1 = 1
    if (line ~ /MOVE\.L .*LOCAVAIL_FILTERPREVCLASSID/ && line ~ /#\$?FF|#-1/) has_prev_class_reset = 1

    if (line ~ /MOVEQ(\.L)? #\$?A,D0/ || line ~ /MOVEQ #10,D0/) saw_ctx10_const = 1
    if (saw_ctx10_const && (line ~ /MOVE\.L D0,20\(A3\)/ || line ~ /MOVE\.L D0,\$14\(A2\)/)) has_case1_ctx10 = 1

    if ((line ~ /MOVEQ(\.L)? #\$?4E,D1/ || line ~ /MOVEQ #78,D1/) && has_graph_mode) has_case2_compare_n = 1

    if (line ~ /MOVE\.W D1,LOCAVAIL_FILTERCOOLDOWNTICKS/ || line ~ /MOVE\.W .*LOCAVAIL_FILTERCOOLDOWNTICKS/) has_cooldown_store = 1
    if (line ~ /MOVE\.W .*LOCAVAIL_FILTERWINDOWHALFSPAN/) has_window_store = 1
    if (line ~ /MOVE\.L .*8\(A[02]\)/ && line ~ /#\$?FF|#-1/) clear_sel_node = 1
    if (line ~ /MOVE\.L .*12\(A2\)/ && line ~ /#\$?FF|#-1/) clear_sel_payload = 1
    if (line ~ /MOVE\.L .*\\$C\(A0\)/ && line ~ /#\$?FF|#-1/) clear_sel_payload = 1
    if ((line ~ /MOVE\.L .*LOCAVAIL_FILTERSTEP/ && line ~ /#\$?2|#2/)) has_stage1_step2 = 1
    if (line ~ /MOVEQ(\.L)? #\$?4,D0/ || line ~ /MOVEQ #4,D0/) saw_ctx4_const = 1
    if (saw_ctx4_const && (line ~ /MOVE\.L D0,20\(A3\)/ || line ~ /MOVE\.L D0,\$14\(A2\)/)) has_mode4_store = 1
    if (line ~ /^CLR\.L 20\(A3\)$/ || line ~ /^CLR\.L \$14\(A2\)$/ || line ~ /^MOVEQ(\.L)? #\$?0,D[045]$/) has_ctx_clear = 1

    if ((line ~ /MOVE\.W #\$?3,24\(A3\)/ || line ~ /MOVE\.W #\$?3,\$18\(A2\)/) && has_class_global) has_value24_store = 1
    if ((line ~ /MOVE\.L .*LOCAVAIL_FILTERCLASSID/ && line ~ /#\$?FF|#-1/)) has_final_class_reset = 1
    if (line ~ /^CLR\.L LOCAVAIL_FILTERSTEP/) has_final_step_clear = 1
    if (line ~ /MOVE\.W #\$?FFFFFFFF,LOCAVAIL_FILTERWINDOWHALFSPAN/ || line ~ /MOVE\.W #\(-1\),LOCAVAIL_FILTERWINDOWHALFSPAN/) has_final_window_reset = 1

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
    print "HAS_COOLDOWN_STORE=" has_cooldown_store
    print "HAS_WINDOW_STORE=" has_window_store
    print "HAS_CLEAR_SEL_NODE=" clear_sel_node
    print "HAS_CLEAR_SEL_PAYLOAD=" clear_sel_payload
    print "HAS_STAGE1_STEP2=" has_stage1_step2
    print "HAS_MODE4_STORE=" has_mode4_store
    print "HAS_CTX_CLEAR=" has_ctx_clear
    print "HAS_VALUE24_STORE=" has_value24_store
    print "HAS_FINAL_CLASS_RESET=" has_final_class_reset
    print "HAS_FINAL_STEP_CLEAR=" has_final_step_clear
    print "HAS_FINAL_WINDOW_RESET=" has_final_window_reset
    print "RESET_CALL_COUNT=" reset_call_count
    print "HAS_RETURN=" has_return
}
