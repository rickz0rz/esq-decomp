BEGIN {
    has_entry = 0
    has_alloc_call = 0
    has_alloc_size = 0
    has_last_alloc_store = 0
    has_name_copy_loop = 0
    has_next_offset = 0
    has_tail_link = 0
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

    if (u ~ /MEMORY_ALLOCATEMEMORY/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_alloc_call = 1
    if (u ~ /#238/ || u ~ /238\.W/ || u ~ /#\$EE/ || u ~ /PEA \(\$EE\)\.W/) has_alloc_size = 1
    if (u ~ /BRUSH_LASTALLOCATEDNODE/) has_last_alloc_store = 1
    if (u ~ /\(A0\)\+,\(A1\)\+/ || u ~ /\(A1\)\+,\(A0\)\+/ || u ~ /^MOVE\.B \(A0\),\(A1\)\+$/ || u ~ /^MOVE\.B \(A0\)\+,D0$/ || u ~ /BNE\.[BWL]? .*COPY/ || u ~ /BNE .*COPY/) has_name_copy_loop = 1
    if (u ~ /234\(/ || u ~ /\(234,/ || u ~ /#\$EA/ || u ~ /#234/ || u ~ /\$EA\([AD][0-7]\)/) has_next_offset = 1
    if ((u ~ /234\([AD][0-7]\)/ && u ~ /MOVE\.L [AD][0-7],/) || (u ~ /\$EA\([AD][0-7]\)/ && u ~ /MOVE\.L [AD][0-7],/) || u ~ /^LEA \$EA\(A3\),A0$/ || u ~ /PREV_TAIL/ || u ~ /LINK_PREVIOUS_TAIL/) has_tail_link = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_SIZE_238=" has_alloc_size
    print "HAS_LAST_ALLOC_STORE=" has_last_alloc_store
    print "HAS_NAME_COPY_LOOP=" has_name_copy_loop
    print "HAS_NEXT_OFFSET_234=" has_next_offset
    print "HAS_PREV_TAIL_LINK_PATH=" has_tail_link
    print "HAS_RTS=" has_rts
}
