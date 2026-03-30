BEGIN {
    has_label = 0

    saw_ppv_window = 0
    saw_full_day_window = 0
    saw_window_call = 0
    saw_early_return = 0

    ppv_parts_stage = 0
    has_ppv_parts_flow = 0

    saw_mode3_fetch = 0
    saw_mode4_fetch = 0
    saw_mode2_fetch = 0
    has_normal_parts_flow = 0

    saw_flag_test = 0

    wrap_stage = 0
    has_wrap_flow = 0
    saw_wrap_clear = 0

    loop_stage = 0
    has_append_loop = 0
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

    if (u ~ /^COI_FORMATENTRYDISPLAYTEXT[A-Z0-9_]*:/) has_label = 1

    if (u ~ /GCOMMAND_PPVSELECTIONWINDOWMINUT/) saw_ppv_window = 1
    if (u ~ /MOVE\.L #1440,D1/ || u ~ /MOVEQ\.L #\$5A,D5/ || u ~ /LSL\.L #\$4,D5/) saw_full_day_window = 1
    if (u ~ /COI_TESTENTRYWITHINTIMEWINDOW/) saw_window_call = 1
    if (u ~ /BEQ\.[BWLS] COI_FORMATENTRYDISPLAYTEXT_RETURN/ || u ~ /BEQ\.[BWLS] ___COI_FORMATENTRYDISPLAYTEXT__19/) saw_early_return = 1

    if (u ~ /CLR\.L \$44\(A7\)|MOVE\.L A0,-16\(A5\)/) ppv_parts_stage = 1
    if (ppv_parts_stage >= 1 &&
        (u ~ /CLR\.L \$48\(A7\)|MOVE\.L A0,-12\(A5\)/)) ppv_parts_stage = 2
    if (ppv_parts_stage >= 2 &&
        (u ~ /CLR\.L \$4C\(A7\)|MOVE\.L A0,-8\(A5\)/)) ppv_parts_stage = 3
    if (ppv_parts_stage >= 3 &&
        (u ~ /MOVEQ\.L #\$3,D6|MOVEQ #3,D6/)) has_ppv_parts_flow = 1

    if (u ~ /PEA \(\$3\)\.W/ || u ~ /PEA 3\.W/) saw_mode3_fetch = 1
    if (u ~ /PEA \(\$4\)\.W/ || u ~ /PEA 4\.W/) saw_mode4_fetch = 1
    if (u ~ /PEA \(\$2\)\.W/ || u ~ /PEA 2\.W/) saw_mode2_fetch = 1
    if (saw_mode3_fetch && saw_mode4_fetch && saw_mode2_fetch) has_normal_parts_flow = 1

    if (u ~ /CLEANUP_TESTENTRYFLAGYANDBIT1/) saw_flag_test = 1

    if (u ~ /PEA \(\$6\)\.W/ || u ~ /PEA 6\.W/) wrap_stage = 1
    if (wrap_stage >= 1 && u ~ /COI_GETANIMFIELDPOINTERBYMODE/) wrap_stage = 2
    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF|GROUP_AE_JMPTBL_WDISP_SPRIN/) wrap_stage = 3
    if (u ~ /CLEANUP_UPDATEENTRYFLAGBYTES/ && wrap_stage >= 2) has_wrap_flow = 1
    if (u ~ /CLR\.L \$1C\(A7\)|CLR\.L -4\(A5\)/) saw_wrap_clear = 1

    if (u ~ /MOVEQ\.L #\$5,D1|MOVEQ #5,D0/) loop_stage = 1
    if (loop_stage >= 1 &&
        (u ~ /GROUP_AI_JMPTBL_STRING_APPENDATN|GROUP_AI_JMPTBL_STRING_APPENDATNULL/ ||
         u ~ /GROUP_AI_JMPTBL_STRING_APPENDAT/)) loop_stage = 2
    if (loop_stage >= 2 &&
        (u ~ /ADDQ\.L #\$1,\$34\(A7\)|ADDQ\.L #1,D5/)) has_append_loop = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_PPV_WINDOW=" saw_ppv_window
    print "HAS_FULL_DAY_WINDOW=" saw_full_day_window
    print "HAS_WINDOW_CALL=" saw_window_call
    print "HAS_EARLY_RETURN=" saw_early_return
    print "HAS_PPV_PARTS_FLOW=" has_ppv_parts_flow
    print "HAS_NORMAL_PARTS_FLOW=" has_normal_parts_flow
    print "HAS_FLAG_TEST=" saw_flag_test
    print "HAS_WRAP_FLOW=" has_wrap_flow
    print "HAS_WRAP_CLEAR=" saw_wrap_clear
    print "HAS_APPEND_LOOP=" has_append_loop
}
