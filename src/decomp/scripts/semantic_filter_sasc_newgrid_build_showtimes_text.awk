BEGIN{
    h_entry=0
    h_group_guard=0
    h_out_clear=0
    h_row_wrap=0
    h_field_select=0
    h_timefmt=0
    textlen_count=0
    h_width_budget=0
    h_suffix_measure=0
    h_reset=0
    h_index_clamp=0
    h_row_limit=0
    h_update=0
    h_prev=0
    h_sel=0
    h_bit=0
    h_cmp=0
    cmp_chain_count=0
    h_row_mark=0
    h_bucket_add=0
    h_bucket_append=0
    h_append=0
    h_prefix=0
    h_showing_at=0
    h_genre=0
    h_rts=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_BUILDSHOWTIMESTEXT:/ || l ~ /^NEWGRID_BUILDSHOWTIMESTEXT[A-Z0-9_]*:/)h_entry=1
    if(l ~ /TEXTDISP_PRIMARYGROUPPRESENTFLAG/ || l ~ /BTST #\$4,\$2F\(A[0-7]\)/ || l ~ /BTST #4,47\(A[0-7]\)/)h_group_guard=1
    if(l ~ /^CLR\.B \([A0-7]\)$/)h_out_clear=1
    if(l ~ /^SUBI\.W #\$30,D[0-7]$/ || l ~ /^SUBI\.W #48,D[0-7]$/)h_row_wrap=1
    if(l ~ /(JSR|BSR).*COI_SELECTANIMFIELDPOINTER/ || l ~ /COI_SELECTANIMFI/)h_field_select=1
    if(l ~ /(JSR|BSR).*TEXTDISP_FORMATENTRYTIMEFORINDEX/ || l ~ /FORMATENTRYTIMEFORINDEX/)h_timefmt=1
    if(l ~ /(JSR|BSR).*LVOTEXTLENGTH/ || l ~ /_LVOTEXTLENGTH/)textlen_count++
    if(index(l, "MOVE.L #$264,") == 1 || index(l, "MOVE.L #612,") == 1)h_width_budget=1
    if(l ~ /GLOBAL_STR_COMMA_AND_SINGLE_SPACE_1/ || l ~ /__MERGED\+\$2\(A4\)/)h_suffix_measure=1
    if(l ~ /(JSR|BSR).*NEWGRID_RESETSHOWTIMEBUCKETS/ || l ~ /RESETSHOWTIMEBUCKETS/)h_reset=1
    if(l ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/)h_index_clamp=1
    if(l ~ /GCOMMAND_PPVSHOWTIMESROWSPAN/ || l ~ /^MOVEQ(\.L)? #\$61,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #97,D[0-7]$/)h_row_limit=1
    if(l ~ /(JSR|BSR).*NEWGRID_UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_update=1
    if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTRY/ || l ~ /FINDPREV/)h_prev=1
    if(l ~ /(JSR|BSR).*PROCESSENTRYSELECTIONSTATE/ || l ~ /PROCESSENTRYSELECTION/ || l ~ /PROCESSENTRY/)h_sel=1
    if(l ~ /(JSR|BSR).*TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit=1
    if(l ~ /CMP\.B/ || l ~ /CMPA\.L/ || l ~ /STR_EQ_NULLABLE/)h_cmp=1
    if(l ~ /STR_EQ_NULLABLE/ || l ~ /^\.COMPARE_(TITLE|SUBTITLE|GENRE|RATING)/)cmp_chain_count++
    if(l ~ /^BSET #5,7\(A[0-7]\)$/ || l ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #32,D[0-7]$/ || l ~ /^OR\.B \$7\(A[0-7]\),D[0-7]$/)h_row_mark=1
    if(l ~ /(JSR|BSR).*NEWGRID_ADDSHOWTIMEBUCKETENTRY/ || l ~ /ADDSHOWTIMEBUCKETENTRY/)h_bucket_add=1
    if(l ~ /(JSR|BSR).*NEWGRID_APPENDSHOWTIMEBUCKETS/ || l ~ /APPENDSHOWTIMEBUCKETS/)h_bucket_append=1
    if(l ~ /(JSR|BSR).*STRING_APPENDATNULL/ || l ~ /APPENDATN/)h_append=1
    if(l ~ /SHOWTIMES_AND_SINGLE/ || l ~ /SHOWING_AT_AND_SINGLE/)h_prefix=1
    if(l ~ /SHOWING_AT_AND_SINGLE/)h_showing_at=1
    if(l ~ /SHOWTIMEGENRESPACER/)h_genre=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_GROUP_GUARD="h_group_guard
    print "HAS_OUT_CLEAR="h_out_clear
    print "HAS_ROW_WRAP="h_row_wrap
    print "HAS_FIELD_SELECT="h_field_select
    print "HAS_TIME_FORMAT="h_timefmt
    print "HAS_TEXT_MEASURE="(textlen_count >= 4)
    print "HAS_WIDTH_BUDGET="h_width_budget
    print "HAS_SUFFIX_MEASURE="h_suffix_measure
    print "HAS_RESET_BUCKETS="h_reset
    print "HAS_INDEX_CLAMP="h_index_clamp
    print "HAS_ROW_LIMIT="h_row_limit
    print "HAS_UPDATE_PRESET="h_update
    print "HAS_FIND_PREVIOUS="h_prev
    print "HAS_SELECTION_STATE="h_sel
    print "HAS_TEST_BIT="h_bit
    print "HAS_COMPARE_CHAIN="h_cmp
    print "HAS_COMPARE_CHAIN_DEPTH="(cmp_chain_count >= 4)
    print "HAS_ROW_MARK="h_row_mark
    print "HAS_BUCKET_ADD="h_bucket_add
    print "HAS_BUCKET_APPEND="h_bucket_append
    print "HAS_APPEND_AT_NULL="h_append
    print "HAS_PREFIXES="h_prefix
    print "HAS_SHOWING_AT="h_showing_at
    print "HAS_GENRE_SUFFIX="h_genre
    print "HAS_RTS="h_rts
}
