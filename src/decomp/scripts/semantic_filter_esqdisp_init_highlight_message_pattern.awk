BEGIN {
    has_entry = 0
    has_push = 0
    has_load_arg = 0
    has_loop_cmp = 0
    has_loop_store = 0
    has_loop_inc = 0
    has_loop_branch = 0
    has_return_label = 0
    has_pop = 0
    has_rts = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_INITHIGHLIGHTMESSAGEPATTERN:/) has_entry = 1
    if (uline ~ /MOVEM\.L D7\/A3,-\(A7\)/) has_push = 1
    if (uline ~ /MOVEA\.L 12\(A7\),A3/) has_load_arg = 1
    if (uline ~ /CMP\.L D0,D7/ && uline ~ /BGE(\.[A-Z]+)? ESQDISP_INITHIGHLIGHTMESSAGEPATTERN_RETURN/) has_loop_cmp = 1
    if (uline ~ /MOVE\.B D0,55\(A3,D7\.L\)/) has_loop_store = 1
    if (uline ~ /ADDQ\.L #1,D7/) has_loop_inc = 1
    if (uline ~ /BRA(\.[A-Z]+)? \.INIT_PATTERN_LOOP/) has_loop_branch = 1
    if (uline ~ /^ESQDISP_INITHIGHLIGHTMESSAGEPATTERN_RETURN:/) has_return_label = 1
    if (uline ~ /MOVEM\.L \(A7\)\+,D7\/A3/) has_pop = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PUSH=" has_push
    print "HAS_LOAD_ARG=" has_load_arg
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_LOOP_STORE=" has_loop_store
    print "HAS_LOOP_INC=" has_loop_inc
    print "HAS_LOOP_BRANCH=" has_loop_branch
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_POP=" has_pop
    print "HAS_RTS=" has_rts
}
