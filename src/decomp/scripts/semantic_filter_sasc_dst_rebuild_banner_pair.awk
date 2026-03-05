BEGIN {
    free_calls = 0
    alloc_calls = 0
    slot0 = 0
    slot1 = 0
    ok_set = 0
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

    if (u ~ /DST_FREEBANNERPAIR/) free_calls++
    if (u ~ /DST_ALLOCATEBANNERSTRUCT/) alloc_calls++
    if (u ~ /\(A[0-7]\)|\(0,A[0-7]\)/) slot0 = 1
    if (u ~ /4\(A[0-7]\)|\(4,A[0-7]\)|\(A[0-7]\)\+/) slot1 = 1
    if (u ~ /^MOVEQ #1,D[0-7]$/ || u ~ /^MOVEQ\.L #\$1,D[0-7]$/ || u ~ /^MOVE\.L #1,D[0-7]$/ || u ~ /^SNE D[0-7]$/ || u ~ /^SEQ D[0-7]$/) ok_set = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_TWO_FREE_CALLS=" (free_calls >= 2 ? 1 : 0)
    print "HAS_TWO_ALLOC_CALLS=" (alloc_calls >= 2 ? 1 : 0)
    print "HAS_SLOT0_ACCESS=" slot0
    print "HAS_SLOT1_ACCESS=" slot1
    print "HAS_OK_SET=" ok_set
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
