BEGIN{h_entry=0;h_out_clear=0;h_row_guard=0;h_row_wrap=0;h_row_end_clamp=0;h_row49_gate=0;h_field_select=0;h_elig=0;h_timefmt=0;h_preset=0;h_bit_test=0;h_cmp=0;h_skip=0;h_append=0;h_sep=0;h_setbit=0;h_fallback=0;h_title_ptr=0;h_prefix_skip=0;h_bit5_skip=0;h_bit7_skip=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_APPENDSHOWTIMESFORROW:/ || l ~ /^NEWGRID_APPENDSHOWTIMESFORROW[A-Z0-9_]*:/)h_entry=1
    if(l ~ /^CLR\.B[ \t]+\(/ || l ~ /OUT\[0\][ \t]*=[ \t]*0/)h_out_clear=1
    if(l ~ /TST\.W D[0-7]/ || l ~ /CMP\.W D0,D[56]/ || l ~ /CMP\.W D[56],D0/ || l ~ /ROW[ \t]*<=[ \t]*0/ || l ~ /ROW[ \t]*>=[ \t]*97/)h_row_guard=1
    if(l ~ /SUBI\.W[ \t]+#\$30,D[56]/ || l ~ /ROW > 48/ || l ~ /SRCIDX = .*ROW - 48/ || l ~ /ROW = .*ROW - 48/)h_row_wrap=1
    if(l ~ /MOVEQ(\.L)?[ \t]+#\$20,D0/ || l ~ /MOVEQ(\.L)?[ \t]+#\$60,D[015]/ || l ~ /CMP\.W[ \t]+D1,D0/ || l ~ /ROWEND = .*ROW \+ 33/ || l ~ /ROWEND > 96/ || l ~ /ROWEND = .*ROWEND \+ 1/)h_row_end_clamp=1
    if(l ~ /MOVEQ(\.L)?[ \t]+#(\$31|49),D0/ || l ~ /CMP\.W[ \t]+D0,D[56]/ && l ~ /#(\$31|49)/)h_row49_gate=1
    if(l ~ /(JSR|BSR).*COI_SELECTANIMFIELDPOINTER/ || l ~ /COI_SELECTANIMFIELDPOIN/ || l ~ /COI_SELECTANIMFI/)h_field_select=1
    if(l ~ /(JSR|BSR).*TESTENTRYGRIDELIGIBILITY/ || l ~ /TESTENTRYGRIDELIGIB/ || l ~ /TESTENTR/)h_elig=1
    if(l ~ /(JSR|BSR).*TEXTDISP_FORMATENTRYTIMEFORINDEX/ || l ~ /FORMATENTRYTIMEFORINDEX/)h_timefmt=1
    if(l ~ /(JSR|BSR).*NEWGRID_UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_preset=1
    if(l ~ /(JSR|BSR).*ESQ_TESTBIT1BASED/ || l ~ /TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit_test=1
    if(l ~ /CMP\.B/ || l ~ /CMPA\.L/)h_cmp=1
    if(l ~ /(JSR|BSR).*STR_SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CH/)h_skip=1
    if(l ~ /(JSR|BSR).*STRING_APPENDATNULL/ || l ~ /APPENDATNULL/ || l ~ /APPENDATN/)h_append=1
    if(l ~ /SHOWTIMELISTSEPARATOR/)h_sep=1
    if(l ~ /(56|\\$38)\(A1\)/ || l ~ /(56|\\$38)\(A0\)/ || l ~ /TITLEPTRS/ || l ~ /AUXCUR->TITLEPTRS/ || l ~ /SKIP_TIME_PREFIX/)h_title_ptr=1
    if(l ~ /CMP\.B[ \t]+\((A6|A0|A2)\),D0/ || l ~ /CMP\.B[ \t]+3\((A6|A1|A2)\),D0/ || l ~ /SKIP_TIME_PREFIX/)h_prefix_skip=1
    if(l ~ /BTST[ \t]+#(\$5|5)/ || l ~ /& 0X20/)h_bit5_skip=1
    if(l ~ /BTST[ \t]+#(\$7|7)/ || l ~ /& 0X80/)h_bit7_skip=1
    if(l ~ /BSET[ \t]+#5/ || l ~ /\|= 0X20/ || l ~ /ORI\.B #\$20/ || l ~ /OR\.B .*#\$20/ || l ~ /OR\.B \$7\(A0\),D0/)h_setbit=1
    if(l ~ /SHOWING_AT/ || l ~ /SHOWTIMES_AND_SINGLE_SPACE/)h_fallback=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_OUTPUT_CLEAR="h_out_clear
    print "HAS_ROW_GUARD="h_row_guard
    print "HAS_ROW_WRAP="h_row_wrap
    print "HAS_ROW_END_CLAMP="h_row_end_clamp
    print "HAS_ROW49_GATE="h_row49_gate
    print "HAS_FIELD_SELECT="h_field_select
    print "HAS_ELIGIBILITY="h_elig
    print "HAS_TIME_FORMAT="h_timefmt
    print "HAS_PRESET_UPDATE="h_preset
    print "HAS_BIT_TEST="h_bit_test
    print "HAS_COMPARE_CHAIN="h_cmp
    print "HAS_SKIP_CLASS3="h_skip
    print "HAS_APPEND_AT_NULL="h_append
    print "HAS_SEPARATOR="h_sep
    print "HAS_TITLE_PTR_COMPARE="h_title_ptr
    print "HAS_TIME_PREFIX_SKIP="h_prefix_skip
    print "HAS_ROW_FLAG5_SKIP="h_bit5_skip
    print "HAS_ROW_FLAG7_SKIP="h_bit7_skip
    print "HAS_MARK_ENTRY_BIT="h_setbit
    print "HAS_FALLBACK_PREFIX="h_fallback
    print "HAS_RTS="h_rts
}
