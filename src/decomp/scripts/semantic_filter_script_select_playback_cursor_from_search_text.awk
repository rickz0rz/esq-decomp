BEGIN {
    has_select_call = 0
    has_primary_first = 0
    has_search_match = 0
    has_range_armed = 0
    has_cursor = 0
    has_primary_text = 0
    has_secondary_text = 0
    has_ch_primary = 0
    has_ch_secondary = 0
    has_split_18 = 0
    has_cursor6 = 0
    has_cursor7 = 0
    has_cursor1 = 0
    has_terminal = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /TEXTDISPSELECTGROUPANDENTRY/) has_select_call = 1
    if (n ~ /SCRIPTPRIMARYSEARCHFIRSTFLAG/) has_primary_first = 1
    if (n ~ /SCRIPTSEARCHMATCHCOUNTORINDEX/) has_search_match = 1
    if (n ~ /SCRIPTCHANNELRANGEARMEDFLAG/) has_range_armed = 1
    if (n ~ /SCRIPTPLAYBACKCURSOR/) has_cursor = 1
    if (n ~ /TEXTDISPPRIMARYSEARCHTEXT/) has_primary_text = 1
    if (n ~ /TEXTDISPSECONDARYSEARCHTEXT/) has_secondary_text = 1
    if (n ~ /TEXTDISPPRIMARYCHANNELCODE/) has_ch_primary = 1
    if (n ~ /TEXTDISPSECONDARYCHANNELCODE/) has_ch_secondary = 1
    if (u ~ /#18/ || u ~ /[^0-9]18[^0-9]/) has_split_18 = 1
    if (u ~ /#6/ || u ~ /[^0-9]6[^0-9]/) has_cursor6 = 1
    if (u ~ /#7/ || u ~ /[^0-9]7[^0-9]/) has_cursor7 = 1
    if (u ~ /#1/ || u ~ /[^0-9]1[^0-9]/) has_cursor1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_SELECT_CALL=" has_select_call
    print "HAS_PRIMARY_FIRST=" has_primary_first
    print "HAS_SEARCH_MATCH=" has_search_match
    print "HAS_RANGE_ARMED=" has_range_armed
    print "HAS_CURSOR=" has_cursor
    print "HAS_PRIMARY_TEXT=" has_primary_text
    print "HAS_SECONDARY_TEXT=" has_secondary_text
    print "HAS_CH_PRIMARY=" has_ch_primary
    print "HAS_CH_SECONDARY=" has_ch_secondary
    print "HAS_SPLIT_18=" has_split_18
    print "HAS_CURSOR6=" has_cursor6
    print "HAS_CURSOR7=" has_cursor7
    print "HAS_CURSOR1=" has_cursor1
    print "HAS_TERMINAL=" has_terminal
}
