BEGIN {
    label = 0
    has_null_guard = 0
    has_offset_368 = 0
    has_free_call = 0
    has_one_literal = 0
    has_return = 0
}

/^BRUSH_PopBrushHead:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /TST\.L|CMP\.L|CMPI\.L|JEQ|BEQ|JNE|BNE/) has_null_guard = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_offset_368 = 1
    if (line ~ /BRUSH_FREEBRUSHLIST/) has_free_call = 1
    if (line ~ /PEA[[:space:]]+1\.W/ || line ~ /MOVEQ[[:space:]]+#1,D0/ || line ~ /MOVE\.L[[:space:]]+#1,D0/) has_one_literal = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_null_guard) print "HAS_NULL_GUARD"
    if (has_offset_368) print "HAS_NEXT_OFFSET_368"
    if (has_free_call) print "HAS_FREE_CALL"
    if (has_one_literal) print "HAS_ONE_LITERAL"
    if (has_return) print "HAS_RTS"
}
