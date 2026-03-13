BEGIN {
    has_entry=0
    has_drawgridframe_call=0
    has_setapen_call=0
    has_textlength_call=0
    has_drawwrappedtext_call=0
    has_bevel_call=0
    has_awaiting_msg_global=0
    has_rowheight_global=0
    has_const624=0
    has_const612=0
    has_const695=0
    has_const36=0
    has_const7=0
    has_const4=0
    has_const1=0
    has_return=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_DRAWAWAITINGLISTINGSMESSAGE:/ || u ~ /^NEWGRID_DRAWAWAITINGLISTINGSMESSAG[A-Z0-9_]*:/ || u ~ /^NEWGRID_DRAWAWAITINGLISTINGSMESS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDFRAME/) has_drawgridframe_call=1
    if (n ~ /LVOSETAPEN/) has_setapen_call=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlength_call=1
    if (n ~ /NEWGRIDDRAWWRAPPEDTEXT/) has_drawwrappedtext_call=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/ || n ~ /BEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /BEVELDRAWBEVELFRAMEWITHTOPR/ || n ~ /BEVELDRAWBEVELF/) has_bevel_call=1
    if (n ~ /GLOBALPTRSTRER007AWAITINGLISTINGSDATATRANSMISSION/ || n ~ /GLOBALPTRSTRER007AWAITINGLISTINGSDATATRANS/ || n ~ /GLOBALPTRSTRER007AWAITINGLI/) has_awaiting_msg_global=1
    if (n ~ /NEWGRIDROWHEIGHTPX/) has_rowheight_global=1
    if (u ~ /#624/ || u ~ /#\$270/ || u ~ /624\.[Ww]/ || u ~ /\$270/ || u ~ /#\$4E/) has_const624=1
    if (u ~ /#612/ || u ~ /#\$264/ || u ~ /612\.[Ww]/ || u ~ /\$264/) has_const612=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /695\.[Ww]/ || u ~ /\$2B7/) has_const695=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /36\.[Ww]/ || u ~ /\(\$24\)/) has_const36=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /7\.[Ww]/ || u ~ /\(\$7\)/) has_const7=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAWGRIDFRAME_CALL="has_drawgridframe_call
    print "HAS_SETAPEN_CALL="has_setapen_call
    print "HAS_TEXTLENGTH_CALL="has_textlength_call
    print "HAS_DRAWWRAPPEDTEXT_CALL="has_drawwrappedtext_call
    print "HAS_BEVEL_CALL="has_bevel_call
    print "HAS_AWAITING_MSG_GLOBAL="has_awaiting_msg_global
    print "HAS_ROWHEIGHT_GLOBAL="has_rowheight_global
    print "HAS_CONST_624="has_const624
    print "HAS_CONST_612="has_const612
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_7="has_const7
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_1="has_const1
    print "HAS_RETURN="has_return
}
