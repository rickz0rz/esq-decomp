BEGIN {
    has_entry = 0
    has_type3_check = 0
    has_next_368 = 0
    has_null_path = 0
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

    if (u ~ /CMP\.B[[:space:]]+32\(A[0-7]\),D[0-7]/ || u ~ /CMPI\.B[[:space:]]+#?3,32\(A[0-7]\)/ || u ~ /CMPI\.B[[:space:]]+#\$3,32\(A[0-7]\)/ || u ~ /MOVEQ(\.L)? #3,D0/ || u ~ /MOVEQ(\.L)? #\$3,D0/) has_type3_check = 1
    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) has_next_368 = 1
    if (u ~ /MOVEQ[[:space:]]+#0,D0/ || u ~ /MOVEQ(\.L)? #\$0,D0/ || u ~ /CLR\.L[[:space:]]+D0/ || u ~ /SUBA\.L[[:space:]]+A0,A0/ || u ~ /SUB\.L[[:space:]]+A0,A0/) has_null_path = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_TYPE3_CHECK=" has_type3_check
    print "HAS_NEXT_OFFSET_368=" has_next_368
    print "HAS_NULL_PATH=" has_null_path
    print "HAS_RTS=" has_rts
}
