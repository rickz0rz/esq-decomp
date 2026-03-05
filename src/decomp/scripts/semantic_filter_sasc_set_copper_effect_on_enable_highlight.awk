BEGIN {
    has_entry = 0
    has_rts = 0
    has_ciab_ref = 0
    has_set67 = 0
    has_store = 0
    has_3f_arg = 0
    has_zero_arg = 0
    has_set_call = 0
    has_enable_call = 0
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
    if (ENTRY_REGEX != "" && l ~ toupper(ENTRY_REGEX)) has_entry = 1
    if (l == "RTS") has_rts = 1

    if (index(l, "CIAB_PRA") > 0 || index(l, "BFE001") > 0) has_ciab_ref = 1
    if ((l ~ /^BSET #6,D[0-7]$/ || l ~ /^BSET #7,D[0-7]$/) || l ~ /^ORI\.[BWL] #\$?C0,D[0-7]$/ || l ~ /^OR\.[BWL] #\$?C0,D[0-7]$/ || l ~ /#192/) has_set67 = 1
    if (l ~ /^MOVE\.[BWL] D[0-7],\(A[0-7]\)$/ || l ~ /^MOVE\.[BWL] D[0-7],CIAB_PRA$/) has_store = 1
    if (l ~ /#\$?3F/ || l ~ /\(\$3F\)/ || l ~ /#63/) has_3f_arg = 1
    if (l ~ /#\$?0( |,|$)/ || l ~ /^CLR\.[BWL] /) has_zero_arg = 1
    if (index(l, "ESQ_SETCOPPEREFFECTPARAMS") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_set_call = 1
    if (index(l, "GCOMMAND_ENABLEHIGHLIGHT") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_enable_call = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_CIAB_REF=" has_ciab_ref
    print "HAS_SET67=" has_set67
    print "HAS_STORE=" has_store
    print "HAS_3F_ARG=" has_3f_arg
    print "HAS_ZERO_ARG=" has_zero_arg
    print "HAS_SET_CALL=" has_set_call
    print "HAS_ENABLE_CALL=" has_enable_call
}
