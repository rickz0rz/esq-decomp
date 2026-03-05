BEGIN {
    has_entry = 0
    has_rts = 0
    has_mul5 = 0
    has_copy_loop = 0
    has_wrap20 = 0
    has_store_index = 0
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

    if (l ~ /^MULS #\$?5,D[0-7]$/ || (l ~ /^ASL\.[LW] #\$?2,D[0-7]$/) || l ~ /^ADD\.L D[0-7],D[0-7]$/) has_mul5 = 1
    if (l ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || l ~ /^MOVE\.B \(A[0-7]\),\(A[0-7]\)\+$/) has_copy_loop = 1
    if (l ~ /#\$?14/ || l ~ /#20/) has_wrap20 = 1
    if (index(l, "ED_STATERINGWRITEINDEX") > 0 && l ~ /^MOVE\.[LW] D[0-7],/) has_store_index = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_MUL5=" has_mul5
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_WRAP20=" has_wrap20
    print "HAS_STORE_INDEX=" has_store_index
    print "HAS_CALL=" has_call
}
