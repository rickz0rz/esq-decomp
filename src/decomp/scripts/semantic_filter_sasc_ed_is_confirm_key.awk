BEGIN {
    has_key_load = 0
    has_sub_59 = 0
    has_sub_20 = 0
    has_branch = 0
    has_zero = 0
    has_one = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /ED_LASTKEYCODE/) has_key_load = 1
    if (l ~ /SUBI\.W #\$?59,D[067]/ || l ~ /MOVEQ(\.L)? #\$?59,D[0-7]/ || l ~ /SUB\.L D[0-7],D[067]/) has_sub_59 = 1
    if (l ~ /SUBI\.W #\$?20,D[067]/ || l ~ /MOVEQ(\.L)? #\$?20,D[0-7]/ || l ~ /SUB\.L D[0-7],D[067]/) has_sub_20 = 1
    if (l ~ /BEQ|BNE/) has_branch = 1
    if (l ~ /^MOVEQ(\.L)? #\$?0,D[067]$/ || l ~ /^CLR\.L D[067]$/) has_zero = 1
    if (l ~ /^MOVEQ(\.L)? #\$?1,D[067]$/) has_one = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_KEY_LOAD=" has_key_load
    print "HAS_SUB_59=" has_sub_59
    print "HAS_SUB_20=" has_sub_20
    print "HAS_BRANCH=" has_branch
    print "HAS_ZERO=" has_zero
    print "HAS_ONE=" has_one
    print "HAS_RTS=" has_rts
}
