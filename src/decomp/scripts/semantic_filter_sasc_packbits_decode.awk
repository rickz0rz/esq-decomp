BEGIN {
    has_entry = 0
    has_rts = 0
    has_literal_inc = 0
    has_repeat_neg = 0
    has_ff_skip = 0
    has_return_src = 0
    has_call = 0
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l == "RTS") has_rts = 1

    if (l ~ /^ADDQ\.B #\$?1,D[0-7]$/) has_literal_inc = 1
    if (l ~ /^NEG\.[BWL] D[0-7]$/) has_repeat_neg = 1
    if (l ~ /#\$FF/ && l ~ /^CMP\.[BWL] /) has_ff_skip = 1
    if (l ~ /^MOVE\.L A[0-7],D0$/) has_return_src = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_LITERAL_INC=" has_literal_inc
    print "HAS_REPEAT_NEG=" has_repeat_neg
    print "HAS_FF_SKIP=" has_ff_skip
    print "HAS_RETURN_SRC=" has_return_src
    print "HAS_CALL=" has_call
}
