BEGIN {
    has_entry = 0
    has_save = 0
    has_call_timeword = 0
    has_double = 0
    has_row_add = 0
    has_call_normalize = 0
    has_norm_args = 0
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
    if (l ~ /DST_BUILDBANNERTIMEWORD/ || l ~ /DST_BUILDBANNERTIMEW/) has_call_timeword = 1
    if (l ~ /ADD\.L D1,D1/ || l ~ /ADD\.L D5,D1/ || l ~ /ASL\.[WL] #1,D[0-7]/) has_double = 1
    if (l ~ /ADD\.L D1,D0/ || l ~ /ADD\.L D0,D[0-7]/) has_row_add = 1
    if (l ~ /DISPLIB_NORMALIZEVALUEBYSTEP/ || l ~ /DISPLIB_NORMALIZEVALUEBY/) has_call_normalize = 1
    if (l ~ /PEA 48\.W/ || l ~ /PEA 1\.W/ || l ~ /PEA \(\$30\)\.W/ || l ~ /PEA \(\$1\)\.W/ || l ~ /MOVE\.L #\$?30,\(A7\)/ || l ~ /MOVE\.L #\$?1,\(A7\)/) has_norm_args = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_CALL_TIMEWORD=" has_call_timeword
    print "HAS_DOUBLE=" has_double
    print "HAS_ROW_ADD=" has_row_add
    print "HAS_CALL_NORMALIZE=" has_call_normalize
    print "HAS_NORM_ARGS=" has_norm_args
    print "HAS_RETURN=" has_return
}
