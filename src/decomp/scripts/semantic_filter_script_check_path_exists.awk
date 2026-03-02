BEGIN {
    has_lock = 0
    has_unlock = 0
    has_mode_neg2 = 0
    has_ret0 = 0
    has_ret1 = 0
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

    if (n ~ /LVOLOCK/) has_lock = 1
    if (n ~ /LVOUNLOCK/) has_unlock = 1
    if (u ~ /-2/) has_mode_neg2 = 1
    if (u ~ /[^0-9]0[^0-9]/ || u ~ /^0$/) has_ret0 = 1
    if (u ~ /[^0-9]1[^0-9]/ || u ~ /^1$/) has_ret1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_LOCK=" has_lock
    print "HAS_UNLOCK=" has_unlock
    print "HAS_MODE_NEG2=" has_mode_neg2
    print "HAS_RET0=" has_ret0
    print "HAS_RET1=" has_ret1
    print "HAS_TERMINAL=" has_terminal
}
