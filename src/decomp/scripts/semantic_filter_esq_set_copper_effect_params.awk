BEGIN {
    has_param_a_store = 0
    has_param_b_store = 0
    has_seed5 = 0
    has_update_call = 0
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

    if (uline ~ /HIGHLIGHT_COPPEREFFECTPARAMA/) has_param_a_store = 1
    if (uline ~ /HIGHLIGHT_COPPEREFFECTPARAMB/) has_param_b_store = 1
    if (uline ~ /#5/ || uline ~ /HIGHLIGHT_COPPEREFFECTSEED/) has_seed5 = 1
    if (uline ~ /ESQ_UPDATECOPPERLISTSFROMPARAMS/) has_update_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_PARAM_A_STORE=" has_param_a_store
    print "HAS_PARAM_B_STORE=" has_param_b_store
    print "HAS_SEED5=" has_seed5
    print "HAS_UPDATE_CALL=" has_update_call
    print "HAS_RTS=" has_rts
}

