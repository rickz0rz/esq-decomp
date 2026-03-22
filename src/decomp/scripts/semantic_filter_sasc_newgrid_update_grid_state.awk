BEGIN {
    has_entry = 0
    has_latch_global = 0
    has_update_preset = 0
    has_testbit = 0
    has_find_prev = 0
    has_select_pen = 0
    has_selected_ptr_write = 0
    has_badge_flag_check = 0
    has_override_pen = 0
    has_title_table = 0
    has_draw_badge = 0
    has_visible_count = 0
    has_selected_state_neg1 = 0
    has_selected_state_visible = 0
    has_draw_frame = 0
    has_draw_result_test = 0
    has_const4 = 0
    has_const5 = 0
    has_const_minus1 = 0
    latch_store_count = 0
    has_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark_once(flag_name, value) {
    if (!(flag_name in seen_flag)) {
        seen_flag[flag_name] = value
        print flag_name "=" value
    }
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_UPDATEGRIDSTATE:/ || u ~ /^NEWGRID_UPDATEGRIDSTAT[A-Z0-9_]*:/) {
        has_entry = 1
        mark_once("STEP_ENTRY", 1)
    }
    if (n ~ /NEWGRIDGRIDSTATEFRAMELATCH/) {
        has_latch_global = 1
    }
    if (n ~ /NEWGRIDUPDATEPRESETENTRY/) {
        has_update_preset = 1
        mark_once("STEP_UPDATE_PRESET", 1)
    }
    if (n ~ /NEWGRID2JMPTBLESQTESTBIT1BASED/ || n ~ /NEWGRID2JMPTBLESQTESTBIT1BASE/ ||
        n ~ /ESQTESTBIT1BASED/ || n ~ /ESQTESTBIT1BASE/) {
        has_testbit = 1
        mark_once("STEP_TESTBIT", 1)
    }
    if (n ~ /NEWGRID2JMPTBLDISPLIBFINDPREVIOUSVALIDENTRYINDEX/ || n ~ /NEWGRID2JMPTBLDISPLIBFINDPREVIOUSVALID/ || n ~ /NEWGRID2JMPTBLDISPLIBFINDPREV/ ||
        n ~ /DISPLIBFINDPREVIOUSVALIDENTRYINDEX/ || n ~ /DISPLIBFINDPREVIOUSVALID/ || n ~ /DISPLIBFINDPREV/) {
        has_find_prev = 1
        mark_once("STEP_FIND_PREV", 1)
    }
    if (n ~ /NEWGRIDSELECTENTRYPEN/) {
        has_select_pen = 1
        mark_once("STEP_SELECT_PEN", 1)
    }
    if (n ~ /NEWGRIDSELECTEDGRIDENTRYPTR/ && (n ~ /^MOVEL/ || n ~ /^MOVEQ/ || n ~ /^MOVE/)) {
        has_selected_ptr_write = 1
        mark_once("STEP_WRITE_SELECTED_PTR", 1)
    }
    if (u ~ /BTST #2,7\(A1\)/ || u ~ /MOVE\.B \$7\(A0,D6\.W\),D1/ || u ~ /AND\.B \$23\(A7\),D1/) {
        has_badge_flag_check = 1
        mark_once("STEP_CHECK_BADGE_FLAG", 1)
    }
    if (n ~ /NEWGRIDOVERRIDEPENINDEX/ && n ~ /A7/) {
        has_override_pen = 1
        mark_once("STEP_PUSH_OVERRIDE_PEN", 1)
    }
    if (u ~ /MOVE\.L 56\(A0\),-\(A7\)/ || u ~ /MOVE\.L \$38\(A0,D1\.L\),-\(A7\)/) {
        has_title_table = 1
        mark_once("STEP_PUSH_TITLE_PTR", 1)
    }
    if (n ~ /NEWGRIDDRAWENTRYFLAGBADGE/) {
        has_draw_badge = 1
        mark_once("STEP_DRAW_BADGE", 1)
    }
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLE/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/ ||
        n ~ /DISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /DISPTEXTCOMPUTEVISIBLE/) {
        has_visible_count = 1
        mark_once("STEP_VISIBLE_COUNT", 1)
    }
    if ((u ~ /MOVE\.L D1,32\(A3\)/ || u ~ /MOVE\.L D2,\$20\(A3\)/) &&
        (u ~ /32\(A3\)/ || u ~ /\$20\(A3\)/)) {
        has_selected_state_neg1 = 1
        mark_once("STEP_STORE_SELECTED_STATE_NEG1", 1)
    }
    if ((u ~ /MOVE\.L D0,32\(A3\)/ || u ~ /MOVE\.L D0,\$20\(A3\)/) &&
        (u ~ /32\(A3\)/ || u ~ /\$20\(A3\)/)) {
        has_selected_state_visible = 1
        mark_once("STEP_STORE_SELECTED_STATE_VISIBLE", 1)
    }
    if (n ~ /NEWGRIDDRAWGRIDFRAMEANDROWS/) {
        has_draw_frame = 1
        mark_once("STEP_DRAW_FRAME", 1)
    }
    if (u == "TST.L D0") {
        has_draw_result_test = 1
    }
    if (n ~ /NEWGRIDGRIDSTATEFRAMELATCH/ && n ~ /^MOVEL/) {
        latch_store_count++
    }
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4 = 1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5 = 1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) has_const_minus1 = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LATCH_GLOBAL=" has_latch_global
    print "HAS_UPDATE_PRESET_CALL=" has_update_preset
    print "HAS_TESTBIT_CALL=" has_testbit
    print "HAS_FIND_PREV_CALL=" has_find_prev
    print "HAS_SELECT_PEN_CALL=" has_select_pen
    print "HAS_SELECTED_PTR_WRITE=" has_selected_ptr_write
    print "HAS_BADGE_FLAG_CHECK=" has_badge_flag_check
    print "HAS_OVERRIDE_PEN_PUSH=" has_override_pen
    print "HAS_TITLE_TABLE_PUSH=" has_title_table
    print "HAS_DRAW_BADGE_CALL=" has_draw_badge
    print "HAS_VISIBLE_COUNT_CALL=" has_visible_count
    print "HAS_SELECTED_STATE_NEG1_STORE=" has_selected_state_neg1
    print "HAS_SELECTED_STATE_VISIBLE_STORE=" has_selected_state_visible
    print "HAS_DRAW_FRAME_CALL=" has_draw_frame
    print "HAS_DRAW_RESULT_TEST=" has_draw_result_test
    print "HAS_LATCH_STORE_BURST=" (latch_store_count >= 4)
    print "HAS_CONST_4=" has_const4
    print "HAS_CONST_5=" has_const5
    print "HAS_CONST_MINUS1=" has_const_minus1
    print "HAS_RTS=" has_rts
}
