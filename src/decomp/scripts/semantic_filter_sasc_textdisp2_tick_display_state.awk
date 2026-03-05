BEGIN {
    has_entry = 0
    has_tick_counter = 0
    has_halfspan = 0
    has_assert_ctrl = 0
    has_update = 0
    has_reset = 0
    has_run_pending = 0
    has_return = 0
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

    if (u ~ /^TEXTDISP_TICKDISPLAYSTATE:/) has_entry = 1
    if (index(u, "ESQ_GLOBALTICKCOUNTER") > 0) has_tick_counter = 1
    if (index(u, "TEXTDISP2_JMPTBL_LOCAVAIL_GETFILTERWINDOWHALFSPAN") > 0 || index(u, "TEXTDISP2_JMPTBL_LOCAVAIL_GETFILTERWINDOW") > 0 || index(u, "TEXTDISP2_JMPTBL_LOCAVAIL_GETFIL") > 0) has_halfspan = 1
    if (index(u, "SCRIPT_ASSERTCTRLLINEIFENABLED") > 0 || index(u, "SCRIPT_ASSERTCTRLLINEIFE") > 0) has_assert_ctrl = 1
    if (index(u, "TEXTDISP_UPDATEHIGHLIGHTORPREVIEW") > 0 || index(u, "TEXTDISP_UPDATEHIGHLIGHTORPRE") > 0) has_update = 1
    if (index(u, "TEXTDISP_RESETSELECTIONANDREFRESH") > 0 || index(u, "TEXTDISP_RESETSELECTIONANDRE") > 0) has_reset = 1
    if (index(u, "TEXTDISP2_JMPTBL_ESQIFF_RUNPENDINGCOPPERANIMATIONS") > 0 || index(u, "TEXTDISP2_JMPTBL_ESQIFF_RUNPENDINGCOPPER") > 0 || index(u, "TEXTDISP2_JMPTBL_ESQIFF_RUNPENDI") > 0) has_run_pending = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TICK_COUNTER=" has_tick_counter
    print "HAS_HALFSPAN=" has_halfspan
    print "HAS_ASSERT_CTRL=" has_assert_ctrl
    print "HAS_UPDATE=" has_update
    print "HAS_RESET=" has_reset
    print "HAS_RUN_PENDING=" has_run_pending
    print "HAS_RETURN=" has_return
}
