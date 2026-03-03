BEGIN {
    label = 0
    has_alloc_call = 0
    has_alloc_size = 0
    has_last_alloc_store = 0
    has_name_copy_loop = 0
    has_next_offset = 0
    has_tail_link = 0
    has_return = 0
}

/^BRUSH_AllocBrushNode:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /MEMORY_ALLOCATEMEMORY/) has_alloc_call = 1
    if (line ~ /#238/ || line ~ /238\.W/ || line ~ /#\$EE/) has_alloc_size = 1
    if (line ~ /BRUSH_LASTALLOCATEDNODE/) has_last_alloc_store = 1
    if (line ~ /\(A0\)\+,/ || line ~ /\(A1\)\+/ || line ~ /BNE\.S .*COPY|BNE .*COPY/) has_name_copy_loop = 1
    if (line ~ /234\(/ || line ~ /\(234,/ || line ~ /#\$EA/ || line ~ /#234/) has_next_offset = 1
    if (line ~ /A2/ && line ~ /234/ || line ~ /PREV_TAIL|LINK_PREVIOUS_TAIL/) has_tail_link = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_alloc_call) print "HAS_ALLOC_CALL"
    if (has_alloc_size) print "HAS_ALLOC_SIZE_238"
    if (has_last_alloc_store) print "HAS_LAST_ALLOC_STORE"
    if (has_name_copy_loop) print "HAS_NAME_COPY_LOOP"
    if (has_next_offset) print "HAS_NEXT_OFFSET_234"
    if (has_tail_link) print "HAS_PREV_TAIL_LINK_PATH"
    if (has_return) print "HAS_RTS"
}
