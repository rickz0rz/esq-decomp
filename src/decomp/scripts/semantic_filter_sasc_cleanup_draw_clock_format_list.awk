BEGIN {
    has_label = 0
    has_update_bounds = 0
    has_setapen = 0
    has_rectfill = 0
    has_wrap_48 = 0
    has_mulu32 = 0
    has_bevel = 0
    has_format = 0
    has_textlength = 0
    has_move = 0
    has_text = 0
    has_const_695 = 0
    has_const_33 = 0
    has_const_42 = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWCLOCKFORMATLIST[A-Z0-9_]*:/) has_label = 1
    if (u ~ /UPDATEBANNERBOUNDS/ || u ~ /GROUP_AC_JMPTBL_GCOMMAND_UPDATEB/) has_update_bounds = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /#48/ || u ~ /#\$30/ || u ~ /CLEANUP_WRAP_CLOCK_IDX/) has_wrap_48 = 1
    if (u ~ /MULU32/) has_mulu32 = 1
    if (u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/ || u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPR/) has_bevel = 1
    if (u ~ /CLEANUP_FORMATCLOCKFORMATENTRY/ || u ~ /CLEANUP_FORMATCLOCKFORMATEN/) has_format = 1
    if (u ~ /_LVOTEXTLENGTH/) has_textlength = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVOTEXT/) has_text = 1
    if (u ~ /#695/ || u ~ /#\$2B7/) has_const_695 = 1
    if (u ~ /#33/ || u ~ /#\$21/ || u ~ /PEA \(\$21\)\.W/ || u ~ /PEA 33\.W/) has_const_33 = 1
    if (u ~ /#42/ || u ~ /#\$2A/) has_const_42 = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_UPDATE_BOUNDS=" has_update_bounds
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_WRAP_48=" has_wrap_48
    print "HAS_MULU32=" has_mulu32
    print "HAS_BEVEL=" has_bevel
    print "HAS_FORMAT=" has_format
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_CONST_695=" has_const_695
    print "HAS_CONST_33=" has_const_33
    print "HAS_CONST_42=" has_const_42
    print "HAS_RETURN=" has_return
}
