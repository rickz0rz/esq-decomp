BEGIN {
    has_copy_loop = 0
    has_1900 = 0
    has_12 = 0
    has_off18 = 0
    has_off20 = 0
    has_off8 = 0
    has_off6 = 0
    has_off4 = 0
    has_neg1 = 0
    has_leap = 0
    has_dayofyear = 0
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

    if (u ~ /DBF|BNE|BRA/ || u ~ /FOR|WHILE/) has_copy_loop = 1
    if (u ~ /1900/) has_1900 = 1
    if (u ~ /[^0-9]12[^0-9]/ || u ~ /^12$/) has_12 = 1
    if (u ~ /[^0-9]18[^0-9]/ || u ~ /^18$/) has_off18 = 1
    if (u ~ /[^0-9]20[^0-9]/ || u ~ /^20$/) has_off20 = 1
    if (u ~ /[^0-9]8[^0-9]/ || u ~ /^8$/) has_off8 = 1
    if (u ~ /[^0-9]6[^0-9]/ || u ~ /^6$/) has_off6 = 1
    if (u ~ /[^0-9]4[^0-9]/ || u ~ /^4$/) has_off4 = 1
    if (u ~ /-1/) has_neg1 = 1
    if (n ~ /PARSEINI2JMPTBLDATETIMEISLEAPYEAR/) has_leap = 1
    if (n ~ /PARSEINI2JMPTBLESQCALCDAYOFYEARFROMMONTHDAY/) has_dayofyear = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_1900=" has_1900
    print "HAS_12=" has_12
    print "HAS_OFF18=" has_off18
    print "HAS_OFF20=" has_off20
    print "HAS_OFF8=" has_off8
    print "HAS_OFF6=" has_off6
    print "HAS_OFF4=" has_off4
    print "HAS_NEG1=" has_neg1
    print "HAS_LEAP=" has_leap
    print "HAS_DAYOFYEAR=" has_dayofyear
    print "HAS_TERMINAL=" has_terminal
}
