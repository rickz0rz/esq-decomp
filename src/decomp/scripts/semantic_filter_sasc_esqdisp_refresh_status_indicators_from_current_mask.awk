BEGIN {
    has_entry = 0
    has_minus_one = 0
    has_apply = 0
    has_stack_fix = 0
    has_return = 0
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
    if (l ~ /PEA -1\.W/ || l ~ /PEA \(\$FFFFFFFF\)\.W/ || l ~ /MOVEQ\.L #\$?FF,D0/ || l ~ /MOVE\.L #\$?FFFFFFFF/) has_minus_one = 1
    if (l ~ /APPLYSTATUSMASKTOINDICATORS/ || l ~ /APPLYSTATUSMASKTOIND/ || l ~ /APPLYSTATUSMASKTOINDICAT/) has_apply = 1
    if (l ~ /ADDQ\.W #4,A7/ || l ~ /ADDQ\.W #\$4,A7/ || l ~ /LEA \$4\(A7\),A7/) has_stack_fix = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MINUS_ONE=" has_minus_one
    print "HAS_APPLY=" has_apply
    print "HAS_STACK_FIX=" has_stack_fix
    print "HAS_RETURN=" has_return
}
