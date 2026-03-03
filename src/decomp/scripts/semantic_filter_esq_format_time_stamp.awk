BEGIN {
    has_backwrite = 0
    has_ampm = 0
    has_hour = 0
    has_minute = 0
    has_second = 0
    has_div10 = 0
    has_colon = 0
    has_space_or_zero = 0
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

    if (u ~ /-\(A0\)/ || u ~ /#11,A0/ || u ~ /#\$?B,A0/ || u ~ /\(11,A[0-7]\)/ || u ~ /\(10,A[0-7]\)/) has_backwrite = 1
    if (u ~ /#\'A\'/ || u ~ /#\'P\'/ || u ~ /#65,D[0-7]/ || u ~ /#80,D[0-7]/) has_ampm = 1
    if (u ~ /8\(A1\)/ || u ~ /\(8,A1\)/ || u ~ /8\(A3\)/ || u ~ /\(8,A3\)/) has_hour = 1
    if (u ~ /10\(A1\)/ || u ~ /\(10,A1\)/ || u ~ /10\(A3\)/ || u ~ /\(10,A3\)/) has_minute = 1
    if (u ~ /12\(A1\)/ || u ~ /\(12,A1\)/ || u ~ /12\(A3\)/ || u ~ /\(12,A3\)/) has_second = 1
    if (u ~ /DIVS #10,D[0-7]/ || u ~ /DIVS\.W #10,D[0-7]/ || u ~ /#10,D[0-7]/ || u ~ /__DIVSI3/ || u ~ /__MODSI3/) has_div10 = 1
    if (u ~ /#\':\'/ || u ~ /#58,D[0-7]/ || u ~ /#58,\(/) has_colon = 1
    if (u ~ /#\' \'/ || u ~ /#32,D[0-7]/ || u ~ /#\'0\'/ || u ~ /#48,D[0-7]/) has_space_or_zero = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_BACKWRITE=" has_backwrite
    print "HAS_AMPM=" has_ampm
    print "HAS_HOUR=" has_hour
    print "HAS_MINUTE=" has_minute
    print "HAS_SECOND=" has_second
    print "HAS_DIV10=" has_div10
    print "HAS_COLON=" has_colon
    print "HAS_SPACE_OR_ZERO=" has_space_or_zero
    print "HAS_RTS=" has_rts
}
