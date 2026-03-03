BEGIN {
    has_dayofyear = 0
    has_month_store = 0
    has_day_store = 0
    has_month_lengths = 0
    has_leap_check = 0
    has_leap_offset = 0
    has_compare = 0
    has_sub = 0
    has_increment = 0
    has_loop = 0
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

    if (u ~ /16\(A0\)/ || u ~ /\(16,A0\)/ || u ~ /16\(A2\)/ || u ~ /\(16,A2\)/) has_dayofyear = 1
    if (u ~ /2\(A0\)/ || u ~ /\(2,A0\)/ || u ~ /2\(A2\)/ || u ~ /\(2,A2\)/) has_month_store = 1
    if (u ~ /4\(A0\)/ || u ~ /\(4,A0\)/ || u ~ /4\(A2\)/ || u ~ /\(4,A2\)/) has_day_store = 1

    if (u ~ /CLOCK_MONTHLENGTHS/) has_month_lengths = 1
    if (u ~ /20\(A0\)/ || u ~ /\(20,A0\)/ || u ~ /20\(A2\)/ || u ~ /\(20,A2\)/) has_leap_check = 1
    if (u ~ /#\$?18,A[0-7]/ || u ~ /#24,A[0-7]/ || u ~ /24\+_CLOCK_MONTHLENGTHS/) has_leap_offset = 1

    if (u ~ /^CMP\.[BWL] / || u ~ /^CMPI\.[BWL] /) has_compare = 1
    if (u ~ /^SUB\.[BWL] / || u ~ /^SUBI\.[BWL] / || u ~ /^SUBQ\.[BWL] /) has_sub = 1
    if (u ~ /^ADDQ\.[BWL] #1,D[0-7]/ || u ~ /^ADDQ\.[BWL] #1,A[0-7]/ || u ~ /^ADD\.[BWL] D[0-7],D[0-7]$/) has_increment = 1
    if (u ~ /^BRA(\.S)? / || u ~ /^JRA / || u ~ /^J(B?NE|EQ|LT|LE|GT|GE) / || u ~ /^B(NE|EQ|LT|LE|GT|GE|PL|MI)/) has_loop = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_DAYOFYEAR=" has_dayofyear
    print "HAS_MONTH_STORE=" has_month_store
    print "HAS_DAY_STORE=" has_day_store
    print "HAS_MONTH_LENGTHS=" has_month_lengths
    print "HAS_LEAP_CHECK=" has_leap_check
    print "HAS_LEAP_OFFSET=" has_leap_offset
    print "HAS_COMPARE=" has_compare
    print "HAS_SUB=" has_sub
    print "HAS_INCREMENT=" has_increment
    print "HAS_LOOP=" has_loop
    print "HAS_RTS=" has_rts
}
