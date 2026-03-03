BEGIN {
    label = 0
    has_loop = 0
    has_next_offset = 0
    has_find_sep_call = 0
    has_copy_flow = 0
    has_return = 0
}

/^BRUSH_NormalizeBrushNames:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /BRA\.S .*LOOP|BNE\.S .*COPY|JNE .*L[0-9]/) has_loop = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_next_offset = 1
    if (line ~ /GCOMMAND_FINDPATHSEPARATOR/) has_find_sep_call = 1
    if (line ~ /MOVE\.B .*A0|MOVE\.B .*A1|MOVE\.B .*A2|\(A0\)\+|\(A1\)\+|\(A2\)\+/) has_copy_flow = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_loop) print "HAS_LOOP_FLOW"
    if (has_next_offset) print "HAS_NEXT_OFFSET_368"
    if (has_find_sep_call) print "HAS_FIND_SEPARATOR_CALL"
    if (has_copy_flow) print "HAS_COPY_FLOW"
    if (has_return) print "HAS_RTS"
}
