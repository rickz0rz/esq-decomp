BEGIN {
    has_textdisp = 0
    has_reset = 0
    has_ctx = 0
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

    if (n ~ /TEXTDISPHANDLESCRIPTCOMMAND/) has_textdisp = 1
    if (n ~ /SCRIPTRESETCTRLCONTEXT/) has_reset = 1
    if (n ~ /SCRIPTCTRLCONTEXT/) has_ctx = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_TEXTDISP=" has_textdisp
    print "HAS_RESET=" has_reset
    print "HAS_CTX=" has_ctx
    print "HAS_TERMINAL=" has_terminal
}
