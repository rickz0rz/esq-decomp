BEGIN {
    has_entry=0
    has_get_entry_mode=0
    has_get_aux_mode=0
    has_halfhour_call=0
    has_wildcard_call=0
    has_secondary_present=0
    has_secondary_count=0
    has_secondary_table=0
    has_cache_ptr=0
    has_const48=0
    has_const1=0
    has_const2=0
    has_const12=0
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

    if (u ~ /^NEWGRID_UPDATEPRESETENTRY:/ || u ~ /^NEWGRID_UPDATEPRESETENTR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/) has_get_entry_mode=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYAUXPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/) has_get_aux_mode=1
    if (n ~ /NEWGRID2JMPTBLESQGETHALFHOURSLOTINDEX/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURS/) has_halfhour_call=1
    if (n ~ /NEWGRID2JMPTBLTLIBAFINDFIRSTWILDCARDMATCHINDEX/ || n ~ /NEWGRID2JMPTBLTLIBAFINDFIRSTWILDCARD/ || n ~ /NEWGRID2JMPTBLTLIBAFINDFIRSTW/) has_wildcard_call=1
    if (n ~ /TEXTDISPSECONDARYGROUPPRESENTFLAG/ || n ~ /TEXTDISPSECONDARYGROUPPRESENTFL/) has_secondary_present=1
    if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPSECONDARYGROUPENTRYCOUN/) has_secondary_count=1
    if (n ~ /TEXTDISPSECONDARYENTRYPTRTABLE/) has_secondary_table=1
    if (n ~ /NEWGRIDSECONDARYINDEXCACHEPTR/) has_cache_ptr=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/) has_const48=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /#12([^0-9]|$)/ || u ~ /#\$0C/ || u ~ /#\$C([^0-9A-F]|$)/ || u ~ /12\.[Ww]/ || u ~ /\(\$C\)/) has_const12=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GET_ENTRY_MODE_CALL="has_get_entry_mode
    print "HAS_GET_AUX_MODE_CALL="has_get_aux_mode
    print "HAS_HALFHOUR_CALL="has_halfhour_call
    print "HAS_WILDCARD_CALL="has_wildcard_call
    print "HAS_SECONDARY_PRESENT_GLOBAL="has_secondary_present
    print "HAS_SECONDARY_COUNT_GLOBAL="has_secondary_count
    print "HAS_SECONDARY_TABLE_GLOBAL="has_secondary_table
    print "HAS_CACHE_PTR_GLOBAL="has_cache_ptr
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_12="has_const12
    print "HAS_RTS="has_rts
}
