BEGIN {
    has_reset = 0
    has_mode1 = 0
    has_ctx_head_store = 0
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

    if (n ~ /SCRIPTRESETCTRLCONTEXT/) has_reset = 1
    if (u ~ /[^0-9]1[^0-9]/ || u ~ /^1$/) has_mode1 = 1
    if (u ~ /2\(A[0-7]\)/ || u ~ /\(2,A[0-7]\)/ || u ~ /2\(%A[0-7]\)/) has_ctx_head_store = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_RESET=" has_reset
    print "HAS_MODE1=" has_mode1
    print "HAS_CTX_HEAD_STORE=" has_ctx_head_store
    print "HAS_TERMINAL=" has_terminal
}
