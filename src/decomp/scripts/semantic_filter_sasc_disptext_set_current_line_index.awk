BEGIN {
    has_entry = 0
    has_lock_test = 0
    has_min_check = 0
    has_max_check = 0
    has_commit_call = 0
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
    if (l ~ /DISPTEXT_LINETABLELOCKFLAG/) has_lock_test = 1
    if (l ~ /MOVEQ(\.L)? #\$?1,D0/ || l ~ /CMP\.L D0,D7/ || l ~ /CMP\.L #\$?1,D[0-7]/) has_min_check = 1
    if (l ~ /MOVEQ(\.L)? #\$?3,D0/ || l ~ /CMP\.L #\$?3,D[0-7]/) has_max_check = 1
    if (l ~ /COMMITCURRENTLINEPENANDADVANCE/ || l ~ /COMMITCURRENTLINEPENANDADV/ || l ~ /COMMITCURRENTLINEPENANDA/) has_commit_call = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK_TEST=" has_lock_test
    print "HAS_MIN_CHECK=" has_min_check
    print "HAS_MAX_CHECK=" has_max_check
    print "HAS_COMMIT_CALL=" has_commit_call
    print "HAS_RETURN=" has_return
}
