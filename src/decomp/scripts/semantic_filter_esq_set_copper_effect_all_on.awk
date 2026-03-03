BEGIN {
    has_ciab = 0
    has_clear_bits67 = 0
    has_3f_a = 0
    has_3f_b = 0
    has_call = 0
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
    if (uline ~ /BCLR #6/ || uline ~ /BCLR #7/ || uline ~ /AND\.B #63/ || uline ~ /AND\.W #63/) has_clear_bits67 = 1
    if (uline ~ /#\$?3F,D0/ || uline ~ /#63,D0/ || uline ~ /^PEA 63\.W$/) has_3f_a = 1
    if (uline ~ /#\$?3F,D1/ || uline ~ /#63,D1/ || uline ~ /^PEA 63\.W$/) has_3f_b = 1
    if (uline ~ /ESQ_SETCOPPEREFFECTPARAMS/) has_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_CIAB_ACCESS=" has_ciab
    print "HAS_CLEAR_BITS67=" has_clear_bits67
    print "HAS_3F_ARG_A=" has_3f_a
    print "HAS_3F_ARG_B=" has_3f_b
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}

