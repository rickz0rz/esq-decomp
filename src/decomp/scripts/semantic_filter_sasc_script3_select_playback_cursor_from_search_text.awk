BEGIN {
    has_entry = 0
    has_match_index = 0
    has_range_armed = 0
    has_select_call = 0
    has_cursor_set = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^SCRIPT_SELECTPLAYBACKCURSORFROMSEARCHTEXT:/ || u ~ /^SCRIPT_SELECTPLAYBACKCURSORFROMSEA[A-Z0-9_]*:/ || u ~ /^SCRIPT_SELECTPLAYBACKCURSORFROMS[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "SCRIPT_SEARCHMATCHCOUNTORINDEX") > 0) has_match_index = 1
    if (index(u, "SCRIPT_CHANNELRANGEARMEDFLAG") > 0) has_range_armed = 1
    if (index(u, "TEXTDISP_SELECTGROUPANDENTRY") > 0 || index(u, "TEXTDISP_SELECTGROUPANDENTR") > 0) has_select_call = 1
    if (index(u, "SCRIPT_PLAYBACKCURSOR") > 0) has_cursor_set = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MATCH_INDEX=" has_match_index
    print "HAS_RANGE_ARMED=" has_range_armed
    print "HAS_SELECT_CALL=" has_select_call
    print "HAS_CURSOR_SET=" has_cursor_set
    print "HAS_RETURN=" has_return
}
