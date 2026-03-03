BEGIN {
    label = 0
    has_compare_call = 0
    has_next_368 = 0
    has_zero_match_check = 0
    has_null_return = 0
    has_return = 0
}

/^BRUSH_FindBrushByPredicate:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /GROUP_AA_JMPTBL_STRING_COMPARENOCASE|_GROUP_AA_JMPTBL_STRING_COMPARENOCASE/) has_compare_call = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_next_368 = 1
    if (line ~ /TST\.L[[:space:]]+D0/ || line ~ /CMPI\.L[[:space:]]+#0,D0/ || line ~ /JEQ|BEQ/) has_zero_match_check = 1
    if (line ~ /MOVEQ[[:space:]]+#0,D0/ || line ~ /CLR\.L[[:space:]]+D0/ || line ~ /SUBA\.L[[:space:]]+A0,A0/ || line ~ /SUB\.L[[:space:]]+A0,A0/) has_null_return = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_compare_call) print "HAS_COMPARE_CALL"
    if (has_next_368) print "HAS_NEXT_OFFSET_368"
    if (has_zero_match_check) print "HAS_ZERO_MATCH_CHECK"
    if (has_null_return) print "HAS_NULL_RETURN"
    if (has_return) print "HAS_RTS"
}
