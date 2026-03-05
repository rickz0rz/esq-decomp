BEGIN {
    has_entry = 0
    has_rts = 0
    has_ciab_ref = 0
    has_clear6 = 0
    has_set7 = 0
    has_store = 0
    has_zero_arg = 0
    has_set_call = 0
    has_disable_call = 0
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

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_ALT != "" && l == toupper(ENTRY_ALT) ":") has_entry = 1
    if (l == "RTS") has_rts = 1

    if (index(l, "CIAB_PRA") > 0 || index(l, "BFE001") > 0) has_ciab_ref = 1
    if (l ~ /^BCLR #6,D[0-7]$/ || l ~ /^ANDI\.[BWL] #\$?BF,D[0-7]$/ || l ~ /#191/ || l ~ /#\$?40/ || l ~ /#64/) has_clear6 = 1
    if (l ~ /^BSET #7,D[0-7]$/ || l ~ /^ORI\.[BWL] #\$?80,D[0-7]$/ || l ~ /#128/) has_set7 = 1
    if (l ~ /^MOVE\.[BWL] D[0-7],\(A[0-7]\)$/ || l ~ /^MOVE\.[BWL] D[0-7],CIAB_PRA$/) has_store = 1
    if (l ~ /#\$?0( |,|$)/ || l ~ /^CLR\.[BWL] /) has_zero_arg = 1
    if (index(l, "ESQ_SETCOPPEREFFECTPARAMS") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_set_call = 1
    if (index(l, "GCOMMAND_DISABLEHIGHLIGHT") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_disable_call = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_CIAB_REF=" has_ciab_ref
    print "HAS_CLEAR6=" has_clear6
    print "HAS_SET7=" has_set7
    print "HAS_STORE=" has_store
    print "HAS_ZERO_ARG=" has_zero_arg
    print "HAS_SET_CALL=" has_set_call
    print "HAS_DISABLE_CALL=" has_disable_call
}
