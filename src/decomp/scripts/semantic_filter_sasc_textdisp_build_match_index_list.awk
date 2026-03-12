BEGIN {
    has_entry=0
    has_wildcard=0
    has_open_editor=0
    has_active_group=0
    has_primary_count=0
    has_secondary_count=0
    has_primary_tables=0
    has_secondary_tables=0
    has_candidate_list=0
    has_find_mode=0
    has_sbe_filter=0
    has_const69=0
    has_bit3=0
    has_bit4=0
    has_bit7=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_BUILDMATCHINDEXLIST:/ || u ~ /^TEXTDISP_BUILDMATCHINDEXLIS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /UNKNOWNJMPTBLESQWILDCARDMATCH/ || n ~ /ESQWILDCARDMATCH/) has_wildcard=1
    if (n ~ /TEXTDISPSHOULDOPENEDITORFORENTRY/ || n ~ /TEXTDISPSHOULDOPENEDITORFORENTR/) has_open_editor=1
    if (n ~ /TEXTDISPACTIVEGROUPID/) has_active_group=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/) has_primary_count=1
    if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPSECONDARYGROUPENTRYCOUN/) has_secondary_count=1
    if (n ~ /TEXTDISPPRIMARYTITLEPTRTABLE/ || n ~ /TEXTDISPPRIMARYENTRYPTRTABLE/) has_primary_tables=1
    if (n ~ /TEXTDISPSECONDARYTITLEPTRTABLE/ || n ~ /TEXTDISPSECONDARYENTRYPTRTABLE/) has_secondary_tables=1
    if (n ~ /TEXTDISPCANDIDATEINDEXLIST/) has_candidate_list=1
    if (n ~ /TEXTDISPFINDMODEACTIVEFLAG/ || n ~ /TEXTDISPTAGFIND1/) has_find_mode=1
    if (n ~ /TEXTDISPSBEFILTERACTIVEFLAG/ || n ~ /TEXTDISPTAGSBE/) has_sbe_filter=1
    if (u ~ /#69([^0-9]|$)/ || u ~ /#\$45/ || u ~ /\(\$45\)/) has_const69=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3/) has_bit3=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4/) has_bit4=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /#\$7/) has_bit7=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_WILDCARD_CALL="has_wildcard
    print "HAS_OPEN_EDITOR_CALL="has_open_editor
    print "HAS_ACTIVE_GROUP_GLOBAL="has_active_group
    print "HAS_PRIMARY_COUNT_GLOBAL="has_primary_count
    print "HAS_SECONDARY_COUNT_GLOBAL="has_secondary_count
    print "HAS_PRIMARY_TABLES="has_primary_tables
    print "HAS_SECONDARY_TABLES="has_secondary_tables
    print "HAS_CANDIDATE_LIST_GLOBAL="has_candidate_list
    print "HAS_FIND_MODE_FLAG="has_find_mode
    print "HAS_SBE_FILTER_FLAG="has_sbe_filter
    print "HAS_CONST_69="has_const69
    print "HAS_BIT3_TEST="has_bit3
    print "HAS_BIT4_TEST="has_bit4
    print "HAS_BIT7_TEST="has_bit7
    print "HAS_RTS="has_rts
}
