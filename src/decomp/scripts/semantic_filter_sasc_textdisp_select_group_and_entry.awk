BEGIN {
    has_entry=0
    has_reset_state=0
    has_build_list_call=0
    has_best_match_call=0
    has_group2_fallback=0
    has_no_match_return0=0
    has_select_result_branch=0
    has_set_current_index=0
    has_return1=0
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

    if (u ~ /^TEXTDISP_SELECTGROUPANDENTRY:/ || u ~ /^TEXTDISP_SELECTGROUPANDENTR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /PRIMARYFIRSTMATCHINDEX/ || n ~ /SECONDARYFIRSTMATCHINDEX/ || n ~ /SBEFILTERACTIVEFLAG/) has_reset_state=1
    if (n ~ /BUILDMATCHINDEXLIST/) has_build_list_call=1
    if (n ~ /SELECTBESTMATCHFROMLIST/) has_best_match_call=1
    if (n ~ /SECONDARYGROUPRECORDLENGTH/ || n ~ /SECONDARYGROUPRECORDLEN/ || n ~ /ACTIVEGROUPID/ && n ~ /MOVEW0/) has_group2_fallback=1
    if (n ~ /MOVEQ0D0/ && n ~ /RETURN/ || n ~ /NO_MATCH/) has_no_match_return0=1
    if (n ~ /CMPW2D5/ || n ~ /SELECTRESULT/) has_select_result_branch=1
    if (n ~ /CURRENTMATCHINDEX/ || n ~ /BANNERFALLBACKENTRYINDEX/ || n ~ /BANNERSELECTEDENTRYINDEX/ || n ~ /CANDIDATEINDEXLIST/) has_set_current_index=1
    if (n ~ /MOVEQ(L)?1D0/) has_return1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RESET_STATE=" has_reset_state
    print "HAS_BUILD_LIST_CALL=" has_build_list_call
    print "HAS_BEST_MATCH_CALL=" has_best_match_call
    print "HAS_GROUP2_FALLBACK=" has_group2_fallback
    print "HAS_NO_MATCH_RETURN0=" has_no_match_return0
    print "HAS_SELECT_RESULT_BRANCH=" has_select_result_branch
    print "HAS_SET_CURRENT_INDEX=" has_set_current_index
    print "HAS_RETURN1=" has_return1
    print "HAS_RTS=" has_rts
}
