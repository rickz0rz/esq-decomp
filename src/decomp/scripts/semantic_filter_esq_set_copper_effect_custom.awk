BEGIN {
    has_ciab = 0
    has_set_bits67 = 0
    has_3f_arg = 0
    has_custom_arg = 0
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
    if (uline ~ /BSET #6/ || uline ~ /BSET #7/ || uline ~ /OR\.B #\$?C0/ || uline ~ /OR\.W #\$?C0/ || uline ~ /OR\.B #-64/) has_set_bits67 = 1
    if (uline ~ /#\$?3F,D0/ || uline ~ /#63,D0/ || uline ~ /^PEA 63\.W$/) has_3f_arg = 1
    if (uline ~ /HIGHLIGHT_CUSTOMVALUE/) has_custom_arg = 1
    if (uline ~ /ESQ_SETCOPPEREFFECTPARAMS/) has_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_CIAB_ACCESS=" has_ciab
    print "HAS_SET_BITS67=" has_set_bits67
    print "HAS_3F_ARG=" has_3f_arg
    print "HAS_CUSTOM_ARG=" has_custom_arg
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}
