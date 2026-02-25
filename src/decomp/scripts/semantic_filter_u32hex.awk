BEGIN {
    has_mask15 = 0
    has_moveq_15 = 0
    has_table_lookup = 0
    has_shift4 = 0
    has_temp_store = 0
    has_reverse_emit = 0
    has_nul_term = 0
    has_len_calc = 0
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

    if (u ~ /^ANDI?\.(W|L|B) #15,D[0-7]$/ || u ~ /^AND\.(W|L|B) #15,D[0-7]$/ || u ~ /^ANDI?\.(W|L|B) #\$F,D[0-7]$/) has_mask15 = 1
    if (u ~ /^MOVEQ #15,D[0-7]$/) has_moveq_15 = 1
    if (u ~ /^AND\.(W|L|B) D[0-7],D[0-7]$/ && has_moveq_15) has_mask15 = 1
    if (u ~ /KHEXDIGITTABLE/ || u ~ /^MOVE\.B .*\(PC,D[0-7]\.(W|L)\),/) has_table_lookup = 1
    if (u ~ /^LSR\.(W|L) #4,D[0-7]$/) has_shift4 = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B .*?,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B .*?,\(A[0-7]\)$/) has_temp_store = 1
    if (u ~ /^MOVE\.B -\(A[0-7]\),\(A[0-7]\)\+$/ || u ~ /^MOVE\.B -\(A[0-7]\),D[0-7]$/) has_reverse_emit = 1
    if (u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) has_nul_term = 1
    if (u ~ /^SUB\.L A[0-7],D[0-7]$/ || u ~ /^SUB\.L \(A7\),D[0-7]$/ || u ~ /^MOVE\.L A[0-7],D0$/) has_len_calc = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MASK15=" has_mask15
    print "HAS_TABLE_LOOKUP=" has_table_lookup
    print "HAS_SHIFT4=" has_shift4
    print "HAS_TEMP_STORE=" has_temp_store
    print "HAS_REVERSE_EMIT=" has_reverse_emit
    print "HAS_NUL_TERM=" has_nul_term
    print "HAS_LEN_CALC=" has_len_calc
    print "HAS_RTS=" has_rts
}
