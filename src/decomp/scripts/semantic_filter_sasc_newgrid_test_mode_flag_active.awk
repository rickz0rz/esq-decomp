BEGIN {
    has_entry=0
    has_primary=0
    has_alt=0
    has_cmp_mode0=0
    has_cmp_mode1=0
    has_const89=0
    has_const1=0
    has_const0=0
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

    if (u ~ /^NEWGRID_TESTMODEFLAGACTIVE:/ || u ~ /^NEWGRID_TESTMODEFLAGACT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE34PRIMARYENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE34PRIMARYEN/ || n ~ /CONFIGNEWGRIDSELECTIONCODE34PRI/) has_primary=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE34ALTENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE34ALTENABL/ || n ~ /CONFIGNEWGRIDSELECTIONCODE34ALT/) has_alt=1
    if (u ~ /TST\.L D7/ || u ~ /CMP\.L .*D7/ || u ~ /CMP\.L D0,D7/) has_cmp_mode0=1
    if (u ~ /CMP\.L .*D7/ || u ~ /CMP\.L D0,D7/ || u ~ /SUBQ\.L #\$1,D0/ || u ~ /SUBQ\.L #1,D0/) has_cmp_mode1=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /\(\$59\)/) has_const89=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || u ~ /0\.[Ww]/ || u ~ /\(\$0\)/ || u ~ /CLR\./) has_const0=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PRIMARY_FLAG_GLOBAL="has_primary
    print "HAS_ALT_FLAG_GLOBAL="has_alt
    print "HAS_MODE0_CHECK="has_cmp_mode0
    print "HAS_MODE1_CHECK="has_cmp_mode1
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_0="has_const0
    print "HAS_RTS="has_rts
}
