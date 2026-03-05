BEGIN {
    has_entry = 0
    has_rts = 0
    has_zero_arg = 0
    has_3f_arg = 0
    has_call = 0
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
    if (l == "RTS") has_rts = 1

    if (l ~ /#\$?3F/ || l ~ /\(\$3F\)/ || l ~ /#63/) has_3f_arg = 1
    if (l ~ /#\$?0( |,|$)/ || l ~ /^CLR\.[BWL] /) has_zero_arg = 1
    if (index(l, "ESQ_SETCOPPEREFFECTPARAMS") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_call = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_ZERO_ARG=" has_zero_arg
    print "HAS_3F_ARG=" has_3f_arg
    print "HAS_CALL=" has_call
}
