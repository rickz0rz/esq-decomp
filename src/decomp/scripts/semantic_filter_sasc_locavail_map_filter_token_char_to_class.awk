BEGIN {
    has_entry = 0
    has_charclass_lookup = 0
    has_digit_test = 0
    has_digit_sub = 0
    has_alpha_test = 0
    has_upper_fold = 0
    has_alpha_sub = 0
    has_unknown_zero = 0
    has_return = 0
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

    if (u ~ /^LOCAVAIL_MAPFILTERTOKENCHARTOCLASS:/ || u ~ /^LOCAVAIL_MAPFILTERTOKENCHARTOCLA[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "WDISP_CHARCLASSTABLE") > 0) has_charclass_lookup = 1
    if (u ~ /^BTST #\$2,\(A[0-7]\)$/ || u ~ /^BTST #2,\(A[0-7]\)$/ || u ~ /^BTST #\$2,D[0-7]$/ || u ~ /^BTST #2,D[0-7]$/) has_digit_test = 1
    if (u ~ /^SUB\.[LW] D[0-7],D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$30,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #48,D[0-7]$/) has_digit_sub = 1
    if (u ~ /^ANDI?\.B .*#\$3/ || u ~ /^ANDI?\.B .*#3/ || u ~ /^AND\.B \(A[0-7]\),D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$3,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #3,D[0-7]$/) has_alpha_test = 1
    if (u ~ /^BTST #\$1,\(A[0-7]\)$/ || u ~ /^BTST #1,\(A[0-7]\)$/ || u ~ /^BTST #\$1,D[0-7]$/ || u ~ /^BTST #1,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #32,D[0-7]$/) has_upper_fold = 1
    if (u ~ /^MOVEQ(\.L)? #\$37,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #55,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$57,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #87,D[0-7]$/) has_alpha_sub = 1
    if (u ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #0,D[0-7]$/ || u ~ /^CLR\.[BWL] D[0-7]$/) has_unknown_zero = 1
    if (u ~ /^BRA\.[SWB] LOCAVAIL_MAPFILTERTOKENCHARTOCLASS_RETURN$/ || u ~ /^JMP LOCAVAIL_MAPFILTERTOKENCHARTOCLASS_RETURN$/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CHARCLASS_LOOKUP=" has_charclass_lookup
    print "HAS_DIGIT_TEST=" has_digit_test
    print "HAS_DIGIT_SUB=" has_digit_sub
    print "HAS_ALPHA_TEST=" has_alpha_test
    print "HAS_UPPER_FOLD=" has_upper_fold
    print "HAS_ALPHA_SUB=" has_alpha_sub
    print "HAS_UNKNOWN_ZERO=" has_unknown_zero
    print "HAS_RETURN=" has_return
}
