BEGIN {
    has_entry=0
    has_gridop=0
    has_override=0
    has_niche_text=0
    has_niche_frame=0
    has_mplex_layout=0
    has_mplex_row=0
    has_ppv_layout=0
    has_ppv_row=0
    has_const15=0
    has_const7=0
    has_const6=0
    has_const5=0
    has_const4=0
    has_const3=0
    has_const1=0
    has_constm1=0
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

    if (u ~ /^NEWGRID_SELECTENTRYPEN:/) has_entry=1
    if (n ~ /NEWGRIDGRIDOPERATIONID/) has_gridop=1
    if (n ~ /NEWGRIDOVERRIDEPENINDEX/) has_override=1
    if (n ~ /GCOMMANDNICHETEXTPEN/) has_niche_text=1
    if (n ~ /GCOMMANDNICHEFRAMEPEN/) has_niche_frame=1
    if (n ~ /GCOMMANDMPLEXDETAILLAYOUTPEN/ || n ~ /GCOMMANDMPLEXDETAILLAYOUTP/) has_mplex_layout=1
    if (n ~ /GCOMMANDMPLEXDETAILROWPEN/ || n ~ /GCOMMANDMPLEXDETAILROWPE/) has_mplex_row=1
    if (n ~ /GCOMMANDPPVSHOWTIMESLAYOUTPEN/ || n ~ /GCOMMANDPPVSHOWTIMESLAYOUT/) has_ppv_layout=1
    if (n ~ /GCOMMANDPPVSHOWTIMESROWPEN/ || n ~ /GCOMMANDPPVSHOWTIMESROWPE/) has_ppv_row=1
    if (u ~ /#15([^0-9]|$)/ || u ~ /#\$0F/ || u ~ /#\$F([^0-9A-F]|$)/ || u ~ /15\.[Ww]/ || u ~ /\(\$F\)/) has_const15=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /#\$7([^0-9A-F]|$)/ || u ~ /7\.[Ww]/ || u ~ /\(\$7\)/) has_const7=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/ || u ~ /6\.[Ww]/ || u ~ /\(\$6\)/) has_const6=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/ || u ~ /NOT\.B/) has_constm1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GRIDOP_GLOBAL="has_gridop
    print "HAS_OVERRIDE_GLOBAL="has_override
    print "HAS_NICHE_TEXT_GLOBAL="has_niche_text
    print "HAS_NICHE_FRAME_GLOBAL="has_niche_frame
    print "HAS_MPLEX_LAYOUT_GLOBAL="has_mplex_layout
    print "HAS_MPLEX_ROW_GLOBAL="has_mplex_row
    print "HAS_PPV_LAYOUT_GLOBAL="has_ppv_layout
    print "HAS_PPV_ROW_GLOBAL="has_ppv_row
    print "HAS_CONST_15="has_const15
    print "HAS_CONST_7="has_const7
    print "HAS_CONST_6="has_const6
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_RTS="has_rts
}
