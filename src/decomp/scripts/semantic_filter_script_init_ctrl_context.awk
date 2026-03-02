BEGIN {
    has_ctx = 0
    has_set_mode = 0
    has_mode1 = 0
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

    if (n ~ /SCRIPTCTRLCONTEXT/) has_ctx = 1
    if (n ~ /SCRIPTSETCTRLCONTEXTMODE/) has_set_mode = 1
    if (u ~ /[^0-9]1[^0-9]/ || u ~ /^1$/) has_mode1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_CTX=" has_ctx
    print "HAS_SET_MODE=" has_set_mode
    print "HAS_MODE1=" has_mode1
    print "HAS_TERMINAL=" has_terminal
}
