BEGIN {
    has_entry = 0
    has_set_font_topaz = 0
    has_set_font_prevuec = 0
    has_copper_init = 0
    has_bit5 = 0
    has_ctrl_line = 0
    has_bit3 = 0
    has_sprintf = 0
    has_draw_centered = 0
    has_availmem = 0
    has_compute_htc = 0
    has_update_ctrl_h = 0
    has_diag_row = 0
    has_true_false = 0
    has_clock_ampm = 0
    has_runtime_mode = 0
    has_locavail_state_08 = 0
    has_locavail_state_0c = 0
    has_row_92 = 0
    has_row_110 = 0
    has_row_128 = 0
    has_row_146 = 0
    has_row_164 = 0
    has_row_182 = 0
    has_row_200 = 0
    has_row_218 = 0
    draw_stage = 0
    pending_topaz_font = 0
    pending_prevuec_font = 0
    pending_row_92 = 0
    pending_row_110 = 0
    pending_row_128 = 0
    pending_row_146 = 0
    pending_row_164 = 0
    pending_row_182 = 0
    pending_row_200 = 0
    pending_row_218 = 0
    has_rts = 0
}

function trim(s,    t) {
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQFUNC_DRAWDIAGNOSTICSSCREEN:/) has_entry = 1
    if (n ~ /GLOBALHANDLETOPAZFONT/) pending_topaz_font = 1
    if (n ~ /GLOBALHANDLEPREVUECFONT/) pending_prevuec_font = 1
    if (n ~ /LVOSETFONT/) {
        if (pending_topaz_font != 0) has_set_font_topaz = 1
        if (pending_prevuec_font != 0) has_set_font_prevuec = 1
        pending_topaz_font = 0
        pending_prevuec_font = 0
    }
    if (n ~ /ESQCOPPERSTATUSDIGITSA/ || n ~ /ESQCOPPERSTATUSDIGITSBCOLORREGISTERSA/ || n ~ /TAILCOLORWORD/) has_copper_init = 1
    if (n ~ /READCIABBIT5MASK/ || n ~ /SCRIPTREADHANDSHAKEBIT5MASK/ || n ~ /READCIABBI/) has_bit5 = 1
    if (n ~ /SCRIPTGETCTRLLINEFLAG/) has_ctrl_line = 1
    if (n ~ /READCIABBIT3FLAG/ || n ~ /SCRIPTREADHANDSHAKEBIT3FLAG/ || n ~ /READCIABBI/) has_bit3 = 1
    if (n ~ /WDISPSPRINTF/) has_sprintf = 1
    if (u ~ /92\.W/ || u ~ /\(\$5C\)\.W/) pending_row_92 = 1
    if (u ~ /110\.W/ || u ~ /\(\$6E\)\.W/) pending_row_110 = 1
    if (u ~ /128\.W/ || u ~ /\(\$80\)\.W/) pending_row_128 = 1
    if (u ~ /146\.W/ || u ~ /\(\$92\)\.W/) pending_row_146 = 1
    if (u ~ /164\.W/ || u ~ /\(\$A4\)\.W/) pending_row_164 = 1
    if (u ~ /182\.W/ || u ~ /\(\$B6\)\.W/) pending_row_182 = 1
    if (u ~ /200\.W/ || u ~ /\(\$C8\)\.W/) pending_row_200 = 1
    if (u ~ /218\.W/ || u ~ /\(\$DA\)\.W/) pending_row_218 = 1
    if (n ~ /DRAWCENTEREDWRAPPEDTEXTLINES/ || n ~ /DRAWCENTEREDWRAPPEDTEXTLI/) {
        has_draw_centered = 1
        if (pending_row_92 != 0) {
            has_row_92 = 1
            if (draw_stage == 0) draw_stage = 1
            pending_row_92 = 0
        }
        if (pending_row_110 != 0) {
            has_row_110 = 1
            if (draw_stage == 1) draw_stage = 2
            pending_row_110 = 0
        }
        if (pending_row_128 != 0) {
            has_row_128 = 1
            if (draw_stage == 2) draw_stage = 3
            pending_row_128 = 0
        }
        if (pending_row_146 != 0) {
            has_row_146 = 1
            if (draw_stage == 3) draw_stage = 4
            pending_row_146 = 0
        }
        if (pending_row_164 != 0) {
            has_row_164 = 1
            if (draw_stage == 4) draw_stage = 5
            pending_row_164 = 0
        }
        if (pending_row_182 != 0) {
            has_row_182 = 1
            if (draw_stage == 5) draw_stage = 6
            pending_row_182 = 0
        }
        if (pending_row_200 != 0) {
            has_row_200 = 1
            if (draw_stage == 6) draw_stage = 7
            pending_row_200 = 0
        }
        if (pending_row_218 != 0) {
            has_row_218 = 1
            if (draw_stage == 7) draw_stage = 8
            pending_row_218 = 0
        }
    }
    if (n ~ /LVOAVAILMEM/) has_availmem = 1
    if (n ~ /PARSEINICOMPUTEHTCMAXVALUES/) has_compute_htc = 1
    if (n ~ /PARSEINIUPDATECTRLHDELTAMAX/) has_update_ctrl_h = 1
    if (n ~ /ESQFUNCDIAGROWCOUNTER/) has_diag_row = 1
    if (n ~ /GLOBALSTRTRUE2/ || n ~ /GLOBALSTRFALSE2/) has_true_false = 1
    if (n ~ /ESQFUNCSTRPM/ || n ~ /ESQFUNCSTRAM/) has_clock_ampm = 1
    if (n ~ /ESQFUNCSTRONAIR/ || n ~ /ESQFUNCSTROFFAIR/ || n ~ /ESQFUNCSTRNODETECT/) has_runtime_mode = 1
    if (n ~ /LOCAVAILPRIMARYFILTERSTATEFIELD08/ || u ~ /LOCAVAIL_PRIMARYFILTERSTATE\+\$8/) has_locavail_state_08 = 1
    if (n ~ /LOCAVAILPRIMARYFILTERSTATEFIELD0C/ || u ~ /LOCAVAIL_PRIMARYFILTERSTATE\+\$C/) has_locavail_state_0c = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SET_FONT_TOPAZ=" has_set_font_topaz
    print "HAS_SET_FONT_PREVUEC=" has_set_font_prevuec
    print "HAS_COPPER_INIT=" has_copper_init
    print "HAS_BIT5=" has_bit5
    print "HAS_CTRL_LINE=" has_ctrl_line
    print "HAS_BIT3=" has_bit3
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_DRAW_CENTERED=" has_draw_centered
    print "HAS_AVAILMEM=" has_availmem
    print "HAS_COMPUTE_HTC=" has_compute_htc
    print "HAS_UPDATE_CTRL_H=" has_update_ctrl_h
    print "HAS_DIAG_ROW=" has_diag_row
    print "HAS_TRUE_FALSE=" has_true_false
    print "HAS_CLOCK_AMPM=" has_clock_ampm
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_LOCAVAIL_STATE_08=" has_locavail_state_08
    print "HAS_LOCAVAIL_STATE_0C=" has_locavail_state_0c
    print "HAS_ROW_92=" has_row_92
    print "HAS_ROW_110=" has_row_110
    print "HAS_ROW_128=" has_row_128
    print "HAS_ROW_146=" has_row_146
    print "HAS_ROW_164=" has_row_164
    print "HAS_ROW_182=" has_row_182
    print "HAS_ROW_200=" has_row_200
    print "HAS_ROW_218=" has_row_218
    print "HAS_DRAW_ROW_ORDER=" (draw_stage == 8 ? 1 : 0)
    print "HAS_RTS=" has_rts
}
