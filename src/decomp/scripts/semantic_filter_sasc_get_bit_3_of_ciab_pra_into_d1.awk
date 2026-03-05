BEGIN {
    has_entry = 0
    has_ciab_const = 0
    has_bit3_test = 0
    has_boolize = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /CIAB_PRA/ || l ~ /#\$?BFE001/ || l ~ /#0X00BFE001/ || l ~ /#12574721/) has_ciab_const = 1
    if ((l ~ /BTST/ && (l ~ /#3/ || l ~ /#\$?3/)) || (l ~ /AND/ && (l ~ /#8/ || l ~ /#\$?8/)) || (l ~ /^LSR\./ && (l ~ /#3/ || l ~ /#\$?3/))) has_bit3_test = 1
    if (l ~ /^SEQ / || l ~ /^SNE / || l ~ /NEG\.L/ || l ~ /EXT\.L/ || l ~ /MOVEQ #-1/ || l ~ /MOVEQ\.L #\$?FF,D0/ || l ~ /#\$?FFFF/) has_boolize = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CIAB_CONST=" has_ciab_const
    print "HAS_BIT3_TEST=" has_bit3_test
    print "HAS_BOOLIZE=" has_boolize
    print "HAS_RETURN=" has_return
}
