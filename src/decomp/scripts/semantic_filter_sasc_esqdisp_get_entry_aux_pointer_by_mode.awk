BEGIN {
    has_entry = 0
    has_link = 0
    has_mode1 = 0
    has_mode2 = 0
    has_primary_count = 0
    has_secondary_count = 0
    has_primary_table = 0
    has_secondary_table = 0
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

    if (l ~ /LINK\.W A5,#-4/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_link = 1
    if (l ~ /MOVEQ(\.L)? #\$?1,D0/ || l ~ /CMP\.L D0,D6/) has_mode1 = 1
    if (l ~ /MOVEQ(\.L)? #\$?2,D0/ || l ~ /CMP\.L D0,D6/) has_mode2 = 1
    if (l ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/) has_primary_count = 1
    if (l ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/ || l ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN/) has_secondary_count = 1
    if (l ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/) has_primary_table = 1
    if (l ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/) has_secondary_table = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_MODE1=" has_mode1
    print "HAS_MODE2=" has_mode2
    print "HAS_PRIMARY_COUNT=" has_primary_count
    print "HAS_SECONDARY_COUNT=" has_secondary_count
    print "HAS_PRIMARY_TABLE=" has_primary_table
    print "HAS_SECONDARY_TABLE=" has_secondary_table
    print "HAS_RETURN=" has_return
}
