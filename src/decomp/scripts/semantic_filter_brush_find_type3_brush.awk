BEGIN {
    label = 0
    has_type3_check = 0
    has_next_368 = 0
    has_null_path = 0
    has_return = 0
}

/^BRUSH_FindType3Brush:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /CMP\.B[[:space:]]+32\(A[0-7]\),D[0-7]/ || line ~ /CMPI\.B[[:space:]]+#?3,32\(A[0-7]\)/ || line ~ /#3/) has_type3_check = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_next_368 = 1
    if (line ~ /MOVEQ[[:space:]]+#0,D0/ || line ~ /CLR\.L[[:space:]]+D0/ || line ~ /SUBA\.L[[:space:]]+A0,A0/ || line ~ /SUB\.L[[:space:]]+A0,A0/) has_null_path = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_type3_check) print "HAS_TYPE3_CHECK"
    if (has_next_368) print "HAS_NEXT_OFFSET_368"
    if (has_null_path) print "HAS_NULL_PATH"
    if (has_return) print "HAS_RTS"
}
