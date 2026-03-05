BEGIN {
    has_entry = 0
    has_secondary_search = 0
    has_primary_search = 0
    has_secondary_channel = 0
    has_primary_channel = 0
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

    if (u ~ /^SCRIPT_CLEARSEARCHTEXTSANDCHANNELS:/ || u ~ /^SCRIPT_CLEARSEARCHTEXTSANDCHAN[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_SECONDARYSEARCHTEXT") > 0) has_secondary_search = 1
    if (index(u, "TEXTDISP_PRIMARYSEARCHTEXT") > 0) has_primary_search = 1
    if (index(u, "TEXTDISP_SECONDARYCHANNELCODE") > 0) has_secondary_channel = 1
    if (index(u, "TEXTDISP_PRIMARYCHANNELCODE") > 0) has_primary_channel = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SECONDARY_SEARCH=" has_secondary_search
    print "HAS_PRIMARY_SEARCH=" has_primary_search
    print "HAS_SECONDARY_CHANNEL=" has_secondary_channel
    print "HAS_PRIMARY_CHANNEL=" has_primary_channel
    print "HAS_RETURN=" has_return
}
