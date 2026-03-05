BEGIN {
    has_entry = 0
    has_lock_test = 0
    has_sync_target = 0
    has_len_table = 0
    has_optional_inc = 0
    has_build = 0
    has_clear_current = 0
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
    if (l ~ /DISPTEXT_TARGETLINEINDEX/ && l ~ /DISPTEXT_CURRENTLINEINDEX/) has_sync_target = 1
    if (l ~ /DISPTEXT_LINELENGTHTABLE/) has_len_table = 1
    if (l ~ /ADDQ\.W #\$?1,D0/ || l ~ /ADDQ\.L #\$?1,D[0-7]/) has_optional_inc = 1
    if (l ~ /DISPTEXT_BUILDLINEPOINTERTABLE/ || l ~ /DISPTEXT_BUILDLINEPOINTERTA/) has_build = 1
    if (l ~ /CLR\.W DISPTEXT_CURRENTLINEINDEX/ || l ~ /MOVEQ(\.L)? #\$?0,D0/) has_clear_current = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK_TEST=" has_lock_test
    print "HAS_SYNC_TARGET=" has_sync_target
    print "HAS_LEN_TABLE=" has_len_table
    print "HAS_OPTIONAL_INC=" has_optional_inc
    print "HAS_BUILD=" has_build
    print "HAS_CLEAR_CURRENT=" has_clear_current
    print "HAS_RETURN=" has_return
}
