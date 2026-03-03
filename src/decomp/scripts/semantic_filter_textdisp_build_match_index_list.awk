BEGIN {
    has_label = 0
    has_link = 0
    has_wildcard = 0
    has_find_mode = 0
    has_group_count = 0
    has_editor = 0
    has_record = 0
    has_restore = 0
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
    uline = toupper(line)

    if (uline ~ /^TEXTDISP_BUILDMATCHINDEXLIST:/) has_label = 1
    if (uline ~ /LINK.W A5,#-20/) has_link = 1
    if (uline ~ /WILDCARDMATCH\(PC\)/) has_wildcard = 1
    if (uline ~ /TEXTDISP_FINDMODEACTIVEFLAG/) has_find_mode = 1
    if (uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ && uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/) has_group_count = 1
    if (uline ~ /TEXTDISP_SHOULDOPENEDITORFORENTRY\(PC\)/) has_editor = 1
    if (uline ~ /^\.RECORD_MATCH:/ || uline ~ /TEXTDISP_CANDIDATEINDEXLIST/) has_record = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D4-D7\/A2-A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_WILDCARD=" has_wildcard
    print "HAS_FIND_MODE=" has_find_mode
    print "HAS_GROUP_COUNT=" has_group_count
    print "HAS_EDITOR=" has_editor
    print "HAS_RECORD=" has_record
    print "HAS_RESTORE=" has_restore
}
