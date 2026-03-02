BEGIN {
    has_12 = 0
    has_zero = 0
    has_neg1 = 0
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

    if (u ~ /[^0-9]12[^0-9]/ || u ~ /^12$/) has_12 = 1
    if (u ~ /[^0-9]0[^0-9]/ || u ~ /^0$/) has_zero = 1
    if (u ~ /-1/) has_neg1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_12=" has_12
    print "HAS_ZERO=" has_zero
    print "HAS_NEG1=" has_neg1
    print "HAS_TERMINAL=" has_terminal
}
