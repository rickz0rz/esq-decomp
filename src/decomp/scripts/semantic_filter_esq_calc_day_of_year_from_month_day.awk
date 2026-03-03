BEGIN {
    has_month = 0
    has_day = 0
    has_store_dayofyear = 0
    has_month_lengths = 0
    has_leap_check = 0
    has_leap_offset = 0
    has_loop = 0
    has_add = 0
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

    if (u ~ /2\(A0\)/ || u ~ /\(2,A0\)/ || u ~ /2\(A2\)/ || u ~ /\(2,A2\)/) has_month = 1
    if (u ~ /4\(A0\)/ || u ~ /\(4,A0\)/ || u ~ /4\(A2\)/ || u ~ /\(4,A2\)/) has_day = 1
    if (u ~ /16\(A0\)/ || u ~ /\(16,A0\)/ || u ~ /16\(A2\)/ || u ~ /\(16,A2\)/) has_store_dayofyear = 1

    if (u ~ /CLOCK_MONTHLENGTHS/) has_month_lengths = 1
    if (u ~ /20\(A0\)/ || u ~ /\(20,A0\)/ || u ~ /20\(A2\)/ || u ~ /\(20,A2\)/) has_leap_check = 1
    if (u ~ /#\$?18,A[0-7]/ || u ~ /#24,A[0-7]/ || u ~ /#\$?18,D[0-7]/ || u ~ /#24,D[0-7]/ || u ~ /24\+_CLOCK_MONTHLENGTHS/) has_leap_offset = 1

    if (u ~ /^DBF / || u ~ /^DBRA / || u ~ /^J(B?NE|EQ|LT|LE|GT|GE) / || u ~ /^B(NE|EQ|LT|LE|GT|GE|PL|MI)/) has_loop = 1
    if (u ~ /^ADD\.[BWL] / || u ~ /^ADDQ\.[BWL] / || u ~ /^ADDI\.[BWL] /) has_add = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MONTH=" has_month
    print "HAS_DAY=" has_day
    print "HAS_STORE_DAYOFYEAR=" has_store_dayofyear
    print "HAS_MONTH_LENGTHS=" has_month_lengths
    print "HAS_LEAP_CHECK=" has_leap_check
    print "HAS_LEAP_OFFSET=" has_leap_offset
    print "HAS_LOOP=" has_loop
    print "HAS_ADD=" has_add
    print "HAS_RTS=" has_rts
}
