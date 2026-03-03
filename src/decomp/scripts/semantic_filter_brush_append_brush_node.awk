BEGIN {
    label = 0
    has_null_guard = 0
    has_offset_368 = 0
    has_cond_branch = 0
    has_return = 0
}

/^BRUSH_AppendBrushNode:$/ { label = 1 }

{
    line = toupper($0)
    if (line ~ /(TST\.L|CMP\.L|CMPI\.L).*A3|A2|D0|D1/) has_null_guard = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_offset_368 = 1
    if (line ~ /(^|[[:space:]])B(EQ|NE|RA|HI|LS|GE|GT|LE|LT)([[:space:]]|$)/) has_cond_branch = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_null_guard) print "HAS_NULL_GUARD"
    if (has_offset_368) print "HAS_NEXT_OFFSET_368"
    if (has_cond_branch) print "HAS_BRANCH_FLOW"
    if (has_return) print "HAS_RTS"
}
