BEGIN {
    has_entry = 0
    has_save = 0
    has_field_cmp = 0
    has_gt3_reject = 0
    has_field1_cmp = 0
    has_len10_cmp = 0
    has_non1_len7_cmp = 0
    has_valid_set = 0
    has_restore = 0
    has_rts = 0
}

function trim(s, t) {
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

    if (u ~ /^ESQIFF2_VALIDATEFIELDINDEXANDLENGTH:/ || u ~ /^ESQIFF2_VALIDATEFIELDINDEXANDL[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEM\.L D6-D7,-\(A7\)$/ || u ~ /^MOVEM\.L D[0-7](\/D[0-7])+,-\(A7\)$/) has_save = 1
    if (u ~ /^CMP\.W D0,D7$/ || u ~ /^CMPI\.W #3,D[0-7]$/ || u ~ /^CMPI\.W #\$3,D[0-7]$/) has_field_cmp = 1
    if (u ~ /^MOVEQ(\.L)? #0,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/ || u ~ /^CLR\.[WL] D0$/) has_gt3_reject = 1
    if (u ~ /^CMPI\.W #1,D[0-7]$/ || u ~ /^CMPI\.W #\$1,D[0-7]$/ || u ~ /^CMP\.W D0,D7$/) has_field1_cmp = 1
    if (u ~ /^MOVEQ(\.L)? #10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$A,D[0-7]$/ || u ~ /^CMPI\.W #10,D[0-7]$/ || u ~ /^CMPI\.W #\$A,D[0-7]$/) has_len10_cmp = 1
    if (u ~ /^MOVEQ(\.L)? #7,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$7,D[0-7]$/ || u ~ /^CMPI\.W #7,D[0-7]$/ || u ~ /^CMPI\.W #\$7,D[0-7]$/) has_non1_len7_cmp = 1
    if (u ~ /^MOVEQ(\.L)? #1,D0$/ || u ~ /^MOVEQ(\.L)? #\$1,D0$/) has_valid_set = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D6-D7$/ || u ~ /^MOVEM\.L \(A7\)\+,D[0-7](\/D[0-7])+$/ || u ~ /^MOVE\.L \(A7\)\+,D7$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_FIELD_CMP=" has_field_cmp
    print "HAS_GT3_REJECT=" has_gt3_reject
    print "HAS_FIELD1_CMP=" has_field1_cmp
    print "HAS_LEN10_CMP=" has_len10_cmp
    print "HAS_NON1_LEN7_CMP=" has_non1_len7_cmp
    print "HAS_VALID_SET=" has_valid_set
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
