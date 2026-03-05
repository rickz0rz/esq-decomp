BEGIN {
    has_entry = 0
    has_table_lea = 0
    has_btst_digit = 0
    has_digit_sub48 = 0
    has_btst_alpha = 0
    has_btst_case = 0
    has_case_sub32 = 0
    has_alpha_sub55 = 0
    has_zero_return = 0
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

    if (u ~ /^LADFUNC_PARSEHEXDIGIT:/ || u ~ /^LADFUNC_PARSEHEXDIGIT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "WDISP_CHARCLASSTABLE") > 0 || u ~ /^LEA .*CHARCLASSTABLE/) has_table_lea = 1

    if (u ~ /^BTST #2,/ || u ~ /^BTST #\$2,/) has_btst_digit = 1
    if (u ~ /^MOVEQ(\.L)? #48,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$30,D[0-7]$/ || u ~ /^SUB\.L D[0-7],D0$/) has_digit_sub48 = 1

    if (u ~ /^BTST #7,/ || u ~ /^BTST #\$7,/) has_btst_alpha = 1
    if (u ~ /^BTST #1,/ || u ~ /^BTST #\$1,/) has_btst_case = 1
    if (u ~ /^MOVEQ(\.L)? #32,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/) has_case_sub32 = 1
    if (u ~ /^MOVEQ(\.L)? #55,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$37,D[0-7]$/) has_alpha_sub55 = 1

    if (u ~ /^MOVEQ(\.L)? #0,D0$/ || u ~ /^MOVEQ(\.L)? #\$0,D0$/) has_zero_return = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TABLE_LEA=" has_table_lea
    print "HAS_BTST_DIGIT=" has_btst_digit
    print "HAS_DIGIT_SUB48=" has_digit_sub48
    print "HAS_BTST_ALPHA=" has_btst_alpha
    print "HAS_BTST_CASE=" has_btst_case
    print "HAS_CASE_SUB32=" has_case_sub32
    print "HAS_ALPHA_SUB55=" has_alpha_sub55
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RETURN=" has_return
}
