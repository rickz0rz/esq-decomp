BEGIN {
    has_h_read = 0
    has_t_read = 0
    has_max_ref = 0
    has_wrap_const = 0
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

    if (n ~ /GLOBALWORDHVALUE/) has_h_read = 1
    if (n ~ /GLOBALWORDTVALUE/) has_t_read = 1
    if (n ~ /GLOBALWORDMAXVALUE/) has_max_ref = 1
    if (u ~ /64000/) has_wrap_const = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_H_READ=" has_h_read
    print "HAS_T_READ=" has_t_read
    print "HAS_MAX_REF=" has_max_ref
    print "HAS_WRAP_CONST=" has_wrap_const
    print "HAS_TERMINAL=" has_terminal
}
