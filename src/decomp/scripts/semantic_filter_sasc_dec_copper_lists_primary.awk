BEGIN {
    has_entry = 0
    has_list_a = 0
    has_list_b = 0
    has_dec_call = 0
    has_dual_store = 0
    has_primary_store = 0
    has_stride4 = 0
    has_loop8 = 0
    has_loop24 = 0
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

    if (u ~ /ESQ_COPPERSTATUSDIGITSA/) has_list_a = 1
    if (u ~ /ESQ_COPPERSTATUSDIGITSB/) has_list_b = 1
    if (u ~ /ESQ_DECCOLORSTEP/) has_dec_call = 1
    if ((u ~ /MOVE\.W D0,0\(A2,D5\.W\)/ || u ~ /MOVE\.W D0,0\(A3,D5\.W\)/ || u ~ /MOVE\.W D0,\(A[23]\)/ || u ~ /MOVE\.W D0,\$0\(A[35],D[0-7]\.W\)/ || u ~ /MOVE\.W D[0-7],\$0\(A3,D[0-7]\.W\)/) && u !~ /MOVE\.W D[0-7],D[0-7]/) has_dual_store = 1
    if ((u ~ /MOVE\.W D0,0\(A2,D5\.W\)/ || u ~ /MOVE\.W D0,\(A2\)/ || u ~ /MOVE\.W D0,\$0\(A[25],D[0-7]\.W\)/ || u ~ /MOVE\.W D[0-7],\$0\(A5,D[0-7]\.W\)/) && u !~ /MOVE\.W D[0-7],D[0-7]/) has_primary_store = 1
    if (u ~ /#4/ || u ~ /ADDQ\.[BWL] #\$?4,/ || u ~ /ADDI\.[BWL] #\$?4,/) has_stride4 = 1
    if (u ~ /#7/ || u ~ /#8/ || u ~ /#\$?7/) has_loop8 = 1
    if (u ~ /#23/ || u ~ /#24/ || u ~ /#\$?17/) has_loop24 = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_LIST_A=" has_list_a
    print "HAS_LIST_B=" has_list_b
    print "HAS_DEC_CALL=" has_dec_call
    print "HAS_DUAL_STORE=" has_dual_store
    print "HAS_PRIMARY_STORE=" has_primary_store
    print "HAS_STRIDE4=" has_stride4
    print "HAS_LOOP8=" has_loop8
    print "HAS_LOOP24=" has_loop24
    print "HAS_RTS=" has_rts
}
