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
    if (n ~ /LVOSETFONT/ && n ~ /GLOBALHANDLETOPAZFONT/) has_set_font_topaz = 1
    if (n ~ /LVOSETFONT/ && n ~ /GLOBALHANDLEPREVUECFONT/) has_set_font_prevuec = 1
    if (n ~ /ESQCOPPERSTATUSDIGITSA/ || n ~ /ESQCOPPERSTATUSDIGITSBCOLORREGISTERSA/ || n ~ /TAILCOLORWORD/) has_copper_init = 1
    if (n ~ /READCIABBIT5MASK/ || n ~ /SCRIPTREADHANDSHAKEBIT5MASK/ || n ~ /READCIABBI/) has_bit5 = 1
    if (n ~ /SCRIPTGETCTRLLINEFLAG/) has_ctrl_line = 1
    if (n ~ /READCIABBIT3FLAG/ || n ~ /SCRIPTREADHANDSHAKEBIT3FLAG/ || n ~ /READCIABBI/) has_bit3 = 1
    if (n ~ /WDISPSPRINTF/) has_sprintf = 1
    if (n ~ /DRAWCENTEREDWRAPPEDTEXTLINES/ || n ~ /DRAWCENTEREDWRAPPEDTEXTLI/) has_draw_centered = 1
    if (n ~ /LVOAVAILMEM/) has_availmem = 1
    if (n ~ /PARSEINICOMPUTEHTCMAXVALUES/) has_compute_htc = 1
    if (n ~ /PARSEINIUPDATECTRLHDELTAMAX/) has_update_ctrl_h = 1
    if (n ~ /ESQFUNCDIAGROWCOUNTER/) has_diag_row = 1
    if (n ~ /GLOBALSTRTRUE2/ || n ~ /GLOBALSTRFALSE2/) has_true_false = 1
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
    print "HAS_RTS=" has_rts
}
