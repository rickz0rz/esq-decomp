BEGIN {
    has_entry=0
    has_getptr=0
    has_halfhour=0
    has_divs=0
    has_count=0
    has_day_slot=0
    has_window_minutes=0
    has_const48=0
    has_const96=0
    has_const29=0
    has_const30=0
    has_btst4=0
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

    if (u ~ /^NEWGRID_INITSELECTIONWINDOW:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/) has_getptr=1
    if (n ~ /NEWGRID2JMPTBLESQGETHALFHOURSLOTINDEX/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURS/) has_halfhour=1
    if (n ~ /SCRIPT3JMPTBLMATHDIVS32/ || n ~ /SCRIPT3JMPTBLMATHDIVS/) has_divs=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPPRIMARYGROUPENTRYCO/) has_count=1
    if (n ~ /CLOCKDAYSLOTINDEX/) has_day_slot=1
    if (n ~ /GCOMMANDPPVSELECTIONWINDOWMINUTES/ || n ~ /GCOMMANDPPVSELECTIONWINDOWMI/) has_window_minutes=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)/) has_const48=1
    if (u ~ /#96([^0-9]|$)/ || u ~ /#\$60/ || u ~ /96\.[Ww]/ || u ~ /\(\$60\)/) has_const96=1
    if (u ~ /#29([^0-9]|$)/ || u ~ /#\$1D/ || u ~ /29\.[Ww]/ || u ~ /\(\$1D\)/) has_const29=1
    if (u ~ /#30([^0-9]|$)/ || u ~ /#\$1E/ || u ~ /30\.[Ww]/ || u ~ /\(\$1E\)/) has_const30=1
    if (n ~ /BTST42F/ || n ~ /BTST447A0/ || n ~ /BTST447/) has_btst4=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GETPTR_CALL="has_getptr
    print "HAS_HALFHOUR_CALL="has_halfhour
    print "HAS_DIVS_CALL="has_divs
    print "HAS_COUNT_GLOBAL="has_count
    print "HAS_DAY_SLOT_GLOBAL="has_day_slot
    print "HAS_WINDOW_MINUTES_GLOBAL="has_window_minutes
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_96="has_const96
    print "HAS_CONST_29="has_const29
    print "HAS_CONST_30="has_const30
    print "HAS_BTST4="has_btst4
    print "HAS_RTS="has_rts
}
