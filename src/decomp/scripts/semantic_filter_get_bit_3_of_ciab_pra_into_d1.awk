BEGIN {
    has_ciab_const = 0
    has_bit3_test = 0
    has_boolize = 0
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
    uline = toupper(line)

    if (uline ~ /CIAB_PRA/ || uline ~ /#\$?BFE001/ || uline ~ /#0X00BFE001/ || uline ~ /#12574721/) has_ciab_const = 1
    if ((uline ~ /BTST/ && uline ~ /#3/) || (uline ~ /AND/ && uline ~ /#8/) || (uline ~ /^LSR\./ && uline ~ /#3/)) has_bit3_test = 1
    if (uline ~ /^SEQ / || uline ~ /^SNE / || uline ~ /NEG\.L/ || uline ~ /EXT\.L/ || uline ~ /MOVEQ #-1/) has_boolize = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_CIAB_CONST=" has_ciab_const
    print "HAS_BIT3_TEST=" has_bit3_test
    print "HAS_BOOLIZE=" has_boolize
    print "HAS_RTS=" has_rts
}
