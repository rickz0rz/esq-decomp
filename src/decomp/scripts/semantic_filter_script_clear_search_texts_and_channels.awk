BEGIN {
    has_primary_text = 0
    has_secondary_text = 0
    has_primary_channel = 0
    has_secondary_channel = 0
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

    if (n ~ /TEXTDISPPRIMARYSEARCHTEXT/) has_primary_text = 1
    if (n ~ /TEXTDISPSECONDARYSEARCHTEXT/) has_secondary_text = 1
    if (n ~ /TEXTDISPPRIMARYCHANNELCODE/) has_primary_channel = 1
    if (n ~ /TEXTDISPSECONDARYCHANNELCODE/) has_secondary_channel = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_PRIMARY_TEXT=" has_primary_text
    print "HAS_SECONDARY_TEXT=" has_secondary_text
    print "HAS_PRIMARY_CHANNEL=" has_primary_channel
    print "HAS_SECONDARY_CHANNEL=" has_secondary_channel
    print "HAS_TERMINAL=" has_terminal
}
