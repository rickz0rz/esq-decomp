BEGIN {
    has_label = 0
    has_save_current = 0
    has_count_guard = 0
    has_tables = 0
    has_flag_test = 0
    has_wildcard = 0
    has_store_match = 0
    has_true_return = 0
    has_false_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_FINDENTRYINDEXBYWILDCARD:/ || u ~ /^TEXTDISP_FINDENTRYINDEXBYWILDCAR[A-Z0-9_]*:/) has_label = 1
    if (n ~ /TEXTDISPCURRENTMATCHINDEXTEXTDISPCURRENTMATCHINDEXSAVED/ || n ~ /TEXTDISPCURRENTMATCHINDEXSAVED/ && n ~ /TEXTDISPCURRENTMATCHINDEX/) has_save_current = 1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /CMPWD0D7/ || n ~ /CMPLD0D7/) has_count_guard = 1
    if (n ~ /TEXTDISPPRIMARYTITLEPTRTABLE/ || n ~ /TEXTDISPPRIMARYENTRYPTRTABLE/) has_tables = 1
    if (n ~ /BTST327A2/ || n ~ /BTST327A5/ || n ~ /BTST31BA3/ || n ~ /ANDIB8D0/ || n ~ /ANDIB8D1/) has_flag_test = 1
    if (n ~ /UNKNOWNJMPTBLESQWILDCARDMATCH/) has_wildcard = 1
    if (n ~ /TEXTDISPCURRENTMATCHINDEX/ && n ~ /MOVEW/ && n ~ /D7/ || n ~ /TEXTDISPCURRENTMATCHINDEXA4/ && n ~ /MOVEW/) has_store_match = 1
    if (n ~ /MOVEQ10/ || n ~ /MOVEQL10/ || n ~ /MOVEQ1D0/ || n ~ /MOVEQL1D0/) has_true_return = 1
    if (n ~ /MOVEQ00/ || n ~ /MOVEQL00/ || n ~ /MOVEQ0D0/ || n ~ /MOVEQL0D0/) has_false_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE_CURRENT=" has_save_current
    print "HAS_COUNT_GUARD=" has_count_guard
    print "HAS_TABLES=" has_tables
    print "HAS_FLAG_TEST=" has_flag_test
    print "HAS_WILDCARD=" has_wildcard
    print "HAS_STORE_MATCH=" has_store_match
    print "HAS_TRUE_RETURN=" has_true_return
    print "HAS_FALSE_RETURN=" has_false_return
}
