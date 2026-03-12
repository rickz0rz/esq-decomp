BEGIN {
    has_entry=0
    has_halfhour=0
    has_day_slot=0
    has_span_primary=0
    has_span_alt=0
    has_const48=0
    has_const96=0
    has_const1=0
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

    if (u ~ /^NEWGRID_INITSELECTIONWINDOWALT:/ || u ~ /^NEWGRID_INITSELECTIONWINDOWAL[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQGETHALFHOURSLOTINDEX/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURSL/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURS/ || n ~ /ESQGETHALFHOURSLOTINDEX/ || n ~ /ESQGETHALFHOURSLOTIND/) has_halfhour=1
    if (n ~ /CLOCKDAYSLOTINDEX/) has_day_slot=1
    if (n ~ /CONFIGNEWGRIDWINDOWSPANHALFHOURSPRIMARY/ || n ~ /CONFIGNEWGRIDWINDOWSPANHALFHOURSP/ || n ~ /CONFIGNEWGRIDWINDOWSPANHALFHOUR/) has_span_primary=1
    if (n ~ /CONFIGNEWGRIDWINDOWSPANHALFHOURSALT/ || n ~ /CONFIGNEWGRIDWINDOWSPANHALFHOURSA/ || n ~ /CONFIGNEWGRIDWINDOWSPANHALFHOUR/) has_span_alt=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)/) has_const48=1
    if (u ~ /#96([^0-9]|$)/ || u ~ /#\$60/ || u ~ /96\.[Ww]/ || u ~ /\(\$60\)/) has_const96=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_HALFHOUR_CALL="has_halfhour
    print "HAS_DAY_SLOT_GLOBAL="has_day_slot
    print "HAS_SPAN_PRIMARY_GLOBAL="has_span_primary
    print "HAS_SPAN_ALT_GLOBAL="has_span_alt
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_96="has_const96
    print "HAS_CONST_1="has_const1
    print "HAS_RTS="has_rts
}
