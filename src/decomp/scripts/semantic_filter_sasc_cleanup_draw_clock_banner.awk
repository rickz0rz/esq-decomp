BEGIN {
    has_label = 0
    has_ui_busy_gate = 0
    has_mode_y = 0
    has_adjust24 = 0
    has_sprintf = 0
    has_setapen = 0
    has_rectfill = 0
    has_bevel = 0
    has_move = 0
    has_text = 0
    has_blt = 0
    has_const_35 = 0
    has_const_33 = 0
    has_const_34 = 0
    has_const_192 = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWCLOCKBANNER[A-Z0-9_]*:/) has_label = 1
    if (u ~ /GLOBAL_UIBUSYFLAG/ || u ~ /TST\.W .*UIBUSY/ || u ~ /BNE\.W .*DONE/) has_ui_busy_gate = 1
    if (u ~ /#89/ || u ~ /#\$59/) has_mode_y = 1
    if (u ~ /ADJUSTHOURSTO24HRFORMAT/ || u ~ /PARSEINI_ADJUSTH/) has_adjust24 = 1
    if (u ~ /WDISP_SPRINTF/ || u ~ /WDISP_SPRINT/) has_sprintf = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/ || u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPR/) has_bevel = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVOTEXT/) has_text = 1
    if (u ~ /BLTBITMAPRASTPORT/ || u ~ /BLTBITM/) has_blt = 1
    if (u ~ /#35/ || u ~ /#\$23/) has_const_35 = 1
    if (u ~ /#33/ || u ~ /#\$21/ || u ~ /PEA \(\$21\)\.W/ || u ~ /PEA 33\.W/) has_const_33 = 1
    if (u ~ /#34/ || u ~ /#\$22/ || u ~ /PEA \(\$22\)\.W/ || u ~ /PEA 34\.W/) has_const_34 = 1
    if (u ~ /#192/ || u ~ /#\$C0/ || u ~ /PEA \(\$C0\)\.W/ || u ~ /PEA 192\.W/) has_const_192 = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_UI_BUSY_GATE=" has_ui_busy_gate
    print "HAS_MODE_Y=" has_mode_y
    print "HAS_ADJUST24=" has_adjust24
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_BEVEL=" has_bevel
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_BLT=" has_blt
    print "HAS_CONST_35=" has_const_35
    print "HAS_CONST_33=" has_const_33
    print "HAS_CONST_34=" has_const_34
    print "HAS_CONST_192=" has_const_192
    print "HAS_RETURN=" has_return
}
