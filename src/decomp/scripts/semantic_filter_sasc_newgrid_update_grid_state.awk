BEGIN {
    has_entry=0
    has_latch_global=0
    has_update_preset=0
    has_testbit=0
    has_find_prev=0
    has_select_pen=0
    has_draw_badge=0
    has_visible_count=0
    has_draw_frame=0
    has_const4=0
    has_const5=0
    has_const_minus1=0
    has_rts=0
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

    if (u ~ /^NEWGRID_UPDATEGRIDSTATE:/ || u ~ /^NEWGRID_UPDATEGRIDSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDGRIDSTATEFRAMELATCH/) has_latch_global=1
    if (n ~ /NEWGRIDUPDATEPRESETENTRY/) has_update_preset=1
    if (n ~ /NEWGRID2JMPTBLESQTESTBIT1BASED/ || n ~ /NEWGRID2JMPTBLESQTESTBIT1BASE/ ||
        n ~ /ESQTESTBIT1BASED/ || n ~ /ESQTESTBIT1BASE/) has_testbit=1
    if (n ~ /NEWGRID2JMPTBLDISPLIBFINDPREVIOUSVALIDENTRYINDEX/ || n ~ /NEWGRID2JMPTBLDISPLIBFINDPREVIOUSVALID/ || n ~ /NEWGRID2JMPTBLDISPLIBFINDPREV/ ||
        n ~ /DISPLIBFINDPREVIOUSVALIDENTRYINDEX/ || n ~ /DISPLIBFINDPREVIOUSVALID/ || n ~ /DISPLIBFINDPREV/) has_find_prev=1
    if (n ~ /NEWGRIDSELECTENTRYPEN/) has_select_pen=1
    if (n ~ /NEWGRIDDRAWENTRYFLAGBADGE/) has_draw_badge=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLE/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/ ||
        n ~ /DISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /DISPTEXTCOMPUTEVISIBLE/) has_visible_count=1
    if (n ~ /NEWGRIDDRAWGRIDFRAMEANDROWS/) has_draw_frame=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) has_const_minus1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_LATCH_GLOBAL="has_latch_global
    print "HAS_UPDATE_PRESET_CALL="has_update_preset
    print "HAS_TESTBIT_CALL="has_testbit
    print "HAS_FIND_PREV_CALL="has_find_prev
    print "HAS_SELECT_PEN_CALL="has_select_pen
    print "HAS_DRAW_BADGE_CALL="has_draw_badge
    print "HAS_VISIBLE_COUNT_CALL="has_visible_count
    print "HAS_DRAW_FRAME_CALL="has_draw_frame
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_RTS="has_rts
}
