BEGIN {
    has_entry = 0
    has_setfont = 0
    has_read_bit5 = 0
    has_get_ctrl = 0
    has_read_bit3 = 0
    has_sprintf = 0
    has_draw_centered = 0
    has_compute_htc = 0
    has_update_ctrl_h = 0
    has_availmem = 0
    has_unlk = 0
    has_rts = 0
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

    if (uline ~ /^ESQFUNC_DRAWDIAGNOSTICSSCREEN:/) has_entry = 1
    if (uline ~ /LVOSETFONT\(A6\)/) has_setfont = 1
    if (uline ~ /ESQFUNC_JMPTBL_SCRIPT_READCIABBIT5MASK/) has_read_bit5 = 1
    if (uline ~ /ESQFUNC_JMPTBL_SCRIPT_GETCTRLLINEFLAG/) has_get_ctrl = 1
    if (uline ~ /ESQFUNC_JMPTBL_SCRIPT_READCIABBIT3FLAG/) has_read_bit3 = 1
    if (uline ~ /GROUP_AM_JMPTBL_WDISP_SPRINTF/) has_sprintf = 1
    if (uline ~ /ESQFUNC_JMPTBL_TLIBA3_DRAWCENTEREDWRAPPEDTEXTLINES/) has_draw_centered = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_COMPUTEHTCMAXVALUES/) has_compute_htc = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_UPDATECTRLHDELTAMAX/) has_update_ctrl_h = 1
    if (uline ~ /LVOAVAILMEM\(A6\)/) has_availmem = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETFONT=" has_setfont
    print "HAS_READ_BIT5=" has_read_bit5
    print "HAS_GET_CTRL=" has_get_ctrl
    print "HAS_READ_BIT3=" has_read_bit3
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_DRAW_CENTERED=" has_draw_centered
    print "HAS_COMPUTE_HTC=" has_compute_htc
    print "HAS_UPDATE_CTRL_H=" has_update_ctrl_h
    print "HAS_AVAILMEM=" has_availmem
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
