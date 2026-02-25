BEGIN {
    has_mask7 = 0
    has_add_ascii0 = 0
    has_shift3 = 0
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

    if (u ~ /^ANDI?\.(W|L|B) #7,D[0-7]$/ || u ~ /^AND\.(L|W|B) #7,D[0-7]$/) has_mask7 = 1
    if (u ~ /^ADDI?\.(W|L) #\$30,D[0-7]$/ || u ~ /^ADD\.B #48,D[0-7]$/ || u ~ /^ADDQ\.B #48,D[0-7]$/) has_add_ascii0 = 1
    if (u ~ /^LSR\.L #3,D[0-7]$/ || u ~ /^LSR\.W #3,D[0-7]$/) has_shift3 = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/) has_temp_store = 1
    if (u ~ /^MOVE\.B -\(A[0-7]\),\(A[0-7]\)\+$/ || u ~ /^MOVE\.B -\(A[0-7]\),D[0-7]$/) has_reverse_emit = 1
    if (u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) has_nul_term = 1
    if (u ~ /^SUB\.L A[0-7],D[0-7]$/ || u ~ /^SUB\.L \(A7\),D[0-7]$/ || u ~ /^MOVE\.L A[0-7],D0$/) has_len_calc = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MASK7=" has_mask7
    print "HAS_ADD_ASCII0=" has_add_ascii0
    print "HAS_SHIFT3=" has_shift3
    print "HAS_TEMP_STORE=" has_temp_store
    print "HAS_REVERSE_EMIT=" has_reverse_emit
    print "HAS_NUL_TERM=" has_nul_term
    print "HAS_LEN_CALC=" has_len_calc
    print "HAS_RTS=" has_rts
}
