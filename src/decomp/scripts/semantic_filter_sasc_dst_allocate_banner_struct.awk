BEGIN {
    free_call = 0
    alloc_calls = 0
    c798 = 0
    c803 = 0
    c807 = 0
    c18 = 0
    c22 = 0
    cflags = 0
    slot0 = 0
    slot1 = 0
    clear16 = 0
    has_rts_or_jmp = 0
    saw_slot1_ptr = 0
    saw_state16_ptr = 0
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

    if (u ~ /DST_FREEBANNERSTRUCT/) free_call = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY|GROUP_AG_JMPTBL_MEMORY_ALLOCAT/) alloc_calls++
    if (u ~ /#\$31E|#798|798\.W|\(\$31E\)\.W/) c798 = 1
    if (u ~ /#\$323|#803|803\.W|\(\$323\)\.W/) c803 = 1
    if (u ~ /#\$327|#807|807\.W|\(\$327\)\.W/) c807 = 1
    if (u ~ /#\$12|#18|18\.W|\(\$12\)\.W|PEA 18\.W/) c18 = 1
    if (u ~ /#\$16|#22|22\.W|\(\$16\)\.W|PEA 22\.W/) c22 = 1
    if (u ~ /#\$10001|#65537|65537\.W|65537\.L|MEMF_PUBLIC|MEMF_CLEAR/) cflags = 1
    if (u ~ /^MOVE\.L [D][0-7],\(A[0-7]\)$/) slot0 = 1
    if (u ~ /^MOVE\.L [D][0-7],[$]4\(A[0-7]\)$/ || u ~ /^MOVE\.L [D][0-7],4\(A[0-7]\)$/ || u ~ /^MOVE\.L [D][0-7],\(4,A[0-7]\)$/) slot1 = 1
    if (u ~ /^CLR\.W [$]10\(A[0-7]\)$/ || u ~ /^CLR\.W 16\(A[0-7]\)$/ || u ~ /^CLR\.W \(16,A[0-7]\)$/ || u ~ /^MOVE\.W #0,[$]10\(A[0-7]\)$/ || u ~ /^MOVE\.W #0,16\(A[0-7]\)$/ || u ~ /^MOVE\.W #0,\(16,A[0-7]\)$/) clear16 = 1
    if (u ~ /^LEA \$4\(A3\),A0$/ || u ~ /^LEA 4\(A3\),A0$/) saw_slot1_ptr = 1
    if (u ~ /^LEA \$10\(A3\),A0$/ || u ~ /^LEA 16\(A3\),A0$/) saw_state16_ptr = 1
    if (saw_slot1_ptr && u ~ /^MOVE\.L [D][0-7],\(A0\)$/) slot1 = 1
    if (saw_state16_ptr && (u ~ /^CLR\.W \(A0\)$/ || u ~ /^MOVE\.W [D#][^,]*,\(A0\)$/)) clear16 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_FREE_CALL=" free_call
    print "HAS_THREE_ALLOC_CALLS=" (alloc_calls >= 3 ? 1 : 0)
    print "HAS_LINE_798=" c798
    print "HAS_LINE_803=" c803
    print "HAS_LINE_807=" c807
    print "HAS_SIZE_18=" c18
    print "HAS_SIZE_22=" c22
    print "HAS_FLAGS_10001=" cflags
    print "HAS_SLOT0_STORE=" slot0
    print "HAS_SLOT1_STORE=" slot1
    print "HAS_STATE_WORD_CLEAR=" clear16
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
