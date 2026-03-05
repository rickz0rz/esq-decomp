BEGIN {
    null_guard = 0
    ptr0 = 0
    ptr4 = 0
    free_calls = 0
    c22 = 0
    c18 = 0
    tags = 0
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

    if (u ~ /^MOVE\.L A[0-7],D[0-7]$/ || u ~ /^TST\.L D[0-7]$/ || u ~ /^TST\.L A[0-7]$/) null_guard = 1
    if (u ~ /\(A[0-7]\)|\(0,A[0-7]\)/) ptr0 = 1
    if (u ~ /4\(A[0-7]\)|\(4,A[0-7]\)/) ptr4 = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) free_calls++
    if (u ~ /#22|#\$16|22\.W|\(\$16\)\.W|PEA 22\.W/) c22 = 1
    if (u ~ /#18|#\$12|18\.W|\(\$12\)\.W|PEA 18\.W/) c18 = 1
    if (u ~ /GLOBAL_STR_DST_C_1|GLOBAL_STR_DST_C_2|GLOBAL_STR_DST_C_3|GLOBAL_STR_DST_C_/) tags = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_NULL_GUARD=" null_guard
    print "HAS_SLOT0_CHECK=" ptr0
    print "HAS_SLOT1_CHECK=" ptr4
    print "HAS_DEALLOC_CALLS=" (free_calls >= 2 ? 1 : 0)
    print "HAS_SIZE_22=" c22
    print "HAS_SIZE_18=" c18
    print "HAS_DST_TAG_STRINGS=" tags
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
