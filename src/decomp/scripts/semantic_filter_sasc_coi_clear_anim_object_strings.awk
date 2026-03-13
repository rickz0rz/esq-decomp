BEGIN {
    has_label = 0
    has_guard = 0
    has_zero_head = 0
    has_replace_call = 0
    has_write_tail = 0
}

function trim(s, t){
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

    if (u ~ /^COI_CLEARANIMOBJECTSTRINGS[A-Z0-9_]*:/) has_label = 1

    if (u ~ /COI_CLEARANIMOBJECTSTRINGS_RETURN/ || u ~ /BEQ\.[BWS]? .*COI_CLEARANIMOBJECTSTRINGS/ || u ~ /BEQ\.[BWS]? .*__/) has_guard = 1

    if (u ~ /MOVE.B D0,\(A[0-7]\)/ || u ~ /CLR\.L \(A[0-7]\)/) has_zero_head = 1

    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ || u ~ /ESQPARS_REPLACEOWNEDSTRING/) has_replace_call = 1

    if (u ~ /CLR\.L (32|\$20)\(A[0-7]\)/ || u ~ /LEA \$20\(A[0-7]\),A0/ || u ~ /CLR\.L \(A0\)/) has_write_tail = 1

}

END {
    print "HAS_LABEL=" has_label
    print "HAS_GUARD=" has_guard
    print "HAS_ZERO_HEAD=" has_zero_head
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_WRITE_TAIL=" has_write_tail
}
