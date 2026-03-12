BEGIN {
    has_entry = 0
    has_filter = 0
    has_primary_text = 0
    has_secondary_text = 0
    has_delim18 = 0
    has_128 = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_SPLITANDNORMALIZESEARCHBUFFER:/ || u ~ /^SCRIPT_SPLITANDNORMALIZESEARCH[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SCRIPT3JMPTBLESQSHAREDAPPLYPROGRAMTITLETEXTFILTERS/ || n ~ /SCRIPT3JMPTBLESQSHAREDAPPLYPROGRAMTI/ || n ~ /SCRIPT3JMPTBLESQSHAREDAPPLYPR/ || n ~ /ESQSHAREDAPPLYPROGRAMTITLETEXTFILTERS/ || n ~ /ESQSHAREDAPPLYPROGRAMTITLE/ || n ~ /ESQSHAREDAPPLYPROGRAM/) has_filter = 1
    if (n ~ /TEXTDISPPRIMARYSEARCHTEXT/) has_primary_text = 1
    if (n ~ /TEXTDISPSECONDARYSEARCHTEXT/) has_secondary_text = 1
    if (u ~ /#18/ || u ~ /#\$12/ || u ~ /[^0-9]18[^0-9]/) has_delim18 = 1
    if (u ~ /#128/ || u ~ /[^0-9]128[^0-9]/ || u ~ /\$80/) has_128 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FILTER=" has_filter
    print "HAS_PRIMARY_TEXT=" has_primary_text
    print "HAS_SECONDARY_TEXT=" has_secondary_text
    print "HAS_DELIM18=" has_delim18
    print "HAS_128=" has_128
    print "HAS_RETURN=" has_return
}
