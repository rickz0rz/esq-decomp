BEGIN {
    has_wait_test = 0
    has_wait_branch = 0
    has_entrycount = 0
    has_mask = 0
    has_call = 0
    has_arg1 = 0
    has_stack_pop = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /^TST\.W CTASKS_IFFTASKDONEFLAG(\(A[0-7]\))?$/ || l ~ /^MOVE\.W CTASKS_IFFTASKDONEFLAG\(A4\),D0$/) has_wait_test = 1
    if (l ~ /^BEQ(\.[A-Z]+)? /) has_wait_branch = 1

    if (l ~ /^MOVE\.W #\$?2E,LADFUNC_ENTRYCOUNT(\(A[0-7]\))?$/) has_entrycount = 1

    if (l ~ /^ANDI\.[WL] #\$?FFFE,D0$/ || l ~ /^AND\.[WL] #\$?FFFE,D0$/ || l ~ /^AND\.[WL] #\$?FFFE,ESQIFF_EXTERNALASSETFLAGS(\(A[0-7]\))?$/) {
        has_mask = 1
    }

    if (l ~ /(JSR|BSR).*ESQIFF_RELOADEXTERNALASSETCATALO/) has_call = 1

    if (l ~ /^PEA 1\.W$/ || l ~ /^PEA \(\$1\)\.W$/ || l ~ /^MOVEQ(\.L)? #\$?1,D[0-7]$/ || l ~ /^MOVE\.L #\$?1,-\(A7\)$/) has_arg1 = 1

    if (l ~ /^ADDQ\.W #\$?4,A7$/ || l ~ /^LEA 4\(A7\),A7$/) has_stack_pop = 1

    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_WAIT_TEST=" has_wait_test
    print "HAS_WAIT_BRANCH=" has_wait_branch
    print "HAS_ENTRYCOUNT=" has_entrycount
    print "HAS_MASK=" has_mask
    print "HAS_CALL=" has_call
    print "HAS_ARG1=" has_arg1
    print "HAS_STACK_POP=" has_stack_pop
    print "HAS_RTS=" has_rts
}
