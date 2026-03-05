BEGIN {
    has_entry = 0
    has_replace = 0
    has_reset_lines = 0
    has_stack_fix = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /DISPLIB_RESETTEXTBUFFERANDLINETA/) has_entry = 1

    if (l ~ /ESQPARS_REPLACEOWNEDSTRING/ || l ~ /ESQPARS_REPLACEO/) has_replace = 1
    if (l ~ /DISPLIB_RESETLINETABLES/) has_reset_lines = 1
    if (l ~ /ADDQ\.W #\$?8,A7/ || l ~ /LEA \$8\(A7\),A7/) has_stack_fix = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REPLACE=" has_replace
    print "HAS_RESET_LINES=" has_reset_lines
    print "HAS_STACK_FIX=" has_stack_fix
}
