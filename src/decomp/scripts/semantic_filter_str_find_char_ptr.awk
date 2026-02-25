BEGIN {
    arg_pushes = 0
    has_call = 0
    has_stack_cleanup = 0
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

    if (u ~ /^MOVE\.L .+,-\((A7|SP)\)$/ || u ~ /^MOVE\.W .+,-\((A7|SP)\)$/) arg_pushes++
    if (u ~ /(BSR|JSR|JBSR).*STR_FINDCHAR/ || u ~ /^JSR \(A[0-7]\)$/) has_call = 1
    if (u ~ /^ADDQ\.(W|L) #8,(A7|SP)$/ || u ~ /^LEA \(8,(A7|SP)\),(A7|SP)$/) has_stack_cleanup = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_TWO_ARG_PUSHES=" (arg_pushes >= 2 ? 1 : 0)
    print "HAS_CALL=" has_call
    print "HAS_STACK_CLEANUP=" has_stack_cleanup
    print "HAS_RTS=" has_rts
}
