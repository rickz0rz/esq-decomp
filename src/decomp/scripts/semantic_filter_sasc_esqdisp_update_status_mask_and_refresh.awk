BEGIN {
    has_entry = 0
    has_save = 0
    has_load_old = 0
    has_or_or_andn = 0
    has_clamp = 0
    has_cmp_old = 0
    has_apply = 0
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

    if (l ~ /^MOVEM\.L D5-D7,-\(A7\)$/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /STATUSINDICATORMASK/ && l ~ /MOVE\.L/) has_load_old = 1
    if (l ~ /^OR\.L / || l ~ /^NOT\.L D0$/ || l ~ /^AND\.L D0,/) has_or_or_andn = 1
    if (l ~ /ANDI\.L #\$?FFF,ESQDISP_STATUSINDICATORMASK/ || l ~ /ANDI\.L #\$?FFF,/) has_clamp = 1
    if (l ~ /^CMP\.L D0,D5$/ || l ~ /^CMP\.L .*D5/) has_cmp_old = 1
    if (l ~ /APPLYSTATUSMASKTOINDICATORS/ || l ~ /APPLYSTATUSMASKTOIND/) has_apply = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_LOAD_OLD=" has_load_old
    print "HAS_OR_OR_ANDN=" has_or_or_andn
    print "HAS_CLAMP=" has_clamp
    print "HAS_CMP_OLD=" has_cmp_old
    print "HAS_APPLY=" has_apply
    print "HAS_RETURN=" has_return
}
