BEGIN {
    has_entry = 0
    has_return_entry = 0
    has_halfhour_call = 0
    saw_clamp_flag = 0
    saw_clamp_beq = 0
    has_highlight_update_call = 0
    saw_window_cmp_low = 0
    saw_window_cmp_high = 0
    saw_window_branch = 0
    has_countdown_gate = 0
    has_status_day_loop = 0
    has_status_day_rotate = 0
    saw_persist_arm_flag = 0
    saw_persist_request_flag = 0
    saw_propagate_done_flag = 0
    saw_propagate_guard_cmp = 0
    has_secondary_propagate_calls = 0
    has_secondary_done_set = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_DRAWSTATUSBANNER_IMPL:/) has_entry = 1
    if (uline ~ /^ESQDISP_DRAWSTATUSBANNER_IMPL_RETURN:/) has_return_entry = 1
    if (uline ~ /ESQFUNC_JMPTBL_ESQ_GETHALFHOURSLOTINDEX/) has_halfhour_call = 1
    if (uline ~ /ESQDISP_STATUSBANNERCLAMPGATEFLAG/) saw_clamp_flag = 1
    if (uline ~ /BEQ\.S \.LAB_0934/) saw_clamp_beq = 1
    if (uline ~ /ESQFUNC_JMPTBL_LADFUNC_UPDATEHIGHLIGHTSTATE/) has_highlight_update_call = 1
    if (uline ~ /MOVEQ #2,D1/) saw_window_cmp_low = 1
    if (uline ~ /MOVEQ #39,D1/) saw_window_cmp_high = 1
    if (uline ~ /BCS\.S \.LAB_0937/ || uline ~ /BCC\.S \.LAB_0937/) saw_window_branch = 1
    if (uline ~ /ESQDISP_LASTPRIMARYCOUNTDOWNVALUE/) has_countdown_gate = 1
    if (uline ~ /^\.LAB_093D:/ || uline ~ /ESQIFF_JMPTBL_MATH_MULU32/) has_status_day_loop = 1
    if (uline ~ /^\.LAB_0942:/ || uline ~ /^\.LAB_0943:/ || uline ~ /^\.LAB_0944:/) has_status_day_rotate = 1
    if (uline ~ /ESQDISP_SECONDARYPERSISTARMGATEFLAG/) saw_persist_arm_flag = 1
    if (uline ~ /ESQDISP_SECONDARYPERSISTREQUESTFLAG/) saw_persist_request_flag = 1
    if (uline ~ /ESQDISP_SECONDARYPROPAGATIONDONEFLAG/) saw_propagate_done_flag = 1
    if (uline ~ /MOVEQ #45,D1/ || uline ~ /BCS\.S ESQDISP_DRAWSTATUSBANNER_IMPL_RETURN/) saw_propagate_guard_cmp = 1
    if (uline ~ /ESQDISP_PROPAGATEPRIMARYTITLEMETADATATOSECONDARY/ || uline ~ /ESQFUNC_JMPTBL_LOCAVAIL_SYNCSECONDARYFILTERFORCURRENTGROUP/ || uline ~ /ESQFUNC_JMPTBL_P_TYPE_ENSURESECONDARYLIST/) has_secondary_propagate_calls = 1
    if (uline ~ /MOVE\.W #1,ESQDISP_SECONDARYPROPAGATIONDONEFLAG/) has_secondary_done_set = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_clamp_gate = (saw_clamp_flag && saw_clamp_beq) ? 1 : 0
    has_group_code_window_branch = (saw_window_cmp_low && saw_window_cmp_high && saw_window_branch) ? 1 : 0
    has_secondary_persist_arm = (saw_persist_arm_flag && saw_persist_request_flag) ? 1 : 0
    has_secondary_propagate_gate = (saw_propagate_done_flag && saw_propagate_guard_cmp) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN_ENTRY=" has_return_entry
    print "HAS_HALFHOUR_CALL=" has_halfhour_call
    print "HAS_CLAMP_GATE=" has_clamp_gate
    print "HAS_HIGHLIGHT_UPDATE_CALL=" has_highlight_update_call
    print "HAS_GROUP_CODE_WINDOW_BRANCH=" has_group_code_window_branch
    print "HAS_COUNTDOWN_GATE=" has_countdown_gate
    print "HAS_STATUS_DAY_LOOP=" has_status_day_loop
    print "HAS_STATUS_DAY_ROTATE=" has_status_day_rotate
    print "HAS_SECONDARY_PERSIST_ARM=" has_secondary_persist_arm
    print "HAS_SECONDARY_PROPAGATE_GATE=" has_secondary_propagate_gate
    print "HAS_SECONDARY_PROPAGATE_CALLS=" has_secondary_propagate_calls
    print "HAS_SECONDARY_DONE_SET=" has_secondary_done_set
    print "HAS_RETURN=" has_return
}
