BEGIN {
    call_count = 0
    slot0 = 0
    slot1 = 0
    clear0 = 0
    clear1 = 0
    has_rts_or_jmp = 0
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

    if (u ~ /DST_FREEBANNERSTRUCT|BSR\.W DST_FREEBANNERSTRUCT/) call_count++
    if (u ~ /\(A[0-7]\)|\(\$?0,A[0-7]\)/) slot0 = 1
    if (u ~ /\$?4\(A[0-7]\)|\(\$?4,A[0-7]\)|\(A[0-7]\)\+/) slot1 = 1
    if (u ~ /^CLR\.L \(A[0-7]\)$/ || u ~ /^MOVE\.L #0,\(A[0-7]\)$/) clear0 = 1
    if (u ~ /^CLR\.L \$?4\(A[0-7]\)$/ || u ~ /^MOVE\.L #0,\$?4\(A[0-7]\)$/ || u ~ /^CLR\.L \(A[0-7]\)\+$/ || u ~ /^CLR\.L \(A0\)$/) clear1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_TWO_FREE_CALLS=" (call_count >= 2 ? 1 : 0)
    print "HAS_SLOT0_ACCESS=" slot0
    print "HAS_SLOT1_ACCESS=" slot1
    print "HAS_SLOT0_CLEAR=" clear0
    print "HAS_SLOT1_CLEAR=" clear1
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
