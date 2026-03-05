BEGIN {
    has_entry = 0
    has_clear_alias = 0
    has_parse_ini = 0
    has_qtable_path = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /ESQPARS_CLEARALIASSTRINGPOINTERS/ || line ~ /ESQPARS_CLEARALI/) has_clear_alias = 1
    if (line ~ /PARSEINI_PARSEINIBUFFERANDDISPATCH/ || line ~ /PARSEINI_PARSEINIBUFFERANDDISP/ || line ~ /PARSEINI_PARSEIN/) has_parse_ini = 1
    if (line ~ /CTASKS_PATH_QTABLE_INI/) has_qtable_path = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLEAR_ALIAS=" has_clear_alias
    print "HAS_PARSE_INI=" has_parse_ini
    print "HAS_QTABLE_PATH=" has_qtable_path
}
