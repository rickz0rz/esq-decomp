BEGIN {
    step_count = 0
    saw_diag_mode_load = 0
    in_center_calc = 0
    saw_center_test = 0
    saw_center_shift = 0
    saw_font_add = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!(tag in seen)) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ED1_ENTERESCMENU[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (uline ~ /GLOBAL_UIBUSYFLAG/ && (uline ~ /#1/ || uline ~ /#\$1/)) {
        mark("SET_UI_BUSY")
    }

    if (uline ~ /ED_DIAGGRAPHMODECHAR/ && uline !~ /ED_SAVEDDIAGGRAPHMODECHAR/) {
        saw_diag_mode_load = 1
    }

    if (uline ~ /ED_SAVEDDIAGGRAPHMODECHAR/ && (uline ~ /ED_DIAGGRAPHMODECHAR/ || saw_diag_mode_load)) {
        mark("SAVE_DIAG_MODE")
        saw_diag_mode_load = 0
    }

    if (uline ~ /(JSR|BSR).*_LVOSETFONT/) {
        mark("SET_FONT")
    }

    if (uline ~ /(JSR|BSR).*_LVOINITBITMAP/) {
        mark("INIT_BITMAP")
    }

    if (uline ~ /(JSR|BSR).*_LVOSETRAST/) {
        mark("SET_RAST")
    }

    if (uline ~ /(JSR|BSR).*_LVOSETDRMD/ && (uline ~ /#1/ || uline ~ /#\$1/)) {
        mark("SET_DRAW_MODE_1_INITIAL")
    }

    if (uline ~ /(JSR|BSR).*ESQIFF_RUNCOPPERDROPTRANSITION/) {
        mark("DROP_TRANSITION")
    }

    if (uline ~ /WDISP_PALETTETRIPLESRBASE/ && uline ~ /KYBD_CUSTOMPALETTETRIPLESRBASE/) {
        mark("COPY_CUSTOM_PALETTE")
    }

    if (uline ~ /(JSR|BSR).*_LVODISABLE/) {
        mark("DISABLE")
    }

    if (uline ~ /ESQPARS2_READMODEFLAGS/ && (uline ~ /#\$100/ || uline ~ /#256/)) {
        mark("SET_READ_MODE")
    }

    if (uline ~ /^CLR\.W ESQSHARED_BANNERCOLORMODEWORD/ || uline ~ /ESQSHARED_BANNERCOLORMODEWORD.*#0/) {
        mark("CLEAR_BANNER_MODE")
    }

    if (uline ~ /(JSR|BSR).*(SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE|GROUP_AK_JMPTBL_SCRIPT_UPDATESER)/) {
        mark("SET_SERIAL_SHADOW")
    }

    if (uline ~ /(JSR|BSR).*(SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT|GROUP_AM_JMPTBL_ESQ_SETCOPPEREFF)/) {
        mark("COPPER_OFF")
    }

    if (uline ~ /^CLR\.L ED_SAVETEXTADSONEXITFLAG/ || uline ~ /ED_SAVETEXTADSONEXITFLAG.*#0/) {
        mark("CLEAR_SAVE_TEXT_ADS")
    }

    if (uline ~ /(JSR|BSR).*(ED1_JMPTBL_GCOMMAND_SEEDBANNERDE|GCOMMAND_SEEDBANNERDEFAULTS)/) {
        mark("SEED_BANNER_DEFAULTS")
    }

    if (uline ~ /(JSR|BSR).*_LVOENABLE/) {
        mark("ENABLE")
    }

    if (uline ~ /(JSR|BSR).*MATH_MULU32/) {
        mulu_hits++
        if (mulu_hits == 1) {
            mark("COMPUTE_MAX_AD")
        } else if (mulu_hits == 2) {
            mark("COMPUTE_BLOCK_OFFSET")
        }
    }

    if (uline ~ /ED_MAXADNUMBER/) {
        mark("STORE_MAX_AD")
    }

    if (uline ~ /ED_TEXTLIMIT/ && uline ~ /ED_DIAGSCROLLSPEEDCHAR/) {
        mark("SET_TEXT_LIMIT")
    }

    if (uline ~ /CMP\.L .*#\$?6/ || uline ~ /MOVEQ(\.L)? #\$?6,D[0-7]/) {
        mark("CHECK_TEXT_LIMIT_CLAMP")
    }

    if (uline ~ /MOVE\.B #\$36,ED_DIAGSCROLLSPEEDCHAR/ || uline ~ /MOVE\.B #54,ED_DIAGSCROLLSPEEDCHAR/) {
        mark("CLAMP_SCROLL_SPEED_CHAR")
    }

    if (uline ~ /ED_BLOCKOFFSET/) {
        mark("STORE_BLOCK_OFFSET")
    }

    if (uline ~ /GLOBAL_REF_LONG_CURRENT_EDITING_/ && (uline ~ /#1/ || uline ~ /#\$1/)) {
        mark("SET_CURRENT_AD")
    }

    if (uline ~ /(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/) {
        mark("DRAW_HELP")
    }

    if (uline ~ /(JSR|BSR).*WDISP_SPRINTF/) {
        mark("BUILD_VERSION_BANNER")
    }

    if (uline ~ /(JSR|BSR).*(DRAWDATETIMEBANNERROW|DRAWDATETIMEB)/) {
        mark("DRAW_DATETIME_ROW")
    }

    if (uline ~ /(JSR|BSR).*_LVOSETAPEN/ && (uline ~ /#3/ || uline ~ /#\$3/)) {
        mark("SET_APEN_3")
    }

    if (uline ~ /(JSR|BSR).*_LVOSETDRMD/ && (uline ~ /#0/ || uline ~ /CLR\.L \(A7\)/)) {
        mark("SET_DRAW_MODE_0")
    }

    if ((uline ~ /MOVE\.W 26\(A0\),D0/ || uline ~ /MOVE\.W \$18\(A0\),D[0-7]/) && !font_width_seen) {
        font_width_seen = 1
        in_center_calc = 1
        mark("LOAD_FONT_WIDTH")
    }

    if (in_center_calc && (uline ~ /^TST\.L D[0-7]$/ || uline ~ /^TST\.L D6$/)) {
        saw_center_test = 1
        mark("CHECK_CENTER_DELTA_SIGN")
    }

    if (in_center_calc && saw_center_test && !saw_center_shift && uline ~ /^ADDQ\.L #\$?1,D[0-7]$/) {
        mark("NEGATIVE_DELTA_BIAS")
    }

    if (in_center_calc && uline ~ /^ASR\.L #\$?1,D[0-7]$/) {
        saw_center_shift = 1
        mark("HALVE_CENTER_DELTA")
    }

    if (in_center_calc && saw_center_shift && !saw_font_add &&
        (uline ~ /^ADD\.L D[0-7],D[0-7]$/ || uline ~ /^ADD\.L D5,D6$/)) {
        saw_font_add = 1
        mark("ADD_FONT_WIDTH")
    }

    if (in_center_calc && saw_font_add &&
        (uline ~ /MOVEQ(\.L)? #\$?21,D[0-7]/ || uline ~ /MOVEQ(\.L)? #\$?33,D[0-7]/)) {
        mark("ADD_CENTER_OFFSET")
    }

    if (uline ~ /(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/) {
        mark("DISPLAY_VERSION_TEXT")
    }

    if (uline ~ /(JSR|BSR).*_LVOSETAPEN/ && (uline ~ /#1/ || uline ~ /#\$1/)) {
        mark("SET_APEN_1")
    }

    if (uline ~ /(JSR|BSR).*ESQIFF_RUNCOPPERRISETRANSITION/) {
        mark("RISE_TRANSITION")
    }

}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
