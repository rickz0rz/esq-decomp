BEGIN {
    has_entry=0
    has_halfhour_call=0
    has_const50=0
    has_const20=0
    has_const29=0
    has_const48=0
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

    if (u ~ /^NEWGRID_COMPUTEDAYSLOTFROMCLOCK:/ || u ~ /^NEWGRID_COMPUTEDAYSLOTFROMCLOC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQGETHALFHOURSLOTINDEX/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURSLOTIND/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURS/ || n ~ /ESQGETHALFHOURSLOTINDEX/ || n ~ /ESQGETHALFHOURSLOTIND/ || n ~ /ESQGETHALFHOURS/) has_halfhour_call=1
    if (u ~ /#50([^0-9]|$)/ || u ~ /#\$32/ || u ~ /50\.[Ww]/ || u ~ /#49([^0-9]|$)/ || u ~ /#\$31/) has_const50=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/ || u ~ /20\.[Ww]/ || u ~ /#-20([^0-9]|$)/ || u ~ /#\$FFEC/) has_const20=1
    if (u ~ /#29([^0-9]|$)/ || u ~ /#\$1D/ || u ~ /29\.[Ww]/ || u ~ /#9([^0-9]|$)/ || u ~ /#\$09/) has_const29=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/) has_const48=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/) has_const1=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_HALFHOUR_CALL="has_halfhour_call
    print "HAS_CONST_50="has_const50
    print "HAS_CONST_20="has_const20
    print "HAS_CONST_29="has_const29
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_1="has_const1
    print "HAS_RETURN="has_return
}
