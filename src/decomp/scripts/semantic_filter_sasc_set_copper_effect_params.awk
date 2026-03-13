BEGIN {
    has_entry = 0
    has_rts = 0
    has_store_a = 0
    has_store_b = 0
    has_seed5 = 0
    has_update_call = 0
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && (l == toupper(ENTRY) ":" || l == "@" toupper(ENTRY) ":")) has_entry = 1
    if (l == "RTS") has_rts = 1

    if (index(l, "HIGHLIGHT_COPPEREFFECTPARAMA") > 0) has_store_a = 1
    if (index(l, "HIGHLIGHT_COPPEREFFECTPARAMB") > 0) has_store_b = 1
    if (index(l, "HIGHLIGHT_COPPEREFFECTSEED") > 0 && (l ~ /#\$?5/ || l ~ /#5/)) has_seed5 = 1
    if (index(l, "ESQ_UPDATECOPPERLISTSFROMPARAMS") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_update_call = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_STORE_A=" has_store_a
    print "HAS_STORE_B=" has_store_b
    print "HAS_SEED5=" has_seed5
    print "HAS_UPDATE_CALL=" has_update_call
}
