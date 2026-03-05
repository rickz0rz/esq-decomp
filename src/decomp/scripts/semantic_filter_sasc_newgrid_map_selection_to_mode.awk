BEGIN {
    has_entry=0
    has_gridready_call=0
    has_selectnext_call=0
    has_force5_global=0
    has_cyclecount_global=0
    has_const13=0
    has_const11=0
    has_const5=0
    has_const4=0
    has_const3=0
    has_const2=0
    has_const1=0
    has_const0=0
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

    if (u ~ /^NEWGRID_MAPSELECTIONTOMODE:/ || u ~ /^NEWGRID_MAPSELECTIONTOMOD[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDISGRIDREADYFORINPUT/ || n ~ /NEWGRIDISGRIDREADYFORINPU/) has_gridready_call=1
    if (n ~ /NEWGRIDSELECTNEXTMODE/) has_selectnext_call=1
    if (n ~ /GCOMMANDNICHEFORCEMODE5FLAG/ || n ~ /GCOMMANDNICHEFORCEMODE5F/) has_force5_global=1
    if (n ~ /GCOMMANDNICHEMODECYCLECOUNT/ || n ~ /GCOMMANDNICHEMODECYCLECOU/) has_cyclecount_global=1
    if (u ~ /#13([^0-9]|$)/ || u ~ /#\$0D/ || u ~ /#\$D([^0-9A-F]|$)/ || u ~ /13\.[Ww]/) has_const13=1
    if (u ~ /#11([^0-9]|$)/ || u ~ /#\$0B/ || u ~ /#\$B([^0-9A-F]|$)/ || u ~ /11\.[Ww]/) has_const11=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /5\.[Ww]/ || u ~ /#\$5([^0-9A-F]|$)/) has_const5=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /4\.[Ww]/ || u ~ /#\$4([^0-9A-F]|$)/) has_const4=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /3\.[Ww]/ || u ~ /#\$3([^0-9A-F]|$)/) has_const3=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /2\.[Ww]/ || u ~ /#\$2([^0-9A-F]|$)/) has_const2=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /1\.[Ww]/ || u ~ /#\$1([^0-9A-F]|$)/) has_const1=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || n ~ /CLR/) has_const0=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GRIDREADY_CALL="has_gridready_call
    print "HAS_SELECTNEXT_CALL="has_selectnext_call
    print "HAS_FORCE5_GLOBAL="has_force5_global
    print "HAS_CYCLECOUNT_GLOBAL="has_cyclecount_global
    print "HAS_CONST_13="has_const13
    print "HAS_CONST_11="has_const11
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_0="has_const0
    print "HAS_RETURN="has_return
}
