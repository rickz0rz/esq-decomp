BEGIN {
    has_zero_arg = 0
    has_3f_arg = 0
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

    if (uline ~ /#0,D0/ || uline ~ /CLR\.B D0/ || uline ~ /MOVEQ #0,D0/ || uline ~ /CLR\.L -\(SP\)/) has_zero_arg = 1
    if (uline ~ /#\$?3F,D1/ || uline ~ /#63,D1/ || uline ~ /^PEA 63\.W$/) has_3f_arg = 1
    if (uline ~ /ESQ_SETCOPPEREFFECTPARAMS/) has_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ZERO_ARG=" has_zero_arg
    print "HAS_3F_ARG=" has_3f_arg
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}
