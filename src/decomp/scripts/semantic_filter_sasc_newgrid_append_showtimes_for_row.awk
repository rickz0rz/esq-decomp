BEGIN{h_entry=0;h_field_select=0;h_elig=0;h_timefmt=0;h_preset=0;h_bit_test=0;h_cmp=0;h_skip=0;h_append=0;h_sep=0;h_setbit=0;h_fallback=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_APPENDSHOWTIMESFORROW:/ || l ~ /^NEWGRID_APPENDSHOWTIMESFORROW[A-Z0-9_]*:/)h_entry=1
    if(l ~ /(JSR|BSR).*COI_SELECTANIMFIELDPOINTER/ || l ~ /COI_SELECTANIMFIELDPOIN/ || l ~ /COI_SELECTANIMFI/)h_field_select=1
    if(l ~ /(JSR|BSR).*TESTENTRYGRIDELIGIBILITY/ || l ~ /TESTENTRYGRIDELIGIB/ || l ~ /TESTENTR/)h_elig=1
    if(l ~ /(JSR|BSR).*TEXTDISP_FORMATENTRYTIMEFORINDEX/ || l ~ /FORMATENTRYTIMEFORINDEX/)h_timefmt=1
    if(l ~ /(JSR|BSR).*NEWGRID_UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_preset=1
    if(l ~ /(JSR|BSR).*ESQ_TESTBIT1BASED/ || l ~ /TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit_test=1
    if(l ~ /CMP\.B/ || l ~ /CMPA\.L/)h_cmp=1
    if(l ~ /(JSR|BSR).*STR_SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CH/)h_skip=1
    if(l ~ /(JSR|BSR).*STRING_APPENDATNULL/ || l ~ /APPENDATNULL/ || l ~ /APPENDATN/)h_append=1
    if(l ~ /SHOWTIMELISTSEPARATOR/)h_sep=1
    if(l ~ /BSET[ \t]+#5/ || l ~ /\|= 0X20/ || l ~ /ORI\.B #\$20/ || l ~ /OR\.B .*#\$20/ || l ~ /OR\.B \$7\(A0\),D0/)h_setbit=1
    if(l ~ /SHOWING_AT/ || l ~ /SHOWTIMES_AND_SINGLE_SPACE/)h_fallback=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_FIELD_SELECT="h_field_select
    print "HAS_ELIGIBILITY="h_elig
    print "HAS_TIME_FORMAT="h_timefmt
    print "HAS_PRESET_UPDATE="h_preset
    print "HAS_BIT_TEST="h_bit_test
    print "HAS_COMPARE_CHAIN="h_cmp
    print "HAS_SKIP_CLASS3="h_skip
    print "HAS_APPEND_AT_NULL="h_append
    print "HAS_SEPARATOR="h_sep
    print "HAS_MARK_ENTRY_BIT="h_setbit
    print "HAS_FALLBACK_PREFIX="h_fallback
    print "HAS_RTS="h_rts
}
