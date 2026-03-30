BEGIN {
    has_entry = 0
    has_return = 0

    saw_topaz_font = 0
    saw_prevuec_font = 0
    saw_bit5 = 0
    saw_ctrl_line = 0
    saw_bit3 = 0
    saw_mode_stage = 0
    saw_on_air = 0
    saw_off_air = 0
    saw_no_detect = 0
    has_status_flow = 0

    row_stage = 0
    saw_draw_row_92 = 0
    saw_draw_row_110 = 0
    saw_draw_row_128 = 0
    saw_draw_row_146 = 0
    saw_draw_row_164 = 0
    saw_draw_row_182 = 0
    saw_draw_row_200 = 0
    saw_draw_row_218 = 0

    avail_stage = 0
    saw_compute_htc = 0
    saw_update_ctrl_h = 0
    saw_diag_counter = 0
    saw_true_false = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function note_row(row) {
    if (row == 92) {
        saw_draw_row_92 = 1
        if (row_stage == 0) row_stage = 1
    } else if (row == 110) {
        saw_draw_row_110 = 1
        if (row_stage == 1) row_stage = 2
    } else if (row == 128) {
        saw_draw_row_128 = 1
        if (row_stage == 2) row_stage = 3
    } else if (row == 146) {
        saw_draw_row_146 = 1
        if (row_stage == 3) row_stage = 4
    } else if (row == 164) {
        saw_draw_row_164 = 1
        if (row_stage == 4) row_stage = 5
    } else if (row == 182) {
        saw_draw_row_182 = 1
        if (row_stage == 5) row_stage = 6
    } else if (row == 200) {
        saw_draw_row_200 = 1
        if (row_stage == 6) row_stage = 7
    } else if (row == 218) {
        saw_draw_row_218 = 1
        if (row_stage == 7) row_stage = 8
    }
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQFUNC_DRAWDIAGNOSTICSSCREEN:/) has_entry = 1
    if (u ~ /^RTS$/) has_return = 1

    if (n ~ /GLOBALHANDLETOPAZFONT/ && n ~ /LVOSETFONT/) saw_topaz_font = 1
    if (n ~ /GLOBALHANDLEPREVUECFONT/ && n ~ /LVOSETFONT/) saw_prevuec_font = 1

    if (n ~ /READCIABBIT5MASK/ || n ~ /SCRIPTREADHANDSHAKEBIT5MASK/) saw_bit5 = 1
    if (n ~ /SCRIPTGETCTRLLINEFLAG/) saw_ctrl_line = 1
    if (n ~ /READCIABBIT3FLAG/ || n ~ /SCRIPTREADHANDSHAKEBIT3FLAG/) saw_bit3 = 1
    if (n ~ /SCRIPTCTRLHANDSHAKESTAGE/) saw_mode_stage = 1
    if (n ~ /ESQFUNCSTRONAIR/) saw_on_air = 1
    if (n ~ /ESQFUNCSTROFFAIR/) saw_off_air = 1
    if (n ~ /ESQFUNCSTRNODETECT/) saw_no_detect = 1

    if (u ~ /PEA \(\$5C\)\.W/ || u ~ /PEA 92\.W/) note_row(92)
    if (u ~ /PEA \(\$6E\)\.W/ || u ~ /PEA 110\.W/) note_row(110)
    if (u ~ /PEA \(\$80\)\.W/ || u ~ /PEA 128\.W/) note_row(128)
    if (u ~ /PEA \(\$92\)\.W/ || u ~ /PEA 146\.W/) note_row(146)
    if (u ~ /PEA \(\$A4\)\.W/ || u ~ /PEA 164\.W/) note_row(164)
    if (u ~ /PEA \(\$B6\)\.W/ || u ~ /PEA 182\.W/) note_row(182)
    if (u ~ /PEA \(\$C8\)\.W/ || u ~ /PEA 200\.W/) note_row(200)
    if (u ~ /PEA \(\$DA\)\.W/ || u ~ /PEA 218\.W/) note_row(218)

    if (u ~ /MOVE\.L #\$20002,\(A7\)|MOVE\.L #\$20002,D1/) {
        if (avail_stage == 0) avail_stage = 1
    } else if ((u ~ /PEA \(\$4\)\.W/ || u ~ /MOVEQ #4,D1/) && avail_stage == 1) {
        avail_stage = 2
    } else if ((u ~ /MOVE\.L #\$20000,\(A7\)|SWAP D1/) && avail_stage == 2) {
        avail_stage = 3
    }

    if (n ~ /PARSEINICOMPUTEHTCMAXVALUES/) saw_compute_htc = 1
    if (n ~ /PARSEINIUPDATECTRLHDELTAMAX/) saw_update_ctrl_h = 1
    if (n ~ /ESQFUNCDIAGROWCOUNTER/ && (u ~ /ADDQ\.L #1/ || u ~ /ADDQ\.L #\$1/)) saw_diag_counter = 1
    if (n ~ /GLOBALSTRTRUE2/ && n ~ /GLOBALSTRFALSE2/) saw_true_false = 1
}

END {
    if (saw_bit5 && saw_ctrl_line && saw_bit3 && saw_mode_stage &&
        saw_on_air && saw_off_air && saw_no_detect) {
        has_status_flow = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_STATUS_FLOW=" has_status_flow
    print "HAS_TOPAZ_FONT_CALL=" saw_topaz_font
    print "HAS_PREVUEC_FONT_CALL=" saw_prevuec_font
    print "HAS_DRAW_ROW_92=" saw_draw_row_92
    print "HAS_DRAW_ROW_110=" saw_draw_row_110
    print "HAS_DRAW_ROW_128=" saw_draw_row_128
    print "HAS_DRAW_ROW_146=" saw_draw_row_146
    print "HAS_DRAW_ROW_164=" saw_draw_row_164
    print "HAS_DRAW_ROW_182=" saw_draw_row_182
    print "HAS_DRAW_ROW_200=" saw_draw_row_200
    print "HAS_DRAW_ROW_218=" saw_draw_row_218
    print "HAS_DRAW_ROW_ORDER=" (row_stage == 8 ? 1 : 0)
    print "HAS_AVAILMEM_FLOW=" (avail_stage == 3 ? 1 : 0)
    print "HAS_COMPUTE_HTC=" saw_compute_htc
    print "HAS_UPDATE_CTRL_H=" saw_update_ctrl_h
    print "HAS_DIAG_COUNTER_INCREMENT=" saw_diag_counter
    print "HAS_TRUE_FALSE_SELECT=" saw_true_false
    print "HAS_RETURN=" has_return
}
