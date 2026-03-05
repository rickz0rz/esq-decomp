BEGIN {
    has_label = 0
    has_format_timestamp = 0
    has_setapen = 0
    has_setdrmd = 0
    has_rectfill = 0
    has_textlength = 0
    has_move = 0
    has_text = 0
    has_adjust24 = 0
    has_sprintf = 0
    has_blt = 0
    has_mode_y = 0
    has_mode_n = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWGRIDTIMEBANNER[A-Z0-9_]*:/) has_label = 1
    if (u ~ /ESQ_FORMATTIMESTAMP/ || u ~ /ESQ_FORMATTIMESTAM/) has_format_timestamp = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVOSETDRMD/) has_setdrmd = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /_LVOTEXTLENGTH/) has_textlength = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVOTEXT/) has_text = 1
    if (u ~ /ADJUSTHOURSTO24HRFORMAT/ || u ~ /ADJUSTHOURSTO24HRFO/ || u ~ /GROUP_AC_JMPTBL_PARSEINI_ADJUSTH/) has_adjust24 = 1
    if (u ~ /WDISP_SPRINTF/ || u ~ /WDISP_SPRINT/) has_sprintf = 1
    if (u ~ /BLTBITMAPRASTPORT/ || u ~ /BLTBITMAPRASTPO/ || u ~ /BLTBITM/) has_blt = 1
    if (u ~ /#89/ || u ~ /\$59/) has_mode_y = 1
    if (u ~ /#78/ || u ~ /\$4E/) has_mode_n = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_FORMAT_TIMESTAMP=" has_format_timestamp
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_ADJUST24=" has_adjust24
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_BLT=" has_blt
    print "HAS_MODE_Y=" has_mode_y
    print "HAS_MODE_N=" has_mode_n
    print "HAS_RETURN=" has_return
}
