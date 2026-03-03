BEGIN {
    label = 0
    has_loop = 0
    has_link_offset = 0
    has_dealloc_call = 0
    has_size_238 = 0
    has_head_clear = 0
    has_return = 0
}

/^BRUSH_FreeBrushResources:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /BNE|JNE|BRA|JRA/) has_loop = 1
    if (line ~ /234\(/ || line ~ /\(234,/ || line ~ /#\$EA/ || line ~ /#234/) has_link_offset = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/) has_dealloc_call = 1
    if (line ~ /238\.W|#238|#\$EE/) has_size_238 = 1
    if (line ~ /CLR\.L .*A3|\(A3\)|MOVE\.L #0/) has_head_clear = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_loop) print "HAS_LOOP_FLOW"
    if (has_link_offset) print "HAS_LINK_OFFSET_234"
    if (has_dealloc_call) print "HAS_DEALLOC_CALL"
    if (has_size_238) print "HAS_SIZE_238"
    if (has_head_clear) print "HAS_HEAD_CLEAR"
    if (has_return) print "HAS_RTS"
}
