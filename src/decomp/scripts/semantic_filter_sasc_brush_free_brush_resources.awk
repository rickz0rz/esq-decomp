BEGIN {
    has_entry = 0
    has_loop = 0
    has_link_offset = 0
    has_dealloc_call = 0
    has_size_238 = 0
    has_head_clear = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /BNE|JNE|BRA|JRA|BEQ|JEQ/) has_loop = 1
    if (u ~ /234\(/ || u ~ /\(234,/ || u ~ /#\$EA/ || u ~ /#234/ || u ~ /\$EA\([AD][0-7]\)/) has_link_offset = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEM/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_DEALLOCATEM/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc_call = 1
    if (u ~ /238\.W|#238|#\$EE|PEA \(\$EE\)\.W/) has_size_238 = 1
    if (u ~ /CLR\.L .*\(A[0-7]\)/ || u ~ /^CLR\.L \(A[0-7]\)$/ || u ~ /MOVE\.L #0/ || u ~ /MOVEQ(\.L)? #\$0,D0/) has_head_clear = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_FLOW=" has_loop
    print "HAS_LINK_OFFSET_234=" has_link_offset
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_SIZE_238=" has_size_238
    print "HAS_HEAD_CLEAR=" has_head_clear
    print "HAS_RTS=" has_rts
}
