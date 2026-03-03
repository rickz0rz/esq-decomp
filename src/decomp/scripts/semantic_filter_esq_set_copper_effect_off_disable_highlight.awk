BEGIN {
    has_ciab = 0
    has_bit6_clear = 0
    has_bit7_set = 0
    has_zero_a = 0
    has_zero_b = 0
    has_seteffect_call = 0
    has_disable_call = 0
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

    if (uline ~ /CIAB_PRA/ || uline ~ /#\$?BFE001/ || uline ~ /#12574721/) has_ciab = 1
    if (uline ~ /BCLR #6/ || uline ~ /AND\.B #\$?BF/ || uline ~ /AND\.B #-65/) has_bit6_clear = 1
    if (uline ~ /BSET #7/ || uline ~ /OR\.B #\$?80/ || uline ~ /OR\.B #-128/) has_bit7_set = 1
    if (uline ~ /#0,D0/ || uline ~ /CLR\.B D0/ || uline ~ /MOVEQ #0,D0/ || uline ~ /CLR\.L -\(SP\)/) has_zero_a = 1
    if (uline ~ /#0,D1/ || uline ~ /CLR\.B D1/ || uline ~ /MOVEQ #0,D1/ || uline ~ /CLR\.L -\(SP\)/) has_zero_b = 1
    if (uline ~ /ESQ_SETCOPPEREFFECTPARAMS/) has_seteffect_call = 1
    if (uline ~ /GCOMMAND_DISABLEHIGHLIGHT/) has_disable_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_CIAB_ACCESS=" has_ciab
    print "HAS_BIT6_CLEAR=" has_bit6_clear
    print "HAS_BIT7_SET=" has_bit7_set
    print "HAS_ZERO_ARG_A=" has_zero_a
    print "HAS_ZERO_ARG_B=" has_zero_b
    print "HAS_SET_EFFECT_CALL=" has_seteffect_call
    print "HAS_DISABLE_CALL=" has_disable_call
    print "HAS_RTS=" has_rts
}

