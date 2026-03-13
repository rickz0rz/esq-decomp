BEGIN {
    has_entry=0
    has_draw_grid_entry=0
    has_layout_append=0
    has_mode_flag=0
    has_bevel_cfg=0
    has_no_data=0
    has_off_air=0
    has_const2=0
    has_const3=0
    has_const1=0
    has_const89=0
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

    if (u ~ /^NEWGRID_DRAWENTRYROWORPLACEHOLDER:/ || u ~ /^NEWGRID_DRAWENTRYROWORPLAC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDENTRY/) has_draw_grid_entry=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTANDAPPENDTOB/ || n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTA/ || n ~ /DISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /DISPTEXTLAYOUTANDAPPENDTOB/) has_layout_append=1
    if (n ~ /NEWGRIDENTRYPLACEHOLDERMODEFLAG/ || n ~ /NEWGRIDENTRYPLACEHOLDERMODEF/) has_mode_flag=1
    if (n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELFLAG/ || n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELF/) has_bevel_cfg=1
    if (n ~ /SCRIPTPTRNODATAPLACEHOLDER/ || n ~ /SCRIPTPTRNODATAPLACEH/) has_no_data=1
    if (n ~ /SCRIPTPTROFFAIRPLACEHOLDER/ || n ~ /SCRIPTPTROFFAIRPLACEH/) has_off_air=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /\(\$59\)/) has_const89=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_GRID_ENTRY_CALL="has_draw_grid_entry
    print "HAS_LAYOUT_APPEND_CALL="has_layout_append
    print "HAS_MODE_FLAG_GLOBAL="has_mode_flag
    print "HAS_BEVEL_CFG_GLOBAL="has_bevel_cfg
    print "HAS_NO_DATA_GLOBAL="has_no_data
    print "HAS_OFF_AIR_GLOBAL="has_off_air
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_89="has_const89
    print "HAS_RTS="has_rts
}
