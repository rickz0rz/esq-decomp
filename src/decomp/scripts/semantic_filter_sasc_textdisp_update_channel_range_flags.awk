BEGIN {
    has_entry=0
    has_source_mode=0
    has_primary_channel=0
    has_secondary_channel=0
    has_range_48=0
    has_range_67=0
    has_range_72=0
    has_range_77=0
    has_weekday=0
    has_table=0
    has_find_match=0
    has_fallback_char=0
    has_selected_char=0
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

    if (u ~ /^TEXTDISP_UPDATECHANNELRANGEFLAGS:/ || u ~ /^TEXTDISP_UPDATECHANNELRANGEFLAG[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TEXTDISPCHANNELSOURCEMODE/) has_source_mode=1
    if (n ~ /TEXTDISPPRIMARYCHANNELCODE/) has_primary_channel=1
    if (n ~ /TEXTDISPSECONDARYCHANNELCODE/) has_secondary_channel=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/) has_range_48=1
    if (u ~ /#67([^0-9]|$)/ || u ~ /#\$43/) has_range_67=1
    if (u ~ /#72([^0-9]|$)/ || u ~ /#\$48/) has_range_72=1
    if (u ~ /#77([^0-9]|$)/ || u ~ /#\$4D/) has_range_77=1
    if (n ~ /CLOCKCURRENTDAYOFWEEKINDEX/) has_weekday=1
    if (n ~ /GLOBALSTRTEXTDISPC3/) has_table=1
    if (n ~ /TEXTDISPFINDENTRYMATCHINDEX/) has_find_match=1
    if (n ~ /TEXTDISPBANNERCHARFALLBACK/) has_fallback_char=1
    if (n ~ /TEXTDISPBANNERCHARSELECTED/) has_selected_char=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SOURCE_MODE="has_source_mode
    print "HAS_PRIMARY_CHANNEL="has_primary_channel
    print "HAS_SECONDARY_CHANNEL="has_secondary_channel
    print "HAS_RANGE_48="has_range_48
    print "HAS_RANGE_67="has_range_67
    print "HAS_RANGE_72="has_range_72
    print "HAS_RANGE_77="has_range_77
    print "HAS_WEEKDAY="has_weekday
    print "HAS_TABLE="has_table
    print "HAS_FIND_MATCH="has_find_match
    print "HAS_FALLBACK_CHAR_WRITE="has_fallback_char
    print "HAS_SELECTED_CHAR_WRITE="has_selected_char
    print "HAS_RTS="has_rts
}
