BEGIN {
    has_hour = 0
    has_minute = 0
    has_ampm = 0
    has_add12 = 0
    has_midnight_norm = 0
    has_double = 0
    has_half_add = 0
    has_lookup = 0
    has_rts = 0
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

    if (u ~ /8\(A0\)/ || u ~ /\(8,A0\)/ || u ~ /#8,/) has_hour = 1
    if (u ~ /10\(A0\)/ || u ~ /\(10,A0\)/ || u ~ /#10,/) has_minute = 1
    if (u ~ /18\(A0\)/ || u ~ /\(18,A0\)/ || u ~ /#18,/) has_ampm = 1

    if (u ~ /#12,D[0-7]/ || u ~ /#12,/) has_add12 = 1
    if (u ~ /#24,D[0-7]/ || u ~ /#24,/ || u ~ /#0,D[0-7]/) has_midnight_norm = 1
    if (u ~ /^ADD\.[BWL] D[0-7],D[0-7]$/ || u ~ /^LSL\.[BWL] #1,D[0-7]$/) has_double = 1
    if (u ~ /#30,D[0-7]/ || u ~ /ADDQ\.[BWL] #1,D[0-7]/) has_half_add = 1
    if (u ~ /CLOCK_HALFHOURSLOTLOOKUP/) has_lookup = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_HOUR=" has_hour
    print "HAS_MINUTE=" has_minute
    print "HAS_AMPM=" has_ampm
    print "HAS_ADD12=" has_add12
    print "HAS_MIDNIGHT_NORM=" has_midnight_norm
    print "HAS_DOUBLE=" has_double
    print "HAS_HALF_ADD=" has_half_add
    print "HAS_LOOKUP=" has_lookup
    print "HAS_RTS=" has_rts
}
